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

// tm upTime(){
    
// }

void Tamagotchi::frame(pm25* data, size_t selectedIndex){
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

    screen.getTextBounds("00:00", 0, 0, &x1, &y1, &w, &h);
    cursorX = screen.width() - w;
    cursorY = screen.height() - h;
    screen.setCursor(cursorX, cursorY);
    screen.println(&timeinfo, "%H:%M");


    screen.drawRect(rectX, rectY, rectWidth, rectHeight, SSD1306_WHITE);
}

void Tamagotchi::status(pm25* data, size_t selectedIndex) {
    posX = -39;
    posY = 10;
    while(posX<120+39){
        screen.clearDisplay();
        frame(data, selectedIndex);
        if(data[selectedIndex].value.toInt() > 50){
            screen.drawBitmap(posX, posY, Tamagotch_dn, 39,39, SSD1306_WHITE);
        } else {
            screen.drawBitmap(posX, posY, Tamagotch_no, 39,39, SSD1306_WHITE);
        }
        if(posX==60-39/2){
            sleep(5);
        }
        posX+=3;
        screen.display();
    }
}


void Tamagotchi::adjustDirection() {
    directionX = random(-100, 110) / 10.0;
    directionY = random(-10, 11) / 10.0;
    
    if (directionX == 0 && directionY == 0) {
        directionX = 0.1;
    }

    float magnitude = sqrt(directionX * directionX + directionY * directionY);
    directionX /= magnitude;
    directionY /= magnitude;


    if (abs(directionX) > abs(directionY)) {
        currentBitmap = (directionX > 0) ? TamagotchiBitRight : TamagotchiBitLeft;
    }
    // else {
    //     currentBitmap = (directionY > 0) ? TamagotchiBitDown : TamagotchiBitUp;
    // }
}

void Tamagotchi::pet(pm25* data, size_t selectedIndex) {
    screen.clearDisplay();

    posX += speed * directionX;
    posY += speed * directionY;

    if (posX <= rectX || posX >= rectX + rectWidth - 15) {
        if (posX <= rectX) {
            posX = rectX;
        } else {
            posX = rectX + rectWidth - 15;
        }
        adjustDirection();
    }
    if (posY <= rectY || posY >= rectY + rectHeight - 15) {
        if (posY <= rectY) {
            posY = rectY;
        } else {
            posY = rectY + rectHeight - 15;
        }
        adjustDirection();
    }

    frame(data, selectedIndex);
    screen.drawBitmap(posX, posY, currentBitmap, 15,15, SSD1306_WHITE);

    screen.display();
}


