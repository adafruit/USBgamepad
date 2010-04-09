const int pinAnalogXInput = 3;
const int pinAnalogYInput = 1;
const int pinAnalogZInput = 2;
const int pinAnalogDummyInput = 0;

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

//Change these values if accelerometer reading are different:
//How far the accerometer is tilted before
//the Teensy starts moving the mouse:
const int cintMovementThreshold = 18;

//The average zero acceleration values read
//from the accelerometer for each axis:
const int cintZeroXValue = 328;
const int cintZeroYValue = 328;
const int cintZeroZValue = 328;

//The maximum (positive) acceleration values read
//from the accelerometer for each axis:
const int cintMaxXValue = 396;
const int cintMaxYValue = 396;
const int cintMaxZValue = 396;

//The minimum (negative) acceleration values read
//from the accelerometer for each axis:
const int cintMinXValue = 256;
const int cintMinYValue = 256;
const int cintMinZValue = 256;

//The sign of the mouse movement relative to the acceleration.
//If your cursor is going in the opposite direction you think it
//should go, change the sign for the appropriate axis.
const int cintXSign = 1;
const int cintYSign = -1;
const int cintZSign = 1;

//const float cfloatMovementMultiplier = 1;

//The maximum speed in each axis (x and y)
//that the cursor should move. Set this to a higher or lower
//number if the cursor does not move fast enough or is too fast.
const int cintMaxMouseMovement = 10;

//This reduces the 'twitchiness' of the cursor by calling
//a delay function at the end of the main loop.
//There is a better way to do this without delaying the whole
//microcontroller, but that is left for another time or person.
const int cintMouseDelay = 8;


void setup()
{
    //This is not needed and set to default but can be useful if you
  //want to get the full range out of the analog channels when
  //reading from the 3.3V ADXL335.
  //If the analog reference is used, the thresholds, zeroes,
  //maxima and minima will need to be re-evaluated.
  analogReference( DEFAULT );
  
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


  //Process the accelerometer to make the cursor move.
  //Comment this line to debug the accelerometer values:
  fcnProcessAccelerometer();

  //Progess the SNES controller buttons to send keystrokes.
  fcnProcessButtons();
  
    
  //Delay to avoid 'twitchiness' and bouncing inputs
  //due to too fast of sampling.
  //As said above, there is a better way to do this
  //than delay the whole MCU.
  delay(cintMouseDelay);
}


//Function to process the acclerometer data
//and send mouse movement information to the host computer.
void fcnProcessAccelerometer()
{
  //Initialize values for the mouse cursor movement.
  int intMouseXMovement = 0;
  int intMouseYMovement = 0;
  
  //Read the dummy analog channel
  //This must be done first because the X analog channel was first
  //and was unstable, it dropped or pegged periodically regardless
  //of pin or source.
  analogRead( pinAnalogDummyInput );
  
  //Read accelerometer readings  
  int intAnalogXReading = analogRead(pinAnalogXInput);
  int intAnalogYReading = analogRead(pinAnalogYInput);
  int intAnalogZReading = analogRead(pinAnalogZInput);

  //Calculate mouse movement
  //If the analog X reading is ouside of the zero threshold...
  if( cintMovementThreshold < abs( intAnalogXReading - cintZeroXValue ) )
  {
    //...calculate X mouse movement based on how far the X acceleration is from its zero value.
    intMouseXMovement = cintXSign * ( ( ( (float)( 2 * cintMaxMouseMovement ) / ( cintMaxXValue - cintMinXValue ) ) * ( intAnalogXReading - cintMinXValue ) ) - cintMaxMouseMovement );
    //it could use some improvement, like making it trigonometric.
  }
  else
  {
    //Within the zero threshold, the cursor does not move in the X.
    intMouseXMovement = 0;
  }

  //If the analog Y reading is ouside of the zero threshold... 
  if( cintMovementThreshold < abs( intAnalogYReading - cintZeroYValue ) )
  {
    //...calculate Y mouse movement based on how far the Y acceleration is from its zero value.
    intMouseYMovement = cintYSign * ( ( ( (float)( 2 * cintMaxMouseMovement ) / ( cintMaxYValue - cintMinYValue ) ) * ( intAnalogYReading - cintMinYValue ) ) - cintMaxMouseMovement );
    //it could use some improvement, like making it trigonometric.
  }
  else
  {
    //Within the zero threshold, the cursor does not move in the Y.
    intMouseYMovement = 0;
  }
 
  Mouse.move(intMouseXMovement, intMouseYMovement);

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

