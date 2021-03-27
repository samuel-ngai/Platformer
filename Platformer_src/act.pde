//Handles movement velocities and animations
void act() {
   if(w == true && canjump == true) {
     player.setVelocity(0,-400);
     currentAction = jump; //Animations
     canjump = false;
   }
   if(w == true && canjump == false) {
     player.setVelocity(player.getVelocityX(),player.getVelocityY());
   }
 
   if(s == true) {
     player.setVelocity(player.getVelocityX(),player.getVelocityY());
   }
 
   if(a == true) {
     player.setVelocity(-200,player.getVelocityY());
     currentAction = runL;
   }
 
   if(d == true) {
     player.setVelocity(200,player.getVelocityY());
     currentAction = runR;
   }

}
