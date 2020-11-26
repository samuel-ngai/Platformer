class FBeam extends FBox {
  
int timer = 100;
  
  
  
   FBeam() {
    super(10,10);
    this.setPosition(player.getX()+5,player.getY());
    this.setFill(0,0,255);
    world.add(this);
    
  }
  
  void shoot() {
    this.setVelocity(500,0);
  }
    
  void countdown() {
    timer--;
  }
  
  
  


void DidItHit() {
  for (FBox box : boxes) {
    
  if(dist(this.getX(),this.getY(),box.getX(),box.getY())<20) {
    box.setStatic(false);
    
    }
   
    
    
   }
  if(timer == 0) {
    beam = null;
    }
  
  }
  
} 
 
  
  
  
  
  
  
  
  
  
  