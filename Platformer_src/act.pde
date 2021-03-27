//Handles movement velocities and horizontal animations
void act() {
  
  //If w (up) key is pressed and player able to jump, animation handled in animationRestrictions()
  if(w == true && canjump == true) {
    player.setVelocity(0,-400); //Sets player velocity to -400 (up)
    currentAction = jump; //currentAction array set to jump
    canjump = false; //Disable double jumping, set to true after landing/touching another block
  }
  
  //If w (up) is pressed but we can't jump, animation handled in animationRestrictions()
  if(w == true && canjump == false) {
    player.setVelocity(player.getVelocityX(),player.getVelocityY()); //No change in velocity
  }
 
  //If s (down) is pressed, no change in velocity, animation handled in animationRestrictions()
  if(s == true) {
    player.setVelocity(player.getVelocityX(),player.getVelocityY()); //No change in velocity
  }
  
  //If a (left) key is pressed
  if(a == true) {
    player.setVelocity(-200,player.getVelocityY()); //Player moves at vspeed = 200 left, no change in vertical velocity
    currentAction = runL; //Change currentAction animation array 
  }
   
  //If d (right) key is pressed
  if(d == true) {
    player.setVelocity(200,player.getVelocityY()); //Player moves at speed = 200 right, no change in vertical velocity
    currentAction = runR; //Changes currentAction animation array
  }

}
