#include "get.h"

int i = 0;

void getData(pm25* data, size_t size) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverName);
    http.addHeader("accept", "*/*");
    if (http.GET() > 0) {
      String payload = http.getString();
      DynamicJsonDocument doc(10000);
      // Serial.println(payload);
      DeserializationError error = deserializeJson(doc, payload);
      if (!error) {
        JsonArray records = doc["records"];
        for (JsonObject record : records) {
          const char* itemname = record["itemengname"];
          if (strcmp(itemname, "PM2.5") == 0) {
            if(i < size){
              data[i].city = String(record["county"]);
              data[i].area = String(record["sitename"]);
              data[i].value = String(record["concentration"]);
              // Serial.print("縣市: ");
              // Serial.print(data[i].city);
              // Serial.print(", 區域: ");
              // Serial.print(data[i].area);
              // Serial.print(", PM2.5: ");
              // Serial.print(data[i].value);
              // Serial.println(" μg/m3");
              i++;
            }
          }
        }
      } else {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.f_str());
      }
    } else {
      Serial.print("Error on HTTP request: ");
      Serial.println(http.GET());
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}
