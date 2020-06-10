int KILLENEMYBONUS = 100;
int GETENERGYBONUS = 200;
int SHOOTPENALTY = 50;

class Player{

int SPEED = 2;
int MAXBULLETS = 5;
int BULLETDELAY = 100;
int lastbullet = 0;
  
Vec2 pos;
int score = 400;
ArrayList bullets = new ArrayList();

//----------------------------------------------------------------------  
Player() {
  pos = new Vec2(HALFWIDTH-HALFTILE,HEIGHT-(TWOTILE));
}

//---------------------------------------------------------------------- 
void checkkeys(){
  if (KEYSHOOT.down) shoot();
}

  
//---------------------------------------------------------------------- 
void repeatkeys(){
  if (KEYUP.down) addpos(0,-SPEED);
  if (KEYDOWN.down) addpos(0,SPEED);
  if (KEYLEFT.down) addpos(-SPEED,0);
  if (KEYRIGHT.down) addpos(SPEED,0);

}

//----------------------------------------------------------------------  
void addpos(int _addx, int _addy) {
  Vec2 target = new Vec2 (pos.x+_addx,pos.y+_addy);
  while(!colliderect(TILE,TILE*3,width-TILE,height-TILE, target.x,target.y,target.x+TILE,target.y+TILE))
    target.approach(pos); 
    
  pos = target;
  
}

void shoot() {
  if (score >= SHOOTPENALTY)
  if (bullets.size() < MAXBULLETS)
  if (lastbullet +BULLETDELAY < millis()) {
    bullets.add(new Bullet(pos.x,pos.y));
    lastbullet = millis();
    score -= SHOOTPENALTY;
  }
}

//----------------------------------------------------------------------  
void draw(){
  for (int i = 0; i<bullets.size(); i++) {
    Bullet bullet = (Bullet) bullets.get(i);
    if (bullet.update())
      bullet.draw();
    else
      bullets.remove(i);
  }
  
  pushMatrix();
  translate(pos.x,pos.y);
  drawtile(tiles, 0,0);
  popMatrix();
  
}


}//end class
