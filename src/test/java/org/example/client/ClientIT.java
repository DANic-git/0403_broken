package org.example.client;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class ClientIT {

  public static final String CHECK_URL = "https://www.sberbank.ru/common/img/uploaded/files/pdf/cyber/phishing_emails.pdf";

  @Test
  void javaCheck() {
    final boolean ok = Client.javaCheck(CHECK_URL);
    Assertions.assertTrue(ok);
  }

  @Test
  void curlCheck() {
    final boolean ok = Client.curlCheck(CHECK_URL);
    Assertions.assertTrue(ok);
  }
}
