#ifndef GET_H
#define GET_H

#include "func.h"

typedef struct {
    String city;
    String area;
    String value;
} pm25;

void getData(pm25* data, size_t size);

extern const char* ssid = "YOUR_AP_SSID";
extern const char* password = "YOUR_AP_PASS";
const char* serverName = "https://data.moenv.gov.tw/api/v2/aqx_p_133?language=en&api_key=YOUR_API_KEY&filters=itemengname,EQ,PM2.5|county,EQ,Taipei%20City|monitordate,EQ,2024-06-09%2000:00";

#endif