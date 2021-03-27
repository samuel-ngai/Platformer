/**
 *Beam object
 *Extends FBox because beam is a FBox object
 */
class FBeam extends FBox {
  
  int timer = 100;
  
  FBeam() {
    super(10,10); //FBeam object's dimensions
    this.setPosition(player.getX()+5,player.getY()); //Set spawn location (to the right of player)
    this.setFill(0,0,255); //Set object color (blue)
    world.add(this); //Add object to world
  }
  //Sets beam velocity to 500 to the right
  void shoot() {
    this.setVelocity(500,0); //Set object's velocity 
  }
  
  //Decrements counter from moment beam object is created
  //Used in DidItHit() to stop beam from flying forever
  void countdown() {
    timer--;
  }
  
  //Checks all objects that touch the beam, sets objects affected to non static object
  void DidItHit() {
    for (FBox box : boxes) { 
      if(dist(this.getX(),this.getY(),box.getX(),box.getY())<15) { //Checks if the distance between a box and beam object is less than 15
        box.setStatic(false); //Sets box affected to non static (affected by gravity)
      }
    }
    if(timer == 0) {
      beam = null; //stops beam from flying forever
    }
  }
} 
 
  
  
  
  
  
  
  
  
  
  
