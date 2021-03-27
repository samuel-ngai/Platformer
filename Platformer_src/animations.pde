void animations() {
  //Assures we keep looping the currentAction array
  if(costumeNum >= currentAction.length) {
    costumeNum = 0;
  }
  //Attaches corresponding action animations to the player object
  player.attachImage(currentAction[costumeNum]);
  //Animation speed
  if(frameCount %10 == 0) {
    costumeNum++;
  }
  
}

float previousVar;
void animationRestrictions() {
  //Restricts jumping & falling animations
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
