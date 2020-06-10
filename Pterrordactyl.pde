//UPDOWNLEFTRIGHT to move
//Z to shoot
//ENTER to slect menu options

//-movement
//-shooting
//-enemy movement
//-terrain generation
//-menu
//-high scores

//bombs
//enemy shooting
//enemy tactics

//bugs:
//enemy spawns should be random, are too reliable, something to do with roomgeneration screwing the seed - possibly fixed

import processing.opengl.*;

PImage tiles;
Player player;


PFont titlefont, smallfont;
color colbg, coltext, coltext2, coltext3;

//mess with these values to automatically take screenshots
//take a screenshot each time the player dies.
final boolean SCREENONDEATH = false;

//take a screenshot every 10000 millis.
//with some hacks so that it doesn't take the same screen a bunch of times, if you leave the game running.
boolean SCREENONINTERVAL = false;

int lastscreenshot = 0;
int sshotinterval = 10000;
int lastkeypress = 1;

int SETRANDOM = (int)random(MAX_INT);

//take a screenshot at start of next frame.
boolean doscreenshot = false;

//size of stuff
int TILE = 16; int HALFTILE = TILE/2; int TWOTILE = TILE*2; int QUARTTILE = HALFTILE/2;
int WIDTH = 256; int HALFWIDTH = WIDTH/2;
int HEIGHT = 256; int HALFHEIGHT = HEIGHT/2;

//game states
int currstate;
final int MENUSTATE  = 0;
final int HISCORES   = 1;
final int GAMESTATE  = 2;
final int GAMEOVER   = 3;

boolean dostatetimeout = true;
int statetimeout;
int nextstate;
//some game states display for a certain amount of time and then switch to another using these values.

Key [] keys = new Key [11];
  Key KEYUP, KEYDOWN, KEYLEFT, KEYRIGHT, KEYSHOOT, KEYBOMB, KEYUSE, KEYMAP, KEYYES, KEYNO, KEYSCREENSHOT; 

float LIKELY = .2; float EVEN = .5; float UNLIKELY = .8; float TERRIBLYUNLIKELY = .99;
//used like: if(random(1)>LIKELY) dostuff();

//--------------------------------------------------------------------------------------
void setup(){  
  frameRate(100);

  //textMode(SCREEN); //doesn't play nice with opengl
  noStroke();
  tiles = loadImage("tiles.png");
  
  colbg = color(5,5,0);
  coltext = color(41,90,227); //blue
  coltext2 = color(177,72,212); //purple
  coltext3 = color(150,90,40); //brown
  
  titlefont = loadFont("baskoldface20.vlw");  
  smallfont = loadFont("bodonimt14.vlw");
  
  keys[0] = new Key ("Up",     38);
  keys[1] = new Key ("Down",   40);
  keys[2] = new Key ("Left",   37);
  keys[3] = new Key ("Right",  39);
  keys[4] = new Key ("Shoot",  90); //z
  keys[5] = new Key ("Bomb",   88); //x (doesn't do anything)
  keys[6] = new Key ("Use",    67); //c (doesn't do anything)
  keys[7] = new Key ("Map",    9);  //tab (doesn't do anything)
  keys[8] = new Key ("Accept", 10); //enter
  keys[9] = new Key ("Cancel", 32); //space (doesn't do anything)
  keys[10] = new Key ("Screenshot", 80); //p
  
  KEYUP    = keys[0];
  KEYDOWN  = keys[1];
  KEYLEFT  = keys[2];
  KEYRIGHT = keys[3];
  KEYSHOOT = keys[4]; 
  KEYBOMB  = keys[5]; 
  KEYUSE   = keys[6]; 
  KEYMAP   = keys[7]; 
  KEYYES   = keys[8]; 
  KEYNO    = keys[9];
  KEYSCREENSHOT = keys[10];
  
  player = new Player();  
  setstate(MENUSTATE);
  
  size(WIDTH,HEIGHT, OPENGL);


}

//--------------------------------------------------------------------------------------
void setstate(int _state) {
  currstate = _state;
  switch(currstate)  {
  case MENUSTATE: 
    setupmenu(); break;
  case GAMESTATE:
    setupgame(); break;
  case HISCORES:
    setuphiscores(); break;
  case GAMEOVER:
    setupgameover(); break;
  default: break;
  } 
}

//--------------------------------------------------------------------------------------
void settimeout(boolean _dotimeout) {
  dostatetimeout = _dotimeout;
}
  
//--------------------------------------------------------------------------------------
void settimeout(boolean _dotimeout, int _timeout, int _nextstate) {
  dostatetimeout = _dotimeout;
  statetimeout= millis()+_timeout;
  nextstate = _nextstate;
}

//--------------------------------------------------------------------------------------
void draw(){  
  //println(currstate);
  handlescreenshots();
  
  fill(colbg);
  rect(0,0,WIDTH,HEIGHT);
  //stroke(255,0,0);
  
  switch(currstate)  {
  case MENUSTATE: 
    drawmenu(); break;
  case GAMESTATE:
    drawgame(); break;
  case HISCORES:
    drawhiscores(); break;
  case GAMEOVER:
    drawgameover(); break;
  default: break;
  } 
  
   update(); 
}

//--------------------------------------------------------------------------------------
void update(){
  if (dostatetimeout)
    if (millis() >statetimeout)
      setstate(nextstate);

  repeatkeys();
    //call key events that need to happen every frame 
  
  switch(currstate)  {
  case MENUSTATE: 
    updatemenu(); break;
  case GAMESTATE:
    updategame(); break;
  case HISCORES:
    updatehiscores(); break;
  case GAMEOVER:
    updategameover(); break;
  default: break;
  } 
}

//--------------------------------------------------------------------------------------
void handlescreenshots() {
  if (SCREENONINTERVAL)
    if (millis() > lastscreenshot + sshotinterval)
    if (lastkeypress > lastscreenshot)
    if (currstate == GAMESTATE) {
      doscreenshot=true;
      lastscreenshot = millis();
  } 
    
  if (doscreenshot) {
    screenshot();
    doscreenshot =false;
  }
}

//--------------------------------------------------------------------------------------
void screenshot() {
  File file;
  String filestring; //filenames in the form random(MAX_INT)+".png"
  
  do { 
    filestring = int(random(MAX_INT))+".png";
    file = new File(filestring);
  }
  
  while(file.exists()); //get new filename, don't save over an existing file
                        //I guess it could happen
  saveFrame(filestring);
  
  println("saved "+filestring);
}

