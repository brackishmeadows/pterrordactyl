class Menu{
  Vec2 pos;
  int NUMOPTIONS;
  String[] options;
  int selected = 0;
  int YSPREAD = 20;
  
  Menu(int _x, int _y) { pos = new Vec2(_x,_y); }
  
  void draw(){
    for(int i = 0; i<NUMOPTIONS; i++) {
      String string = "";
      if (i == selected) {
        string = "> ";
      }       
      string += options[i];
      if (i == selected) {
        string += " <";
      }
      text(string,pos.x,pos.y+i*YSPREAD);
    }
  }
  
  void checkkeys(){
    if (KEYYES.down)
      dooption();
    if (KEYDOWN.down) 
      selected = (int)cycle(selected, 1, 0, 1);
    if (KEYUP.down)
      selected = (int)cycle(selected, -1, 0, 1);
  }
  
  void dooption() {}
  
}//end class

//----------------------------------------------------------------------
class GameMenu extends Menu{
  GameMenu(int _x, int _y) {
    super(_x,_y);   
    NUMOPTIONS = 2;
    options = new String[NUMOPTIONS];
    options[0] = "Start";
    options[1] = "High Scores";
  }
  
  void dooption() {
    switch(selected) {
      case 0: setstate(GAMESTATE); break;
      case 1: setstate(HISCORES); break;
    }
  }
  
}//end class
