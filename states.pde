//-------------------------------------------------------------------
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ MENU
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Menu menu;
//-----------------------------------------------------------------
void setupmenu(){
settimeout(false);
menu = new GameMenu(HALFWIDTH,150);
player.score = 0; 
//returning to high scores after a game won't register the same score twice
}

//-----------------------------------------------------------------
void drawmenu() {

  fill(coltext3);
  textFont(titlefont);
  textAlign(CENTER);

  text("PTERRORDACTYL", HALFWIDTH,HEIGHT*.33);

  fill(coltext2);
  textFont(smallfont);
  
  menu.draw();
  
  text("Matt Rundle, 2010", 125,230);
}

//-----------------------------------------------------------------
void checkkeysmenu(){
  menu.checkkeys();
}

//-----------------------------------------------------------------
void repeatkeysmenu(){}
void updatemenu(){}

//-------------------------------------------------------------------
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ GAME
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Room[] rooms;
EnemyControl ec;
int NUMROOMS = 2;

//-----------------------------------------------------------------
void setupgame(){
  settimeout(false);
  player = new Player();
  ec = new EnemyControl();
  rooms = new Room[NUMROOMS];
  for (int i = 0; i<NUMROOMS; i++)
    rooms[i] = new Room(0,(i* -height)-height);
}

//-----------------------------------------------------------------
void drawgame(){
  player.draw();
  for (int i = 0; i<NUMROOMS; i++)
    rooms[i].draw();
  ec.draw();
  
  fill(colbg);
  rect(0,0,width,TWOTILE);
  
  fill(coltext3);
  textFont(smallfont);
  textAlign(CENTER);
  text(player.score+"", width-TWOTILE,TILE);
}

//-----------------------------------------------------------------
void checkkeysgame() { player.checkkeys(); }
void repeatkeysgame(){ player.repeatkeys(); }

//-----------------------------------------------------------------
void updategame(){
  ec.update();
  for (int i = 0; i<NUMROOMS; i++){
    rooms[i].update();
    int roomy = rooms[i].pos.y;
    if (rooms[i].pos.y>height)
      rooms[i] = new Room(0,roomy-NUMROOMS*height);
  }
}


//-------------------------------------------------------------------
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ GAMEOVER
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

int GAMEOVERTIMEOUT = 500;

//-----------------------------------------------------------------
void setupgameover(){
  if (SCREENONDEATH)
  doscreenshot = true;
  settimeout(true, GAMEOVERTIMEOUT, HISCORES);  
}

//-----------------------------------------------------------------
void drawgameover(){
  fill(coltext3);
  textFont(titlefont);
  textAlign(CENTER);
  text("GAME OVER", HALFWIDTH,HALFHEIGHT);
  fill(coltext2);
  text(player.score,HALFWIDTH,160);
}

//-----------------------------------------------------------------
void checkkeysgameover(){}
void repeatkeysgameover(){}
void updategameover(){}

//-------------------------------------------------------------------
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HIGH SCORES
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

int HISCORESTIMEOUT = 5000;
int NUMSCORES = 7;
String[] scores;


//-----------------------------------------------------------------
void setuphiscores(){
  scores = loadStrings("highscores.txt");
  settimeout(true, HISCORESTIMEOUT, MENUSTATE);
  checknewscore(); 
}

//-----------------------------------------------------------------
void drawhiscores(){
  fill(coltext3);
  textFont(titlefont);
  textAlign(CENTER);
  text("HIGH SCORES", 128,50);

  fill(coltext2);
  textFont(titlefont);
  String string = "";
  for(int i = 0; i<min(NUMSCORES, scores.length); i++){
    string += (scores[i].equals(str(0))? "":scores[i]) + "\n";
  }
  text(string, HALFWIDTH,80); 
  
}
//-------------------------------------------------------------------
void checknewscore() {
  println(player.score);
  scores = append(scores,str(player.score));                                    
    
  scores = sortasints(scores);
  
  if (scores.length > NUMSCORES)
    scores = subset(scores,0,NUMSCORES); 
    
  saveStrings("data/highscores.txt", scores);
}

//-------------------------------------------------------------------
String[] sortasints(String[] _oldscores) {
  
  int[] oldints = new int[_oldscores.length];
  for(int i = 0; i< oldints.length; i++) {
    oldints[i] = int(_oldscores[i]);
  }
  
  println(oldints);  

  boolean[] used = new boolean[_oldscores.length];    
  for(int i = 0; i< used.length; i++) {
    used[i] = false;
  }

  int[] newints = new int[_oldscores.length]; 
  boolean allused = false;
  
  while(!allused) {
    allused = true;
    for(int i = 0; i < used.length; i++) {
      if (!used[i]) {
        allused = false;
    
        int useindex = -1;
        int max = -1;
        
        for(int j = 0; j<newints.length; j++) {
          if ((!used[j]) && (oldints[j]>max)) {
            max = oldints[j];
            useindex = j;  
          }   
        }
        used[useindex] = true;
        newints[i] = oldints[useindex];
      }      
    }
      
  }
  String[] newscores = new String[_oldscores.length];
  
  for(int i = 0; i< _oldscores.length; i++) {
    newscores[i] = str(newints[i]);
  }    
  
  return newscores;
  
}

//-------------------------------------------------------------------
void checkkeyshiscores(){
  if (KEYYES.down) setstate(MENUSTATE);
}


void repeatkeyshiscores(){}
void updatehiscores(){}

