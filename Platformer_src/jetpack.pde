class FJetpack extends FBox {
  
int timer = 100;

 FJetpack() {
    super(gridSize,gridSize);
    this.setFill(255,0,0);
    this.setPosition(player.getX(),player.getY()+5);
    this.attachImage(flame);
    world.add(this);
    //if(timer == 0) {
    //  world.remove(this);
    //}
 }

void countdown() {
  timer = timer - 1;
  if(timer == 0) {
    world.remove(jetpack);
  }
}

void propulsion() {
   //FBox b = new FBox (gridSize,gridSize);
   //b.setStatic(false);
   //b.setFillColor(red);
   ////b.setRestitution(0.5);
   //b.setPosition(player.getX(),player.getY()+2);
   //world.add(b);
   //boxes.add(b);
  //jetpack.setFillColor(red);
  //if(timer == 0) {

  //  world.remove(this);
  //  //jetpack = null;
  //  }
    
   jetpack = null;
   
  }

  
}
