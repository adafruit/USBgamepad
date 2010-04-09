#define DEBOUNCE 10  // button debouncer, how many ms to debounce, 5+ ms is usually plenty
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

// we will track if a button is just pressed, just released, or 'currently pressed' 
volatile byte pressed[NUMBUTTONS], justpressed[NUMBUTTONS], justreleased[NUMBUTTONS];

void setup()
{
  //Setup the pin modes.
  pinMode( pinLEDOutput, OUTPUT );

  //Special for the Teensy is the INPUT_PULLUP
  //It enables a pullup resitor on the pin.
  for (byte i=0; i< NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT_PULLUP);

  }

  //Zero the SNES controller button keys:
  for (byte i=0; i< NUMBUTTONS; i++) {
      pressed[i] = justpressed[i] = justreleased[i] = 0;
  }
  
  //Uncomment this line to debug the acceleromter values:
//  Serial.begin();

}


void loop()
{
//  //debugging the start button...
  digitalWrite ( pinLEDOutput, digitalRead(pinBtnStart));

  check_switches();
  //Progess the SNES controller buttons to send keystrokes.
  fcnProcessButtons();
  
}

//Function to process the buttons from the SNES controller
void fcnProcessButtons()
{
  static long currentkey = 0;
  byte nothingpressed = 1;
  
  for (byte i = 0; i < NUMBUTTONS; i++) {
   // Serial.print(i, DEC); Serial.print(" -> "); Serial.println(pressed[i], HEX);
    if (pressed[i]) {
      nothingpressed = 0;
      
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
    Keyboard.set_key1(0);
    Keyboard.send_now();
  }
}



void check_switches()
{
  static byte previousstate[NUMBUTTONS];
  static byte currentstate[NUMBUTTONS];
  static long lasttime;
  byte index;

  if (millis() < lasttime) {
     // we wrapped around, lets just try again
     lasttime = millis();
  }

  if ((lasttime + DEBOUNCE) > millis()) {
    // not enough time has passed to debounce
    return;
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();

  for (index = 0; index < NUMBUTTONS; index++) {
    justpressed[index] = 0;       // when we start, we clear out the "just" indicators
    justreleased[index] = 0;

    currentstate[index] = digitalRead(buttons[index]);   // read the button

     /*
    Serial.print(index, DEC);
    Serial.print(": cstate=");
    Serial.print(currentstate[index], DEC);
    Serial.print(", pstate=");
    Serial.print(previousstate[index], DEC);
    Serial.print(", press=");
    */

    if (currentstate[index] == previousstate[index]) {
      if ((pressed[index] == LOW) && (currentstate[index] == LOW)) {
          // just pressed
          justpressed[index] = 1;
      }
      else if ((pressed[index] == HIGH) && (currentstate[index] == HIGH)) {
          // just released
          justreleased[index] = 1;
      }
      pressed[index] = !currentstate[index];  // remember, digital HIGH means NOT pressed
    }
   // Serial.println(pressed[index], DEC);
    previousstate[index] = currentstate[index];   // keep a running tally of the buttons
  }
}


