class Key{ 
//for tracking key input

  String label = "..."; // should get set something descriptive.

  int code;
  boolean down = false; // true on keypress, false on keyrelease
  boolean toggle = false; //true every odd keypress
  
  Key(String _label, int _code){ label = label; code = _code; }
  Key(int _code){ code = code; }
  
}//end class


//------------------------------------------------------
void keyPressed(){
  lastkeypress = millis();
  //println(keyCode);
  for (int i = 0; i < keys.length; i++)
    if (keys[i].code == keyCode) {
      keys[i].down = true;
      keys[i].toggle = !keys[i].toggle;
      break;
    }
  checkkeys();
} 

//------------------------------------------------------
void keyReleased(){
  for (int i = 0; i < keys.length; i++)
    if (keys[i].code == keyCode) {
      keys[i].down = false;
      break;
    }
} 

//------------------------------------------------------
void checkkeys(){ // called on keypress  
  if (KEYSCREENSHOT.down) doscreenshot = true;
  switch(currstate)  {
  case MENUSTATE: 
    checkkeysmenu(); break;
  case GAMESTATE:
    checkkeysgame(); break;
  case HISCORES:
    checkkeyshiscores(); break;
  case GAMEOVER:
    checkkeysgameover(); break;
  default: break;
  } 
}

//--------------------------------------------------------------------------------------
void repeatkeys(){ //called on draw
    switch(currstate)  {
  case MENUSTATE: 
    repeatkeysmenu(); break;
  case GAMESTATE:
    repeatkeysgame(); break;
  case HISCORES:
    repeatkeyshiscores(); break;
  case GAMEOVER:
    repeatkeysgameover(); break;
  default: break;
  } 
}
