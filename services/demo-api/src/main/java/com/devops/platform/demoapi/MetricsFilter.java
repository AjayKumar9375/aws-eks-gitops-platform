package com.devops.platform.demoapi;

import io.prometheus.client.Counter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerMapping;

@Component
public class MetricsFilter extends OncePerRequestFilter {

  private static final Counter REQUESTS =
      Counter.build()
          .name("demo_api_requests_total")
          .help("Total requests")
          .labelNames("method", "path", "status")
          .register();

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {
    try {
      filterChain.doFilter(request, response);
    } finally {
      String pattern =
          String.valueOf(request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE));
      if ("null".equals(pattern)) {
        pattern = request.getRequestURI();
      }
      REQUESTS.labels(request.getMethod(), pattern, String.valueOf(response.getStatus())).inc();
    }
  }
}
