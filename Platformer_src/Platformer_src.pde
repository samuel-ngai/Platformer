import fisica.*;

FBomb bomb;
FJetpack jetpack;
FWorld world;
FBeam beam;

int costumeNum;
int contactNum = 0;
boolean w, a, s, d, g, f;

PImage map;
PImage[] runR;
PImage[] runL;
PImage[] facingR;
PImage[] facingL;
PImage[] currentAction;
PImage[] jump;
PImage[] falling;

int mode = 0;

color black = #000000;
color water = #10D2FC;
color red = #FFFFFF;
color bounce = #F46F35; //(244,111,53) orange
color teleport = #2BFFAF; //(42,255,175) light lime green
color crate = #B38342;
color CBridge = #C615DF;
color steel = #ACACAC;
color lava = #DF4800;
color rock = #8B8B8B; // when water and lava touches

int gridSize = 15;
//int jump = 0;

FBox b;
FBox l;
FBox cb;
ArrayList<FBox> boxes = new ArrayList<FBox>();
ArrayList<FBox> liquid = new ArrayList<FBox>();
ArrayList<FBox> collapsing = new ArrayList<FBox>();

FBox player;

PImage flame;

boolean canjump = true;

void setup() {
  size(700, 700, FX2D);
  
  Fisica.init(this);
  world = new FWorld(-100000, -100000, 100000, 100000);
  world.setGravity(0, 900);
  
  runR = new PImage[3];
  runR[0] = loadImage("megaman3.png");
  runR[1] = loadImage("megaman4.png");
  runR[2] = loadImage("megaman5.png");
  
  runL = new PImage[3];
  runL[0] = loadImage("megaman11.png");
  runL[1] = loadImage("megaman12.png");
  runL[2] = loadImage("megaman13.png");
 
  currentAction = new PImage[1];
  currentAction[0] = loadImage("megaman0.png");
 
  facingR = new PImage[1];
  facingR[0] = loadImage("megaman0.png");
 
  facingL = new PImage[1];
  facingL[0] = loadImage("megaman14.png");
 
  jump = new PImage[1]; 
  jump[0] = loadImage("megaman6.png");
  //jump[1] = loadImage("megaman8.png");
 
  falling = new PImage[1];
  falling[0] = loadImage("megaman8.png");
 
  map = loadImage("map.png");
  flame = loadImage("flame.png");
 
  int x = 0;
  int y = 0;
   while ( y< map.height) {
     
     color c = map.get(x, y);
     if (c == black) {
       FBox b = new FBox(gridSize, gridSize);
       b.setStatic(true);
       b.setName("platform_box");
       b.setFill(black);
       b.setPosition(x*gridSize, y*gridSize);
       world.add(b);
       boxes.add(b);
     }
     if (c == water) {
       println ("water");
       FBox l = new FBox(gridSize, gridSize);
       l.setStatic(false);
       l.setFillColor(water);
       l.setName("water");
       l.setDensity(0.001);
       l.setPosition(x*gridSize, y*gridSize);
       l.setNoStroke();
       world.add(l);
       liquid.add(l);
     }
     if (c == bounce) {
       FBox b = new FBox(gridSize,gridSize);
       b.setStatic(true);
       b.setFillColor(bounce);
       b.setPosition(x*gridSize,y*gridSize);
       b.setRestitution(3);
       world.add(b);
       boxes.add(b);
     }
     if(c == teleport) {
       FBox b = new FBox(gridSize,gridSize);
       b.setName("teleport_box");
       b.setStatic(true);
       b.setFillColor(teleport);
       b.setPosition(x*gridSize,y*gridSize);
       b.setNoStroke();
       world.add(b);
       boxes.add(b);
     }
     if(c == crate) {
       FBox b = new FBox(gridSize,gridSize);
       b.setStatic(false);
       b.setFillColor(crate);
       b.setPosition(x*gridSize,y*gridSize);
       world.add(b);
       boxes.add(b);
     }
     if(c == CBridge) {
       FBox cb = new FBox(gridSize,gridSize);
       cb.setStatic(true);
       cb.setName("Collapsing_Bridge");
       cb.setFillColor(CBridge);
       cb.setPosition(x*gridSize,y*gridSize);
       world.add(cb);
       collapsing.add(cb);
     }
     if(c == steel) {
       FBox b  = new FBox(gridSize,gridSize);
       b.setStatic(true);
       b.setName("platform_box");
       b.setFillColor(steel);
       b.setPosition(x*gridSize,y*gridSize);
       world.add(b);
     }
     if(c == lava) {
       FBox l = new FBox(gridSize,gridSize);
       l.setStatic(false);
       l.setFillColor(lava);
       l.setName("lava");
       l.setDensity(0.1);
       l.setPosition(x*gridSize,y*gridSize);
       world.add(l);
       liquid.add(l);
     }
     x++;
     if (x>map.width) {
       y++;
       x = 0;
     }
   }

  player = new FBox(10,10);
  player.setName("player_body");
  player.setFill(255);
  player.setNoStroke();
  player.setPosition(350, 200);
  player.setGrabbable(false);
  //player.setAngularVelocity(0);
  player.setRotation(0);
  player.setRotatable(false);
  player.setFriction(10);
  world.add(player);
}

