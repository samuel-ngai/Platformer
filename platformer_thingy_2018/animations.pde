void animations() {
  if(costumeNum >= currentAction.length) {
    costumeNum = 0;
  }
  player.attachImage(currentAction[costumeNum]);
  if(frameCount %10 == 0) {
    costumeNum++;
  }
  
}
float previousVar;
void animationRestrictions() {
  if(player.getVelocityY() > 0) {
    currentAction = jump;
  }
  if(player.getVelocityY() < 0) {
    currentAction = falling;
  }
  if(player.getVelocityY() == 0) {
    currentAction = facingR;
  }

 


  //float var = player.getX();
  // if(previousVar >= var) {
  //   //do something 
  //   currentAction = facingL;
  // }else {
  //   currentAction = facingR;
  // }
  // previousVar = var;

 

 
 
}