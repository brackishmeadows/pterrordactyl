class Enemy {
int SPEED = 2;  
Vec2 pos;
float angle;
int tile = round(random(0,2));

Enemy (int _posx, int _posy, float _angle) {
  pos = new Vec2(_posx,_posy);
  angle = _angle;
}

//--------------------------------------------------------------------------------------
void draw()  {
  pushMatrix();
  translate(pos.x,pos.y);
  drawtile(tiles, tile,1);
  popMatrix();
}

//--------------------------------------------------------------------------------------
boolean update(){
  pos.y+=SPEED;
  if (collidehalftile(pos.x,pos.y,player.pos.x,player.pos.y)) setstate(GAMEOVER);
  return pos.y>height? false: true;
}
}
//---------------------------------------------------------------------------
class EnemyControl {
int ENEMYDELAY = 500;
int MAXENEMIES = 5;
int lastenemy = 0;
ArrayList enemies;

EnemyControl () {
enemies = new ArrayList();
}

void draw() {
  for (int i = 0; i<enemies.size(); i++) {
    Enemy enemy = (Enemy) enemies.get(i);
    enemy.draw();
  }
}

//--------------------------------------------------------------------------------------
void update(){
  if (enemies.size() < MAXENEMIES)
  if (lastenemy +ENEMYDELAY < millis()) {
    enemies.add(new Enemy(round(random(TILE,width-TWOTILE)),TWOTILE, 0));
    lastenemy = millis();
    
    }


    for (int i = 0; i<enemies.size(); i++) {
      Enemy enemy = (Enemy) enemies.get(i);
      if(!enemy.update())enemies.remove(i);
  }
  
}  

}//end class
