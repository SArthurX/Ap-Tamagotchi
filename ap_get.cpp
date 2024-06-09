#include "ap_get.h"

const char* ssid = "YOUR_AP_SSID";
const char* password = "YOUR_AP_PASS";
const char* serverName = "https://data.moenv.gov.tw/api/v2/aqx_p_133?language=en&api_key=YOUR_API_KEY&filters=itemengname,EQ,PM2.5|county,EQ,Taipei%20City|monitordate,EQ,2024-06-09%2000:00";

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