void draw() {
  background(255);
  act();
  animations();
  animationRestrictions();
  
  //use these lines of code to enable the jetpack
  //if(jetpack == null && w == true) {
  //  jetpack = new FJetpack();
  //}
  
  //if(jetpack != null) {
  //  jetpack.countdown();
  //  jetpack.propulsion();
  //  //jetpack.goaway();
  //}
  
  //Create beam when 'f' key is pressed
  if(beam == null && f == true) {
    beam = new FBeam();
  }
  if(beam !=null) {
    beam.setFill(0,0,255);
    beam.countdown();
    beam.shoot();
    beam.DidItHit();
  }
  
  //Create bomb when 'g' key is pressed
  if(bomb == null  && g == true) {
    bomb = new FBomb();
  }
  if(bomb != null) {
    bomb.setFillColor(red);
    bomb.countdown();
    bomb.kaboom();
  }
  
  if(player.getVelocityX() == 0 && w == false) {
    currentAction = new PImage[1];
    currentAction[0] = loadImage("megaman0.png");
  }

  pushMatrix();
  
  for (FBox box : boxes) {
    stroke(255, 0, 0);
    if (dist(mouseX, mouseY, box.getX(), box.getY()) < 2) {
      line(mouseX, mouseY, box.getX(), box.getY());

      if (mousePressed == true) {
        b.setStatic(true);
      }
    }
  } 
  translate(-player.getX()+width/2, -player.getY()+height/2);
  world.step();
  world.draw();

  popMatrix();
 }

//Controls
void keyPressed() { //============================================================================================== 
  if (key == 'w' || key == 'W' ) w = true;
  if (key == 'a' || key == 'A' ) a = true;  
  if (key == 's' || key == 'S' ) s = true;
  if (key == 'd' || key == 'D' ) d = true;
  if (key == 'g' || key == 'G' ) g = true;
  if (key == 'f' || key == 'F' ) f = true;
}

void keyReleased() { //=============================================================================================
  if (key == 'w' || key == 'W' ) w = false;  
  if (key == 'a' || key == 'A' ) a = false;
  if (key == 's' || key == 'S' ) s = false;
  if (key == 'd' || key == 'D' ) d = false;
  if (key == 'g' || key == 'G' ) g = false;
  if (key == 'f' || key == 'F' ) f = false;
}


void contactStarted(FContact contact) {
  
  //Contact between player and teleport box
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "teleport_box")|| (contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "teleport_box")) {
    //TODO 
  }
  
  //Contact between player and regular platform
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "platform_box")||(contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "platform_box")) {
    canjump = true;
  }
   
   //Contact between water and lava
   if((contact.getBody1().getName() == "lava" && contact.getBody2().getName() == "water")|| (contact.getBody2().getName() == "lava" && contact.getBody1().getName() == "water")) {
     FBody lavaBody;
     if(contact.getBody1().getName() == "lava"){
       lavaBody = contact.getBody1();
     }else{
       lavaBody = contact.getBody2();
     }
     lavaBody.setFillColor(rock);
   }
   
   //Contact between player & lava blocks
   if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "lava")||(contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "lava")) {
      //TODO
   }
   
   // if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "Collapsing_Bridge")||
   //  (contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "Collapsing_Bridge")) {
   // //Put contact stuff here
   // //if(jump == 1) {
   // //  jump = 0;
   // //}
   //  //for (FBox box : collapsing) {
   // print("collapsing has ");
   // print(collapsing.size());
   // println(" items");
   //  // box.setStatic(false);
   //  int i = 0;
   //   for(FBox box : collapsing) {
   ////if (contact.contains("player", "Collapsing_Bridge")) {
   //     box.setStatic(false);
   //     print("Box number" + i +"has x="+box.getX() + " y=%0d"+ box.getY());
   //     i++;
   //// }
   //   }
   
   //  // }
   //  }
   
   for(FBox box : collapsing) {
   if (contact.contains("player", "Collapsing_Bridge")) {
     box.setStatic(false);
    }
  }
}
