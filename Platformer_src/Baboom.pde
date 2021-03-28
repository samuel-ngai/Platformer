/**
 *Bomb object
 *Extends FBox because bomb is a FBox object
 */

class FBomb extends FBox {
  
  //Timer variable used for correctly timed explosion animation and removal of object from world
  int timer = 100;
  
  FBomb() {
    super(gridSize,gridSize); //Fbomb object's dimensions
    this.setPosition(player.getX()-4,player.getY()-5); //Set spawn location (Above player)
    world.add(this); //Add FBomb object to world
  }
  
  //Decrements timer variable
  //Used in kaboom()
  void countdown() {
    timer--;
  }
  
  //Draws shockwave animation and calculates new velocities of objects affected
  void kaboom() {
    if(timer == 0){
      bomb = null; //Deactivates bomb
    }
    //Shockwave animation 
    if(timer < 50 && timer > 30){
      ellipse(bomb.getX()-player.getX()+width/2,bomb.getY()-player.getY()+height/2,(50-timer)*15,(50-timer)*15);
    }
    
    if(timer == 50) {
      //Calculating different velocities for objects affected by bomb within bomb radius
      for (FBox box : boxes) {
        
        if(dist(bomb.getX(),bomb.getY(),box.getX(),box.getY()) < 100) { //If box is within 100 units of the bomb
       
          float vx=0;
          float vy=0;
          vx = 5 * sqrt(sq(bomb.getX()-box.getX())+sq(bomb.getY()-box.getY())); //Calculates new horizontal velocity from distance between bomb and box
          vy = 5 * sqrt(sq(bomb.getY()-box.getY())+sq(bomb.getX()-box.getX())); //Calculates new vertical velocity from distance between bomb and box
          
          if(box.getY() > bomb.getY()) { //If box is below the bomb
            vy = vy; //No need to change direction of vertical velocity
          }
          if(box.getX() < bomb.getX()) { //If box is left of the bomb
            vx = -vx; //Change direction of horizontal velocity to negative (left)
          }
          if(box.getY() < bomb.getY()) { //If box is above the bomb
            vy = -vy; //Change direction of vertical velocity
          }
          if(box.getX() > bomb.getX()) { //If box is right of the bomb
            vx = vx; //No need to change direction of vertical velocity
          }
          
          box.setStatic(false); //Set static to false so that the affected blocks can fly/drop due to explosion
          box.setVelocity(vx,vy); //Set affected box's new velocities
         
        }
        world.remove(bomb); //Removes bomb object after explosion has gone off
      }
    }
  }
}
