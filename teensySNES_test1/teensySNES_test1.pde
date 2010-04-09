#define REPEATRATE 100  // milliseconds

const int pinBtnUp = 0;
const int pinBtnRight = 1;
const int pinBtnDown = 2;
const int pinBtnLeft = 3;

const int pinBtnSelect = 4;
const int pinBtnStart = 5;

const int pinBtnB = 7;
const int pinBtnA = 8;
const int pinBtnY = 10;
const int pinBtnX = 9;

const int pinBtnTrigLeft = 6;
const int pinBtnTrigRight = 23;

const int pinLEDOutput = 11;

//Variables for the states of the SNES buttons
byte buttons[] = {pinBtnUp, pinBtnRight, pinBtnDown, pinBtnLeft, pinBtnSelect, pinBtnStart,
pinBtnB, pinBtnA, pinBtnY, pinBtnX, pinBtnTrigLeft, pinBtnTrigRight}; 
byte keys[] = {KEY_U, KEY_R, KEY_D, KEY_L, KEY_ENTER, KEY_TAB, KEY_B, KEY_A, KEY_Y, KEY_X, KEY_P, KEY_Q};

#define NUMBUTTONS sizeof(buttons)


void setup()
{
  //Setup the pin modes.
  pinMode( pinLEDOutput, OUTPUT );

  //Special for the Teensy is the INPUT_PULLUP
  //It enables a pullup resitor on the pin.
  for (byte i=0; i< NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
  }
  
  //Uncomment this line to debug the acceleromter values:
//  Serial.begin();

}


void loop()
{
//  //debugging the start button...
  digitalWrite ( pinLEDOutput, digitalRead(pinBtnStart));

  //Progess the SNES controller buttons to send keystrokes.
  fcnProcessButtons();
  
}

//Function to process the buttons from the SNES controller
void fcnProcessButtons()
{
  static long currentkey = 0;
  byte nothingpressed = 1;
  
  // run through all the buttons
  for (byte i = 0; i < NUMBUTTONS; i++) {
    
    // are any of them pressed?
    if (! digitalRead(buttons[i])) {
      nothingpressed = 0; // at least one button is pressed!
      
      // if its a new button, release the old one, and press the new one
      if (currentkey != keys[i]) {
        Keyboard.set_key1(0);
        Keyboard.send_now();
        Keyboard.set_key1(keys[i]);
        currentkey = keys[i];
        Keyboard.send_now();
      } else {
        // the same button is pressed, so repeat!
        Keyboard.set_key1(keys[i]);
        Keyboard.send_now();
        delay(100);
      }
    }
  }
  
  if (nothingpressed) {
    // release all keys
    Keyboard.set_key1(0);
    Keyboard.send_now();
  }
}



