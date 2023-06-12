package org.example;

import lombok.extern.slf4j.Slf4j;
import org.example.client.Client;

@Slf4j
public class Main {
  public static void main(String[] args) {
    if (args.length == 0) {
      log.error("Please specify url!");
      System.exit(1);
    }
    final String url = args[0];
    log.info("checking url {}", url);
    final boolean ok = Client.javaCheck(url);
    log.info("check status {}", ok);
  }
}
