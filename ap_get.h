#ifndef AP_GET_H
#define AP_GET_H

#include <Arduino.h> 
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

typedef struct {
    String city;
    String area;
    String value;
} pm25;

void getData(pm25* data, size_t size);

extern const char* ssid;
extern const char* password;
extern const char* serverName;


#endif