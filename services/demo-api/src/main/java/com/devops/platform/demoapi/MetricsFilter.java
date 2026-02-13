package com.devops.platform.demoapi;

import io.prometheus.client.Counter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class MetricsFilter extends OncePerRequestFilter {

  private static final Counter REQUESTS =
      Counter.build()
          .name("demo_api_requests_total")
          .help("Total requests")
          .labelNames("path")
          .register();

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {
    REQUESTS.labels(request.getRequestURI()).inc();
    filterChain.doFilter(request, response);
  }
}
