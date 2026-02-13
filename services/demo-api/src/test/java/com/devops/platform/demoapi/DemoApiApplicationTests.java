package com.devops.platform.demoapi;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class DemoApiApplicationTests {

  @Autowired private MockMvc mockMvc;

  @Test
  void healthzShouldReturnOk() throws Exception {
    mockMvc.perform(get("/healthz")).andExpect(status().isOk()).andExpect(content().string("ok"));
  }

  @Test
  void readyzShouldReturnReady() throws Exception {
    mockMvc.perform(get("/readyz")).andExpect(status().isOk()).andExpect(content().string("ready"));
  }

  @Test
  void rootShouldReturnServiceMetadata() throws Exception {
    mockMvc
        .perform(get("/"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.service").value("demo-api"))
        .andExpect(jsonPath("$.status").value("ok"));
  }

  @Test
  void metricsShouldContainRequestCounter() throws Exception {
    mockMvc.perform(get("/healthz")).andExpect(status().isOk());
    mockMvc
        .perform(get("/metrics"))
        .andExpect(status().isOk())
        .andExpect(
            content().string(org.hamcrest.Matchers.containsString("demo_api_requests_total")))
        .andExpect(content().string(org.hamcrest.Matchers.containsString("path=\"/healthz\"")));
  }
}
