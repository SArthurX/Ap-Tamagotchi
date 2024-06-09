#include "pm25.h"

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

airChicken chicken;

void loop() {
    static const int dataSize = 7;
    static pm25 data[dataSize];
    static int selectedIndex = -1; 

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
            Serial.println("Menu");
            selectedIndex = selec(data, dataSize);  
            Serial.print("Selected Index: ");
            Serial.println(selectedIndex);
            currentState = SHOW;
            break;
        case SHOW:
            currentState = BOOT;
            chicken.ds();
            break;
    }
}