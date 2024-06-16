#include "ap_display.h"

unsigned long timeCurrent, timePrevious;

void Tamagotchi::bootloader(){
    screen.clearDisplay();
    screen.drawBitmap(0,0, startup, 128, 64, SSD1306_WHITE);
    // screen.println("Loading...");
    screen.display();
}

void Tamagotchi::menu(pm25* data, size_t size, size_t selectedIndex) {
    screen.clearDisplay();
    screen.setTextSize(1);
    screen.setTextColor(SSD1306_WHITE);
    screen.setCursor(0, 0);

    for (size_t i = 0; i < size; i++) {
        if (i == selectedIndex) {
            screen.print(" -> "); 
        } else {
            screen.print("    ");
        }
        screen.println(String(i+1)+". "+data[i].area);  
    }
    screen.display();
}

int Tamagotchi::selec(pm25* data, size_t size) {
    size_t selectedIndex = 0;  
    menu(data, size, selectedIndex);  

    while (true) {
        if (Serial.available() > 0) {
            String input = Serial.readStringUntil('\n');
            input.trim();  
            if (input.equalsIgnoreCase("down") ){
                selectedIndex = (selectedIndex + 1) % size; 
                menu(data, size, selectedIndex);  
            } else if (input.equalsIgnoreCase("select")) {
                return selectedIndex;  
            }
        }

        timeCurrent = millis();
        if (digitalRead(18) == LOW) {
            if (timePrevious == 0) {  
                timePrevious = timeCurrent;
            } else if ((timeCurrent - timePrevious) > 1000) { 
                Serial.println(selectedIndex);
                return selectedIndex;
            }
        } else {
            if (timePrevious != 0 && (timeCurrent - timePrevious) <= 1000) { 
                timePrevious = 0;
                selectedIndex = (selectedIndex + 1) % size; 
                menu(data, size, selectedIndex);  
            } else {
                timePrevious = 0;  
            }
        }
    }
}

void Tamagotchi::frame(pm25* data, size_t selectedIndex){
    screen.clearDisplay();
    screen.setTextSize(1);
    screen.setTextColor(SSD1306_WHITE);
    
    int16_t x1, y1;
    uint16_t w, h;
    int16_t cursorX, cursorY;

    screen.getTextBounds(data[selectedIndex].city+"-"+data[selectedIndex].area, 0, 0, &x1, &y1, &w, &h);
    cursorX = screen.width() - w;
    cursorY = 0;
    screen.setCursor(cursorX, cursorY);
    screen.println(data[selectedIndex].city+" "+data[selectedIndex].area);


    screen.getTextBounds(data[selectedIndex].value + " ug/m3", 0, 0, &x1, &y1, &w, &h);
    cursorX = 0;
    cursorY = screen.height() - h;
    screen.setCursor(cursorX, cursorY);
    screen.println(data[selectedIndex].value + " ug/m3");

    for (int i = 0; i < 5; i++) {
        screen.drawBitmap(cursorX + w + 4 + (i * 8), cursorY, heartBitmap, 8, 8, SSD1306_WHITE);
    }

    screen.getTextBounds("12:34", 0, 0, &x1, &y1, &w, &h);
    cursorX = screen.width() - w;
    cursorY = screen.height() - h;
    screen.setCursor(cursorX, cursorY);
    screen.println("12:34");


    int rectWidth = 120; 
    int rectHeight = 40;
    int rectX = (screen.width() - rectWidth) / 2;
    int rectY = (screen.height() - rectHeight) / 2;
    screen.drawRect(rectX, rectY, rectWidth, rectHeight, SSD1306_WHITE);

    screen.getTextBounds("chick", 0, 0, &x1, &y1, &w, &h);
    cursorX = rectX + (rectWidth - w) / 2;
    cursorY = rectY + (rectHeight - h) / 2;
    screen.setCursor(cursorX, cursorY);
    screen.println("chick");

    screen.display();
}

// String Tamagotchi::getTimeString() {
//     return "12:34";
// }
