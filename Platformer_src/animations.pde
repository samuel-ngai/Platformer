//Handles speed of animation and looping of PImage array
void animations() {
  //Assures we keep looping the currentAction array
  if(costumeNum >= currentAction.length) {
    costumeNum = 0; //sets to 0 to repeat animation (used as array index)
  }
  //Attaches corresponding action animations to the player object
  player.attachImage(currentAction[costumeNum]);
  //Animation speed
  if(frameCount %10 == 0) {
    costumeNum++;
  }
  
}

//Resets currentAction during/after falling/jumping
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
  
}
