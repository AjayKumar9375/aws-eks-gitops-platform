pipeline {
  agent any

  options {
    timestamps()
  }

  parameters {
    booleanParam(name: 'PUSH_IMAGE', defaultValue: false, description: 'Push Docker image to ECR')
    string(name: 'AWS_REGION', defaultValue: '', description: 'AWS region for ECR (or set env AWS_REGION)')
    string(name: 'ECR_REPO', defaultValue: '', description: 'ECR repository URI (or set env ECR_REPO)')
    string(name: 'AWS_CREDENTIALS_ID', defaultValue: 'aws-jenkins-creds', description: 'Jenkins AWS credentials ID')
  }

  environment {
    IMAGE_TAG = "${env.GIT_COMMIT}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Lint and Test (Java)') {
      steps {
        dir('services/demo-api') {
          sh 'mvn -B -ntp spotless:check test'
        }
      }
    }

    stage('Terraform Format Check') {
      steps {
        sh 'terraform fmt -check -recursive infra/terraform'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t demo-api:${IMAGE_TAG} services/demo-api'
      }
    }

    stage('Validate Publish Configuration') {
      when {
        expression { return params.PUSH_IMAGE }
      }
      steps {
        script {
          env.EFFECTIVE_AWS_REGION = params.AWS_REGION?.trim() ? params.AWS_REGION.trim() : (env.AWS_REGION ?: '')
          env.EFFECTIVE_ECR_REPO = params.ECR_REPO?.trim() ? params.ECR_REPO.trim() : (env.ECR_REPO ?: '')
          if (!env.EFFECTIVE_AWS_REGION?.trim()) {
            error('AWS region is required. Set parameter AWS_REGION or Jenkins env AWS_REGION.')
          }
          if (!env.EFFECTIVE_ECR_REPO?.trim()) {
            error('ECR repo is required. Set parameter ECR_REPO or Jenkins env ECR_REPO.')
          }
        }
      }
    }

    stage('Manual Approval') {
      when {
        allOf {
          branch 'master'
          expression { return params.PUSH_IMAGE }
        }
      }
      steps {
        input(
          message: "Approve pushing demo-api:${IMAGE_TAG} to ECR?",
          ok: 'Approve Push'
        )
      }
    }

    stage('Push Docker Image (master only)') {
      when {
        allOf {
          branch 'master'
          expression { return params.PUSH_IMAGE }
        }
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${params.AWS_CREDENTIALS_ID}"]]) {
          sh '''
            aws ecr get-login-password --region ${EFFECTIVE_AWS_REGION} | docker login --username AWS --password-stdin ${EFFECTIVE_ECR_REPO}
            docker tag demo-api:${IMAGE_TAG} ${EFFECTIVE_ECR_REPO}:${IMAGE_TAG}
            docker push ${EFFECTIVE_ECR_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    always {
      junit allowEmptyResults: true, testResults: 'services/demo-api/target/surefire-reports/*.xml'
    }
  }
}
