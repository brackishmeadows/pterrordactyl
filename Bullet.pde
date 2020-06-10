class Bullet {
int SPEED = 3;
Vec2 pos;

//--------------------------------------------------------------------------------------
Bullet (int _posx, int _posy) {
  pos = new Vec2(_posx,_posy);
}

//--------------------------------------------------------------------------------------
void draw()  {
  pushMatrix();
  translate(pos.x,pos.y);
  drawtile(tiles, 0,2);
  popMatrix();
}

//--------------------------------------------------------------------------------------
boolean update(){    
  pos.y-=SPEED;
  for (int i = 0; i<ec.enemies.size(); i++) {
    Enemy enemy = (Enemy) ec.enemies.get(i);
    if (collidetile(pos.x,pos.y, enemy.pos.x,enemy.pos.y)){
      ec.enemies.remove(i);
      player.score+=KILLENEMYBONUS;
      return false;
    }
  }
  if (pos.y <0)
    return false;
  else return true;
}  
  
}//end class

