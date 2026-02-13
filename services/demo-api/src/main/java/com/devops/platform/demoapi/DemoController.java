package com.devops.platform.demoapi;

import io.prometheus.client.CollectorRegistry;
import io.prometheus.client.exporter.common.TextFormat;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {

  @GetMapping("/")
  public Map<String, String> root() {
    return Map.of("service", "demo-api", "status", "ok");
  }

  @GetMapping("/healthz")
  public String healthz() {
    return "ok";
  }

  @GetMapping("/readyz")
  public String readyz() {
    return "ready";
  }

  @GetMapping(value = "/metrics", produces = MediaType.TEXT_PLAIN_VALUE)
  public String metrics() throws IOException {
    StringWriter writer = new StringWriter();
    TextFormat.write004(writer, CollectorRegistry.defaultRegistry.metricFamilySamples());
    return writer.toString();
  }
}
