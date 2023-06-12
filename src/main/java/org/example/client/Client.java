package org.example.client;

import lombok.SneakyThrows;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.concurrent.TimeUnit;

public class Client {
  @SneakyThrows
  public static boolean javaCheck(final String url) {
    // System.setProperty("jdk.internal.httpclient.debug", "true");
    final HttpClient client = HttpClient.newHttpClient();
    final HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(url))
        .GET()
        .build();
    final HttpResponse<Void> response = client.send(request, HttpResponse.BodyHandlers.discarding());
    return isOk(response.statusCode());
  }

  @SneakyThrows
  public static boolean curlCheck(final String url) {
    final Process process = new ProcessBuilder("curl", /*"-vv",*/ url)
        .inheritIO()
        .start();
    process.waitFor(30, TimeUnit.SECONDS);
    return 0 == process.exitValue();
  }

  private static boolean isOk(final int statusCode) {
    return 200 <= statusCode && statusCode <= 299;
  }
}
