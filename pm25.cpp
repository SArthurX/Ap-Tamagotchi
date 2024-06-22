#include "pm25.h"

Adafruit_SSD1306 screen(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

static const int dataSize = 7;
static pm25 data[dataSize];
static int selectedIndex = -1; 

const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 3600 * 8;
struct tm timeinfo;

void setup() {
    Serial.begin(115200);
    pinMode(18, INPUT_PULLUP);
    // randomSeed(42);
    randomSeed(analogRead(0));

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    if (!screen.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
        Serial.println(F("SSD1306 allocation failed"));
    }

    configTime(gmtOffset_sec, 0, ntpServer);
    if(!getLocalTime(&timeinfo)){
        Serial.println("Failed to obtain time");
    }
    Serial.println(&timeinfo, "%A, %B %d %Y %H:%M:%S");

    screen.clearDisplay();
}

Tamagotchi apt;
State currentState = BOOT;
unsigned long previousUpdae = 0;
unsigned long holdTime = 0;
unsigned long prevTime = 0;

void loop() {
    unsigned long updateTime = millis();
    unsigned long timeCurrent = millis();
    unsigned long nowTime = millis();

    if (nowTime - prevTime >= 1000) {
        getLocalTime(&timeinfo);
        prevTime = nowTime;
    }

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
            currentState = Status;
            Serial.println("Menu");
            selectedIndex = apt.selec(data, dataSize);  
            break;
        case Status:
            currentState = Frame;
            apt.status(data, selectedIndex);
            break;
        case Frame:
            apt.pet(data, selectedIndex);

            if (digitalRead(18) == LOW) {
                if (holdTime == 0) {  
                    holdTime = timeCurrent;
                } else if ((timeCurrent - holdTime) > 1000) { 
                    currentState = Status;
                }
            } else {
                    holdTime = 0;
                }

            if (updateTime - previousUpdae >= 3600000) {
                previousUpdae = updateTime; 
                getData(data, dataSize);
            }
            break;
    }
}
