//Handles speed of animation and looping of PImage array
void animations() {
  //Assures we keep looping the currentAction array
  if(costumeNum >= currentAction.length) {
    costumeNum = 0; //sets to 0 to repeat animation (used as array index)
  }
  //Attaches corresponding action animations to the player object
  player.attachImage(currentAction[costumeNum]);
  //Animation speed
  if(frameCount %10 == 0) { //frameCount contains number of frames that have been displayed since program began
    costumeNum++; //Increment animation array index variable
  }
  
}

//Handles vertical animations
void animationRestrictions() {
  //If player's vertical velocity is positive
  if(player.getVelocityY() > 0) {
    currentAction = jump; //currentAction set to jump array
  }
  //If player's vertical velocity is negative
  if(player.getVelocityY() < 0) {
    currentAction = falling; //currentAction set to falling array
  }
  //If player's vertical velocity is 0 (Landed after falling/jumping)
  if(player.getVelocityY() == 0) {
    currentAction = facingR; //currentAction set to default facing right animation
  }
  
}
