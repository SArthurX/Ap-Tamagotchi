#include "menu.h"

int selec(pm25* data, size_t size) {
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

void menu(pm25* data, size_t size, size_t selectedIndex) {
    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);

    for (size_t i = 0; i < size; i++) {
        if (i == selectedIndex) {
            display.print("-> "); 
        } else {
            display.print("   ");
        }
        display.println(data[i].area);  
    }
    display.display();
}
