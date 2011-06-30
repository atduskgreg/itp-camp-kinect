/*

NOTE:
Relies on devin.skel in data folder for this sketch
http://doormouse.org/misc/devin.skel

Types from a file called typeyTypet.txt in data.

TODO: 
- typeyTypey doesn't work well with non-alpha characters: braces, asterixes, etc.

*/


import java.awt.Robot;
import java.awt.event.KeyEvent;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;

boolean running = false;
boolean devinMode = false;

byte[] fake;
int fakePos = 0;
int fakeStep = 5;

boolean debug = true;

Robot robot;

void setup(){
  
   kinect = new SimpleOpenNI(this);
   kinect.enableDepth();

   kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
   fake = loadBytes("typeyType.txt");
  
  try{
    robot = new Robot(); 
  } catch (java.awt.AWTException ex) { 
    println("Problem initializing AWT Robot: " + ex.toString()); 
  }
  
     size(640, 480);
  
    background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();

  if (debug) {
    PFont font = loadFont("Menlo-Bold-48.vlw"); 
    textFont(font);
  }

}

void draw(){
  kinect.update();
  
  image(kinect.depthImage(), 0,0);
  
  IntVector userList = new IntVector();
    kinect.getUsers(userList);
  
  if (userList.size() < 1)
    return;
  
  int user = userList.get(0);
  if (kinect.isTrackingSkeleton(user))
    drawSkeleton(user);
  else
    return;
  
  float leftHandDistance = 1000;
  float rightHandDistance = 1000;
  float handsZDistance = -1;

  if (kinect.isTrackingSkeleton(user)) {
    PVector neck = new PVector();
    kinect.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_HEAD, neck);
  
    PVector leftHand = new PVector();
    kinect.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    
    PVector rightHand = new PVector();
    kinect.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
  
    leftHandDistance = neck.dist(leftHand);  
    rightHandDistance = neck.dist(rightHand);
    handsZDistance = abs(rightHand.z - neck.z) + abs(leftHand.z - neck.z);
    
    if (debug) {
      text("l: " + leftHandDistance, 5, 48);
      text("r: " + rightHandDistance, 5, 106);
      text("z: " + handsZDistance, 5, 164);
    }
  } 
  
  if (handsZDistance < 0)
    return;
  
  if(!running && leftHandDistance < 100) {
    launchEmacs();
    running = true;
  }
  
  if(running && rightHandDistance < 100) {
    quitEmacs();
    running = false;
  }
  
  if(running && handsZDistance > 1400){
    typeyTypey();
  }
}

void keyPressed(){
  if (key == 'l') {
    // load Devin calibration file
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    if(userList.size() < 1)
    {
      println("You need at least one active user!");
      return;
    }
    
    int user = userList.get(0);
    
   
  }
  if (key == 'r') {
    // reset
    devinMode = false;
    running = false;
  }
}

void mousePressed(){
  if(running == true){
    quitEmacs();
    running = false;
  } else {
   launchEmacs();
   running = true;
  }
}

void typeyTypey(){
  for (int i = 0; i < fakeStep; i++) {
    char c = char(fake[fakePos++]);
    type(c);
  }
}

void switchToEmacs(){
  try{
    Runtime.getRuntime().exec("/usr/bin/osascript -e 'tell application \"Terminal\" to activate'");
    delay(100);

  } catch (IOException ex) {
     println(ex.toString());
  }

}

void launchEmacs(){
  switchToEmacs();
  
  try{
    Runtime.getRuntime().exec("open /usr/bin/emacs");
    delay(100);

  } catch (IOException ex) {
    println(ex.toString());
  }


}

void controlType(CharSequence chars){
  switchToEmacs(); 
  robot.keyPress(KeyEvent.VK_CONTROL);
  type(chars);
   robot.keyRelease(KeyEvent.VK_CONTROL);
}

void kill(){
 controlType("k");

}

void yank(){
 controlType("y");

}

void quitEmacs(){

  switchToEmacs();
 robot.keyPress(KeyEvent.VK_CONTROL);
  
  type("xc");
  
  robot.keyRelease(KeyEvent.VK_CONTROL);
}

void hitEnter(){
  robot.keyPress(KeyEvent.VK_ENTER);
  robot.keyRelease(KeyEvent.VK_ENTER);
}

