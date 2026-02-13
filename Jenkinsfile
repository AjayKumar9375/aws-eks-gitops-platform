pipeline {
  agent any

  options {
    timestamps()
  }

  parameters {
    booleanParam(name: 'PUSH_IMAGE', defaultValue: false, description: 'Push Docker image to ECR')
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region for ECR')
    string(name: 'ECR_REPO', defaultValue: '123456789012.dkr.ecr.us-east-1.amazonaws.com/demo-api', description: 'ECR repository URI')
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

    stage('Manual Approval') {
      when {
        allOf {
          branch 'main'
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

    stage('Push Docker Image (main only)') {
      when {
        allOf {
          branch 'main'
          expression { return params.PUSH_IMAGE }
        }
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
          sh '''
            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
            docker tag demo-api:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
            docker push ${ECR_REPO}:${IMAGE_TAG}
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
