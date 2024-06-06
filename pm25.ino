#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "YOUR_AP_SSID";
const char* password = "YOUR_AP_PASS";
const char* serverName = "https://data.moenv.gov.tw/api/v2/aqx_p_136?filters=itemengname,EQ,PM2.5|monitordate,EQ,2024-06-05%2022:00&api_key=YOUR_API_KEY";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  
  fetchData();
}

void loop() {
  // 無需在 loop 中執行任何操作
}

void fetchData() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverName);
    http.addHeader("accept", "*/*");
    int httpResponseCode = http.GET();

    if (httpResponseCode > 0) {
      String payload = http.getString();
      // Serial.println(httpResponseCode);
      // Serial.println(payload);
      // Serial.print("JSON data size: ");
      // Serial.println(payload.length());

      DynamicJsonDocument doc(10000);
      DeserializationError error = deserializeJson(doc, payload);
      if (!error) {
        JsonArray records = doc["records"];
        for (JsonObject record : records) {
          const char* itemname = record["itemengname"];
          if (strcmp(itemname, "PM2.5") == 0) {
            const char* county = record["county"];
            const char* sitename = record["sitename"];
            const char* concentration = record["concentration"];
            Serial.print("縣市: ");
            Serial.print(county);
            Serial.print(", 區域: ");
            Serial.print(sitename);
            Serial.print(", PM2.5: ");
            Serial.print(concentration);
            Serial.println(" μg/m3");
          }
        }
      } else {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.f_str());
      }
    } else {
      Serial.print("Error on HTTP request: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}