void type(CharSequence characters) {
        int length = characters.length();
        for (int i = 0; i < length; i++) {
                char character = characters.charAt(i);
                type(character);
        }
    }

    void type(char character) {
        switch (character) {
        case 'a': doType(KeyEvent.VK_A); break;
        case 'b': doType(KeyEvent.VK_B); break;
        case 'c': doType(KeyEvent.VK_C); break;
        case 'd': doType(KeyEvent.VK_D); break;
        case 'e': doType(KeyEvent.VK_E); break;
        case 'f': doType(KeyEvent.VK_F); break;
        case 'g': doType(KeyEvent.VK_G); break;
        case 'h': doType(KeyEvent.VK_H); break;
        case 'i': doType(KeyEvent.VK_I); break;
        case 'j': doType(KeyEvent.VK_J); break;
        case 'k': doType(KeyEvent.VK_K); break;
        case 'l': doType(KeyEvent.VK_L); break;
        case 'm': doType(KeyEvent.VK_M); break;
        case 'n': doType(KeyEvent.VK_N); break;
        case 'o': doType(KeyEvent.VK_O); break;
        case 'p': doType(KeyEvent.VK_P); break;
        case 'q': doType(KeyEvent.VK_Q); break;
        case 'r': doType(KeyEvent.VK_R); break;
        case 's': doType(KeyEvent.VK_S); break;
        case 't': doType(KeyEvent.VK_T); break;
        case 'u': doType(KeyEvent.VK_U); break;
        case 'v': doType(KeyEvent.VK_V); break;
        case 'w': doType(KeyEvent.VK_W); break;
        case 'x': doType(KeyEvent.VK_X); break;
        case 'y': doType(KeyEvent.VK_Y); break;
        case 'z': doType(KeyEvent.VK_Z); break;
        case 'A': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_A); break;
        case 'B': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_B); break;
        case 'C': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_C); break;
        case 'D': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_D); break;
        case 'E': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_E); break;
        case 'F': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_F); break;
        case 'G': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_G); break;
        case 'H': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_H); break;
        case 'I': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_I); break;
        case 'J': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_J); break;
        case 'K': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_K); break;
        case 'L': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_L); break;
        case 'M': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_M); break;
        case 'N': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_N); break;
        case 'O': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_O); break;
        case 'P': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_P); break;
        case 'Q': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_Q); break;
        case 'R': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_R); break;
        case 'S': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_S); break;
        case 'T': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_T); break;
        case 'U': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_U); break;
        case 'V': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_V); break;
        case 'W': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_W); break;
        case 'X': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_X); break;
        case 'Y': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_Y); break;
        case 'Z': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_Z); break;
        case '`': doType(KeyEvent.VK_BACK_QUOTE); break;
        case '0': doType(KeyEvent.VK_0); break;
        case '1': doType(KeyEvent.VK_1); break;
        case '2': doType(KeyEvent.VK_2); break;
        case '3': doType(KeyEvent.VK_3); break;
        case '4': doType(KeyEvent.VK_4); break;
        case '5': doType(KeyEvent.VK_5); break;
        case '6': doType(KeyEvent.VK_6); break;
        case '7': doType(KeyEvent.VK_7); break;
        case '8': doType(KeyEvent.VK_8); break;
        case '9': doType(KeyEvent.VK_9); break;
        case '-': doType(KeyEvent.VK_MINUS); break;
        case '=': doType(KeyEvent.VK_EQUALS); break;
        case '~': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_BACK_QUOTE); break;
        case '!': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_1); break;
        case '@': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_2); break;
        case '#': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_3); break;
        case '$': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_4); break;
        case '%': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_5); break;
        case '^': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_6); break;
        case '&': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_7); break;
        case '*': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_8); break;
        case '(': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_9); break;
        case ')': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_0); break;
        case '_': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_MINUS); break;
        case '+': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_EQUALS); break;
        case '\t': doType(KeyEvent.VK_SPACE); doType(KeyEvent.VK_SPACE); doType(KeyEvent.VK_SPACE); doType(KeyEvent.VK_SPACE); break;
        case '\n': doType(KeyEvent.VK_ENTER); break;
        case '[': doType(KeyEvent.VK_OPEN_BRACKET); break;
        case ']': doType(KeyEvent.VK_CLOSE_BRACKET); break;
        case '\\': doType(KeyEvent.VK_BACK_SLASH); break;
        case '{': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_OPEN_BRACKET); break;
        case '}': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_CLOSE_BRACKET); break;
        case '|': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_BACK_SLASH); break;
        case ';': doType(KeyEvent.VK_SEMICOLON); break;
        case ':': doType(KeyEvent.VK_COLON); break;
        case '\'': doType(KeyEvent.VK_QUOTE); break;
        case '"': doType(KeyEvent.VK_QUOTEDBL); break;
        case ',': doType(KeyEvent.VK_COMMA); break;
        case '<': doType(KeyEvent.VK_LESS); break;
        case '.': doType(KeyEvent.VK_PERIOD); break;
        case '>': doType(KeyEvent.VK_GREATER); break;
        case '/': doType(KeyEvent.VK_SLASH); break;
        case '?': doType(KeyEvent.VK_SHIFT, KeyEvent.VK_SLASH); break;
        case ' ': doType(KeyEvent.VK_SPACE); break;
        default:
                throw new IllegalArgumentException("Cannot type character " + character);
        }
    }

    void doType(int... keyCodes) {
        doType(keyCodes, 0, keyCodes.length);
    }

    void doType(int[] keyCodes, int offset, int length) {
        if (length == 0) {
                return;
        }

        robot.keyPress(keyCodes[offset]);
        doType(keyCodes, offset + 1, length - 1);
        robot.keyRelease(keyCodes[offset]);
    }


void onNewUser(int userId)
{
  if (devinMode)
    return;
  
  println("New user: " + userId);
  println("  start pose detection");
  
  kinect.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("Lost user " + userId);
}

void onStartCalibration(int userId)
{
  println("Started calibration for user " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("End calibration for user " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinect.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  if (devinMode)
    return;
  
  println("Started pose for user " + userId + ", pose: " + pose);
  
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose,int userId)
{
  println("End pose for user " + userId + ", pose: " + pose);
}

// debug

void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

