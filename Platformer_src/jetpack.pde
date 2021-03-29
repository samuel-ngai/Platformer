/*
 *Jetpack object
 *Extends FBox because jetpack is a FBox object
 */
class FJetpack extends FBox {
  
  //Timer variable used to remove jetpack object from world
  int timer = 100;

  FJetpack() {
     super(gridSize,gridSize); //Sets object's dimensions
     this.setFill(255,0,0); //Set object color (red)
     this.setPosition(player.getX(),player.getY()+5); //Set spawn location (below player)
     this.attachImage(flame); //Attaches the flame PImage to jetpack object
     world.add(this); //Add object to world
  }
  
  //decrements timer variable, when timer == 0, remove jetpack object from world
  void countdown() {
    timer--;
    if(timer == 0) {
      world.remove(jetpack); //Remove object from world
    }
  }
  
  //-----------------------------------------------------
  //Creates a new object to act as propulsion flames 
  //-----------------------------------------------------

  void propulsion() {
    // FBox b = new FBox (gridSize,gridSize);
    // b.setStatic(false);
    // b.setFillColor(red);
    // //b.setRestitution(0.5);
    // b.setPosition(player.getX(),player.getY()+2);
    // world.add(b);
    // boxes.add(b);
    //jetpack.setFillColor(red);
    //if(timer == 0) {
    //  world.remove(this);
    //  //jetpack = null;
    //}
   jetpack = null;
  }

  
}
