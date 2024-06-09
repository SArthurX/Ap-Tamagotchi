#include "func.h"
#include "boot.h"
#include "get.h"
#include "menu.h"

#define dataSize 7
pm25 data[dataSize];

typedef enum {
    BOOT,
    GET,
    MENU,
    SHOW
} State;

State currentState = BOOT;

void setup() {
    Serial.begin(115200);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
        Serial.println(F("SSD1306 allocation failed"));
        for (;;);
    }

    display.clearDisplay();
}

void loop() {
    switch (currentState) {
        case BOOT:
            currentState = GET;
            Serial.println("Bootloader");
            // bootloader();
        break;
        case GET:
            currentState = MENU;
            Serial.println("GETinfo");
            getData(data, dataSize);
        break;
        case MENU:
            currentState = SHOW;
            Serial.println("Menu");
            int selectedIndex = selec(data, dataSize);  
            Serial.print("Selected Index: ");
            Serial.println(selectedIndex);
        break;
        case SHOW:
            currentState = BOOT;
            showBootScreen();
        break;
    }
}