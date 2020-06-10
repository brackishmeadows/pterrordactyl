char EMPTY = '0'; char STONE = '1';
char EARTH = '2'; char ENERGY = '3';

//stuff that happens on collision
char [] KILLPLAYER = {STONE, EARTH};
char [] COLLECTIBLE = {ENERGY};
char [] DESTRUCTIBLE = {EARTH, ENERGY};
char [] KILLBULLET = {STONE, EARTH};

int ROOMW = WIDTH/TILE; int HALFROOMW= ROOMW/2;
int ROOMH = HEIGHT/TILE; int HALFROOMH= ROOMH/2;

class Room extends Grid {
int tileseed = (int)random(MAX_INT);
Vec2 pos;
int SPEED = 1;

//--------------------------------------------------------------------------------------
Room(int _x, int _y){
  super(ROOMW,ROOMH);
  pos = new Vec2(_x,_y);
  if(random(1)> EVEN)
  generatestone();
  if(random(1)> EVEN)
  generateearth();
  //if(random(1)> UNLIKELY)
  generateloot();  
}

//--------------------------------------------------------------------------------------
void generatestone(){
  int numsections = 5;
  Grid[]sections = new Grid[numsections];
  for (int i =0; i<numsections; i++){
    
    sections[i] = new Grid(HALFROOMW,HALFROOMH);
    sections[i].fill(STONE);
    
    //dig out paths across one diagonal
    int paths = (int)random(3)+5; //5-9 paths
    for (int j = 0; j<paths; j++)
      sections[i].dig(EMPTY,0,0,HALFROOMW-1,HALFROOMH-1);
      
    //dig out paths to the center sometimes
    if(random(1)> EVEN) sections[i].dig(EMPTY,0,0,HALFROOMW-1,0);
    if(random(1)> EVEN) sections[i].dig(EMPTY,HALFROOMH-1,0,HALFROOMW-1,HALFROOMH-1);
    
    //remove some stone with floodfill
    if(random(1)>EVEN){
      int fillatx = (int)random(HALFROOMW);
      int fillaty = (int)random(HALFROOMH);
      sections[i].floodfill(EMPTY,fillatx,fillaty);
    }
  }
 
  //each quadrant of the play area gets one of the sections generated before,
  //chosen randomly and flipped to face the right way
  insert(sections[(int)random(numsections)].flip(false,true), 0, 0);
  insert(sections[(int)random(numsections)], 0, HALFROOMH);
  insert(sections[(int)random(numsections)].flip(true,true), HALFROOMW, 0);
  insert(sections[(int)random(numsections)].flip(true,false), HALFROOMW, HALFROOMH);
}

//--------------------------------------------------------------------------------------
void generateearth(){
  //make a grid, a bit smaller than the play area
  Grid egrid = new Grid(ROOMW,ROOMH);
  
  //fill it with random earth and empty tiles
  char[] cavestuff = {EMPTY,EARTH};
  egrid.noise(cavestuff);
  
  //smooth it out a bit
  int growpasses = (int)random(4)+1; //1-4 passes
  int growthreshold = (int)random(4)+3; //4-7 adjacent tiles required for each cell, each pass
  for(int i=0; i<growpasses; i++)
    egrid.grow(EARTH,EMPTY,growthreshold);
  
  //merge it with the room grid, leaving prexisting stone tiles intact  
  char[] keepstuff = {STONE};
  merge(egrid, keepstuff, 0,0);
}

//--------------------------------------------------------------------------------------
void generateloot(){
  Grid lgrid = new Grid(HALFROOMW,HALFROOMH);
  lgrid.fill(EMPTY);
  Vec2 p;
  
  int numENERGYs = 0;
  do {
    p = lgrid.find(EMPTY);
    lgrid.cell[p.x][p.y] = ENERGY;
  }
  while ((random(1)>EVEN) && (numENERGYs<2));

  char[] keepstuff = { STONE,  EARTH } ;

  if(random(1)>UNLIKELY) merge(lgrid.flip(false,true), keepstuff, 0, 0);
  if(random(1)>EVEN) merge(lgrid, keepstuff, 0, HALFROOMH);
  if(random(1)>EVEN) merge(lgrid.flip(true,true),  keepstuff, HALFROOMW, 0);
  if(random(1)>UNLIKELY) merge(lgrid.flip(true,false),  keepstuff, HALFROOMW, HALFROOMH);
}

//--------------------------------------------------------------------------------------
void draw(){
  randomSeed(tileseed);
  
    for (int x=0; x<cell.length; x++)
    for (int y=0; y<cell[0].length; y++) {
      Vec2 tile = new Vec2 (-1,-1);
      if      (cell[x][y] == STONE)  { tile.x = (int)random(2); tile.y = 4; }
      else if (cell[x][y] == EARTH)  { tile.x = (int)random(2); tile.y = 3; }
      else if (cell[x][y] == ENERGY) { tile.x = (int)random(4); tile.y = 5; }
      
      if (tile.y != -1) { 
        pushMatrix();
        translate(pos.x,pos.y);
        translate(x*TILE, y*TILE);
        drawtile(tiles, tile.x,tile.y);
        popMatrix();
      }
      else random(1);
    }
  randomSeed(SETRANDOM*millis());
}

//--------------------------------------------------------------------------------------
void update(){
  pos.y+=SPEED;
  if (pos.y >= -height)
  for (int x=0; x<cell.length; x++)
  for (int y=0; y<cell[0].length; y++) {
    
    //player hits walls
    if (collidetile_point(x*TILE,y*TILE+pos.y,player.pos.x, player.pos.y))
      if (has(KILLPLAYER,x,y))
        setstate(GAMEOVER);
        
    //player collects energy
    if (collidetile_halftile(x*TILE,y*TILE+pos.y,player.pos.x, player.pos.y))
      if(has(COLLECTIBLE,x,y))
        collect(x,y);
    
    //bullet hits destructible
    for (int i = 0; i<player.bullets.size(); i++) {
      Bullet bullet = (Bullet) player.bullets.get(i);
      if (collidetile_halftile(x*TILE,y*TILE+pos.y,bullet.pos.x, bullet.pos.y)) {
        if (has(KILLBULLET, x,y))
          player.bullets.remove(i);
        if (has(DESTRUCTIBLE,x,y))
          cell[x][y] = EMPTY;
      }
    }
      
    
    
  }
   
}

//--------------------------------------------------------------------------------------
void collect(int _x, int _y){
  cell[_x][_y] = EMPTY;
  player.score += GETENERGYBONUS;
}

}//end class
