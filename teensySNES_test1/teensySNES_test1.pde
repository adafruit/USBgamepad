
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
boolean boolBtnA;
boolean boolBtnB;
boolean boolBtnX;
boolean boolBtnY;

boolean boolBtnTrigLeft;
boolean boolBtnTrigRight;

boolean boolBtnUp;
boolean boolBtnDown;
boolean boolBtnLeft;
boolean boolBtnRight;

boolean boolBtnSelect;
boolean boolBtnStart;

void setup()
{
  //Setup the pin modes.
  pinMode( pinLEDOutput, OUTPUT );

  //Special for the Teensy is the INPUT_PULLUP
  //It enables a pullup resitor on the pin.
  pinMode( pinBtnA, INPUT_PULLUP );
  pinMode( pinBtnB, INPUT_PULLUP );
  pinMode( pinBtnX, INPUT_PULLUP );
  pinMode( pinBtnY, INPUT_PULLUP );
  
  pinMode( pinBtnUp, INPUT_PULLUP );
  pinMode( pinBtnDown, INPUT_PULLUP );
  pinMode( pinBtnLeft, INPUT_PULLUP );
  pinMode( pinBtnRight, INPUT_PULLUP );
  
  pinMode( pinBtnTrigLeft, INPUT_PULLUP );
  pinMode( pinBtnTrigRight, INPUT_PULLUP );
  pinMode( pinBtnSelect, INPUT_PULLUP );
  pinMode( pinBtnStart, INPUT_PULLUP );

  //Zero the SNES controller button keys:
  boolBtnA = false;
  boolBtnB = false;
  boolBtnX = false;
  boolBtnY = false;
  
  boolBtnTrigLeft = false;
  boolBtnTrigRight = false;
  
  boolBtnUp = false;
  boolBtnDown = false;
  boolBtnLeft = false;
  boolBtnRight = false;
  
  boolBtnSelect = false;
  boolBtnStart = false;

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
  //Assign temporary values for the buttons.
  //Remember, the SNES buttons are read as active LOW.
  //Capture their status here:
  boolean boolBtnA = !digitalRead(pinBtnA);
  boolean boolBtnB = !digitalRead(pinBtnB);  
  boolean boolBtnX = !digitalRead(pinBtnX);
  boolean boolBtnY = !digitalRead(pinBtnY);
  
  boolean boolBtnTrigLeft = !digitalRead(pinBtnTrigLeft);
  boolean boolBtnTrigRight = !digitalRead(pinBtnTrigRight);
  
  boolean boolBtnUp = !digitalRead(pinBtnUp);
  boolean boolBtnDown = !digitalRead(pinBtnDown);
  boolean boolBtnLeft = !digitalRead(pinBtnLeft);
  boolean boolBtnRight = !digitalRead(pinBtnRight);
  
  boolean boolBtnSelect = !digitalRead(pinBtnSelect);
  boolean boolBtnStart = !digitalRead(pinBtnStart);

  if ( boolBtnUp ) {
    //Set key1 to the 'U' key
    Keyboard.set_key1( KEY_U );
  } else if ( boolBtnDown ) {
    //Set key1 to the 'D' key
    Keyboard.set_key1( KEY_D );
  } else if ( boolBtnLeft ) {
    //Set key1 to the 'L' key
    Keyboard.set_key1( KEY_L );
  } else if ( boolBtnRight ) {
    //Set key1 to the 'R' key
    Keyboard.set_key1( KEY_R );
  }
  
  else //All else: nothing pressed, unset
  {
    //Set key1 to send nothing
    Keyboard.set_key1( 0 );
  }
  
  //If the X button was pressed...
  if ( boolBtnX )
  {
    //Set key2 to the X key
    Keyboard.set_key2( KEY_X );
  } 
  else if ( boolBtnY )
  {
    //Set key2 to the Y key
    Keyboard.set_key2( KEY_Y );
  } 
  else if ( boolBtnA )
  {
    //Set key2 to the A key
    Keyboard.set_key2( KEY_A );
  } 
  else if ( boolBtnB )
  {
    //Set key2 to the B key
    Keyboard.set_key2( KEY_B );
  } 
    //All else: nothing pressed, unset
  else
  {
    //Set key2 to send nothing
    Keyboard.set_key2( 0 );
  }
  
  
  //If the Left trigger button was pressed...
  if ( boolBtnTrigLeft )
  {
    //Set key3 to the Q key
    Keyboard.set_key3( KEY_Q );
  } else {
    Keyboard.set_key3( 0 );
  }

  //If the Right trigger button was pressed...
  if ( boolBtnTrigRight )
  {
    //Set key5 to the 'P' key
    Keyboard.set_key4( KEY_P );
  } else {
    Keyboard.set_key4( 0 );
  }


 if ( boolBtnStart )
    {
      //Set key5 to the Tab key
      Keyboard.set_key5( KEY_TAB );
    }  
  else
    {
      //Set key5 to send nothing
      Keyboard.set_key5( 0 );
    }
    
    
 if ( boolBtnSelect )
    {
      //Set key6 to the Enter key
      Keyboard.set_key6( KEY_ENTER );
    }
 else
    {
      //Set key6 to send nothing
      Keyboard.set_key6( 0 );
    }
    
  //Send all of the set keys.
  Keyboard.send_now();


}

