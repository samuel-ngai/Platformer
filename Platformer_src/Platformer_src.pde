import fisica.*;

FBomb bomb;
FJetpack jetpack;
FWorld world;
FBeam beam;

//PImage looping index variable
int costumeNum = 0;

//Controls
boolean w, a, s, d, g, f;

//PImage is the datatype for storing images
PImage map; //map drawn to load world from

//Arrays of images for movement animations
PImage[] runR;
PImage[] runL;
PImage[] facingR;
PImage[] facingL;
PImage[] currentAction;
PImage[] jump;
PImage[] falling;
PImage flame;

//Used if title screen is implemented (mode = 0 for title, 1 for game, 2 for game over)
int mode = 0;

//Colours 
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

int gridSize = 15; //Size of all FBox objects

FBox b; //regular block objects
FBox l; //liquid (lava, water) objects
FBox cb; //Collapsing bridge objects
FBox player; //player object

//ArrayList of different types of FBoxes loaded
ArrayList<FBox> boxes = new ArrayList<FBox>(); //Platform boxes
ArrayList<FBox> liquid = new ArrayList<FBox>(); //Water & lava blocks
ArrayList<FBox> collapsing = new ArrayList<FBox>(); //Collapsing bridge

boolean canjump = true; //Set to false whenever we jump, true when we are standing/land on a box

void setup() {
  //Size of world
  size(700, 700, FX2D);
  
  //Initializing world 
  Fisica.init(this);
  world = new FWorld(-100000, -100000, 100000, 100000);
  world.setGravity(0, 900);
  
  //Loading images for running Right animation
  runR = new PImage[3];
  runR[0] = loadImage("megaman3.png");
  runR[1] = loadImage("megaman4.png");
  runR[2] = loadImage("megaman5.png");
  
  //Loading images for running Left animation
  runL = new PImage[3];
  runL[0] = loadImage("megaman11.png");
  runL[1] = loadImage("megaman12.png");
  runL[2] = loadImage("megaman13.png");
 
  //Loading images for idle (just loaded into game)
  currentAction = new PImage[1];
  currentAction[0] = loadImage("megaman0.png");
 
  //Loading image for idle (last direction moved = right)
  facingR = new PImage[1];
  facingR[0] = loadImage("megaman0.png");
 
  //Loading image for idle (last direction moved = left)
  facingL = new PImage[1];
  facingL[0] = loadImage("megaman14.png");
 
  //Jumping animation
  jump = new PImage[1]; 
  jump[0] = loadImage("megaman6.png");
  //jump[1] = loadImage("megaman8.png");
 
  //Falling animation
  falling = new PImage[1];
  falling[0] = loadImage("megaman8.png");
  
  //Loads map image
  map = loadImage("map.png");
  
  //Loads flame image for jetpack
  flame = loadImage("flame.png");
 
  //Loops through map dimensions (by pixel), creates new FBox objects depending on pixel colour
  int x = 0;
  int y = 0;
  while (y< map.height) {
     //Identifying different pixels by the color presets
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
   
  //Initializing player object
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
  background(255); //Background = white
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
  
  translate(-player.getX()+width/2, -player.getY()+height/2); //Moves screen when player moves (keeps player centered)
  world.step(); //Advances world
  world.draw(); //Loops draw function to update the world 

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

//Collisions
void contactStarted(FContact contact) {
  
  //Contact between player and teleport box
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "teleport_box")|| (contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "teleport_box")) {
    //TODO 
  }
  
  //Contact between player and regular platform
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "platform_box")||(contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "platform_box")) {
    //Assures no double jumps
    canjump = true;
  }
   
   //Contact between water and lava
   if((contact.getBody1().getName() == "lava" && contact.getBody2().getName() == "water") || (contact.getBody2().getName() == "lava" && contact.getBody1().getName() == "water")) {
     FBody lavaBody;
     //If lava touches water, lava turns to rock
     if(contact.getBody1().getName() == "lava"){
       lavaBody = contact.getBody1();
     }else{
       lavaBody = contact.getBody2();
     }
     lavaBody.setFillColor(rock);
   }
   
   //Contact between player & lava blocks
   if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "lava")||(contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "lava")) {
      //TODO: game over
   }
   
   //Contact between player and collapsing bridge
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
