#ifndef AP_DISPLAY_H
#define AP_DISPLAY_H

#include <Arduino.h> 
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include "ap_get.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1

extern Adafruit_SSD1306 screen;

typedef enum {
    BOOT,
    GET,
    MENU,
    SHOW
} State;

class Tamagotchi
{
    public:
        void bootloader();
        int selec(pm25* data, size_t size);
        void menu(pm25* data, size_t size, size_t selectedIndex); 
        void ds();
};
#endif
