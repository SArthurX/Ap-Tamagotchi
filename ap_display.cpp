#include "ap_display.h"

void Tamagotchi::bootloader(){
    screen.clearDisplay();
    screen.display();
    screen.setTextSize(1);
    screen.setTextColor(WHITE);
    screen.setCursor(0, 0);
    screen.println("Loading...");
    screen.display();
}

int Tamagotchi::selec(pm25* data, size_t size) {
    size_t selectedIndex = 0;  
    menu(data, size, selectedIndex);  

    while (true) {
        if (Serial.available() > 0) {
            String input = Serial.readStringUntil('\n');
            input.trim();  
            if (input.equalsIgnoreCase("down")) {
                selectedIndex = (selectedIndex + 1) % size; 
                menu(data, size, selectedIndex);  
            } else if (input.equalsIgnoreCase("select")) {
                return selectedIndex;  
            }
        }
    }
}

void Tamagotchi::menu(pm25* data, size_t size, size_t selectedIndex) {
    screen.clearDisplay();
    screen.setTextSize(1);
    screen.setTextColor(SSD1306_WHITE);
    screen.setCursor(0, 0);

    for (size_t i = 0; i < size; i++) {
        if (i == selectedIndex) {
            screen.print("-> "); 
        } else {
            screen.print("   ");
        }
        screen.println(data[i].area);  
    }
    screen.display();
}


void Tamagotchi::ds(){
    Serial.println("ds");
}