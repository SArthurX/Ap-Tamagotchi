#include "pm25.h"

Adafruit_SSD1306 screen(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
State currentState = BOOT;

void setup() {
    Serial.begin(115200);

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    if (!screen.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
        Serial.println(F("SSD1306 allocation failed"));
        for (;;);
    }

    pinMode(18, INPUT_PULLUP);
    screen.clearDisplay();
}

Tamagotchi apt;

void loop() {
    static const int dataSize = 7;
    static pm25 data[dataSize];
    static int selectedIndex = -1; 

    switch (currentState) {
        case BOOT:
            currentState = GET;
            Serial.println("Bootloader");
            apt.bootloader();
            break;
        case GET:
            currentState = MENU;
            Serial.println("GETinfo");
            getData(data, dataSize);
            break;
        case MENU:
            currentState = Frame;
            Serial.println("Menu");
            selectedIndex = apt.selec(data, dataSize);  
            break;
        case Frame:
            currentState = SHOW;
            apt.frame(data, selectedIndex);
            break;
        case SHOW:
            //currentState = BOOT;
            break;
    }
}
