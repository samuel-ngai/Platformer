class FBomb extends FBox {
  
  int timer = 100;
  FBomb() {
    super(gridSize,gridSize);
    this.setPosition(player.getX()-4,player.getY()-5);
    world.add(this);
  }
  
  void countdown() {
    timer = timer - 1;
  }
  
  void kaboom() {
    if(timer == 0){
      bomb = null; // for actual bomb 
    }
    //Shockwave animation 
    if(timer < 50 && timer > 30){
      ellipse(bomb.getX()-player.getX()+width/2,bomb.getY()-player.getY()+height/2,(50-timer)*15,(50-timer)*15);
    }
    
    if(timer == 50) {
      //Calculating different velocities for objects affected by bomb
      for (FBox box : boxes) {
       if(dist(bomb.getX(),bomb.getY(),box.getX(),box.getY()) < 100) {
         float vx=0;
         float vy=0;
         vx = 5 * sqrt(sq(bomb.getX()-box.getX())+sq(bomb.getY()-box.getY()));
         vy = 5 * sqrt(sq(bomb.getY()-box.getY())+sq(bomb.getX()-box.getX()));
         if(box.getY() > bomb.getY()) {
           vy = vy;
         }
         if(box.getX() < bomb.getX()) {
           vx = -vx;
         }
         if(box.getY() < bomb.getY()) {
           vy = -vy;
         }
         if(box.getX() > bomb.getX()) {
           vx = vx;
         }
         box.setStatic(false);
         box.setVelocity(vx,vy);
       }
       world.remove(bomb);
       }
    }
    //bomb = null; //for 'jetpack'
  }
}
