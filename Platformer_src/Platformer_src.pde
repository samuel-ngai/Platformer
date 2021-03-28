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
PImage[] runR; //Running in right direction
PImage[] runL; //Running in left direction
PImage[] facingR; //Facing right direction (idle)
PImage[] facingL; //Facing left direction (idle)
PImage[] currentAction; //currentAction of player
PImage[] jump; //Jumping animation
PImage[] falling; //Falling animation
PImage flame; //Flame image for jetpack

//Used if title screen is implemented (mode = 0 for title, 1 for game, 2 for game over)
int mode = 0;

//Colours 
color black = #000000;
color water = #10D2FC;
color red = #FFFFFF;
color bounce = #F46F35; //(244,111,53) orange
color teleport = #2BFFAF; //(42,255,175) light lime green
color crate = #B38342; //Beige
color CBridge = #C615DF; //Purple
color steel = #ACACAC; //Silver
color lava = #DF4800; //Dark orange (almost red)
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
  size(700, 700, FX2D); //Initialize dimensions of your screen
  
  //Initializing world 
  Fisica.init(this); //Initialize physics engine
  world = new FWorld(-100000, -100000, 100000, 100000); //New world with dimensions 
  world.setGravity(0, 900); //Set world's gravity
  
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
     color c = map.get(x, y); //Set variable c as the current pixel's colour 
     if (c == black) { //If the pixel is black
       FBox b = new FBox(gridSize, gridSize); //New FBox object of size gridSize
       b.setStatic(true); //Immovable (not affected by gravity), set to FALSE after contact with FBeam or FBomb
       b.setName("platform_box"); //Set object's name
       b.setFill(black); //Set FBox object's colour to black
       b.setPosition(x*gridSize, y*gridSize); //Set FBox object's position to corresponding map coordinates
       world.add(b); //Adding object to world
       boxes.add(b); //Adding object to ArrayList of platform objects
     }
     if (c == water) { //If pixel is water coloured
       FBox l = new FBox(gridSize, gridSize); //New FBox object of size gridSize
       l.setStatic(false); //Movable (Affected by gravity, FBeam, and FBomb)
       l.setFillColor(water); //Set FBox object's colour to water colour
       l.setName("water"); //Set object's name
       l.setDensity(0.001); //Set object's density (adjusted to act like water)
       l.setPosition(x*gridSize, y*gridSize); //Set FBox object's position to corresponding map coordinates
       l.setNoStroke(); //No outline
       world.add(l); //Adding object to world
       liquid.add(l); //Adding object to ArrayList of liquid objects
     }
     if (c == bounce) { //If pixel is colour of bouncy platform
       FBox b = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       b.setStatic(true); //Immovable (Not affected by gravity), set to FALSE after contact with FBeam or FBomb
       b.setFillColor(bounce); //Set FBox object's colour to bouncy object colour
       b.setPosition(x*gridSize,y*gridSize); //Set FBox object's position to corresponding map coordinates
       b.setRestitution(3); //Set bouncy level 
       world.add(b); //Add object to world
       boxes.add(b); //Add object to ArrayList of platform objects
     }
     if(c == teleport) { //If pixel is colour of teleporting pad
       FBox b = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       b.setName("teleport_box"); //Set object's name
       b.setStatic(true); //Immovable (Not affected by gravity), set to FALSE after contact with FBeam or FBomb
       b.setFillColor(teleport); //Set FBox object's colour to teleport object's color
       b.setPosition(x*gridSize,y*gridSize); //Set FBox object's postion to corresponding map coordinates
       b.setNoStroke(); //No outline
       world.add(b); //Add object to world
       boxes.add(b); //Add object to ArrayList of platform objects
     }
     if(c == crate) { //If pixel is colour of crate
       FBox b = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       b.setStatic(false); //Movable (Affected by gravity, FBeam, FBomb)
       b.setFillColor(crate); //Set object's color to crate color
       b.setPosition(x*gridSize,y*gridSize); //Set Fbox object's position to corresponding map coordinates
       world.add(b); //Add object to world
       boxes.add(b); //Add object to ArrayList of platform objects
     }
     if(c == CBridge) { //If pixel is colour of collapsing bridge
       FBox cb = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       cb.setStatic(true); //Immovable (Not affected by gravity), set to FALSE after contact with FBeam, FBomb
       cb.setName("Collapsing_Bridge"); //Set object's name
       cb.setFillColor(CBridge); //Set object's color to CBridge preset
       cb.setPosition(x*gridSize,y*gridSize); //Set FBox object's position to corresponding map coordinates
       world.add(cb); //Add object to world
       collapsing.add(cb); //Add object to ArrayList of collapsing bridge objects
     }
     if(c == steel) { //If pixel is colour of steel
       FBox b  = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       b.setStatic(true); //Immovable (Not affected by gravity) CANNOT BE AFFECTED BY FBEAM OR FBOMB
       b.setName("platform_box"); //Set object's name
       b.setFillColor(steel); //Set object's colour to steel preset
       b.setPosition(x*gridSize,y*gridSize); //Set Fbox object's position to corresponding map coordinates
       world.add(b); //Add object to world
     }
     if(c == lava) { //If pixel is colour of lava
       FBox l = new FBox(gridSize,gridSize); //New FBox object of size gridSize
       l.setStatic(false); //Movable (Affected by gravity, FBeam, FBomb)
       l.setFillColor(lava); //Set object's colour to lava preset
       l.setName("lava"); //Set object's name
       l.setDensity(0.1); //Set density
       l.setPosition(x*gridSize,y*gridSize); //Set FBox object's position to corresponding map coordinates
       world.add(l); //Add object to world
       liquid.add(l); //Add object to ArrayList of liquids
     }
     x++;
     if (x>map.width) { //If x is past the end of the map, increment y
       y++; //increment y (next level of pixels)
       x = 0; //reset x for newline of pixels
     }
   }
   
  //Initializing player object
  player = new FBox(10,10); //New FBox object of size 10, 10
  player.setName("player_body"); //Set player object's name
  player.setFill(255); //Set object color
  player.setNoStroke(); //No outline
  player.setPosition(350, 200); //Set spawn location 
  player.setGrabbable(false); //Can't be moved by mouse
  //player.setAngularVelocity(0);
  player.setRotation(0); //Set rotation to 0
  player.setRotatable(false); //Can't rotate
  player.setFriction(10); //Set friction between object and platforms 
  world.add(player); //Add player object to world
}

void draw() {
  background(255); //Background = white
  act(); //Act function handles WASD movement and horizontal movement animations
  animations(); //Handles animation speed and looping
  animationRestrictions(); //Handles vertical animations
  
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
    beam = new FBeam(); //New FBeam object 
  }
  if(beam !=null) { //While FBeam timer != 0
    beam.setFill(0,0,255); //Set beam colour
    beam.countdown(); //Initiate countdown
    beam.shoot(); //Sets beam object's horizontal velocity
    beam.DidItHit(); //Handles collisions between beam object and others
  }
  
  //Create bomb when 'g' key is pressed
  if(bomb == null  && g == true) {
    bomb = new FBomb(); //New FBomb object
  }
  if(bomb != null) { //While FBomb timer != 0
    bomb.setFillColor(red); //Set bomb colour
    bomb.countdown(); //Initiate countdown
    bomb.kaboom(); //Handles explosion animation and new velocities of blocks affected
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

  //Contact between player and teleport box (and vice versa to ensure correct collisions)
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "teleport_box")|| (contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "teleport_box")) {
    //TODO 
  }
  
  //Contact between player and regular platform (and vice versa to ensure correct collisions)
  if((contact.getBody1().getName() == "player_body" && contact.getBody2().getName() == "platform_box")||(contact.getBody2().getName() == "player_body" && contact.getBody1().getName() == "platform_box")) {
    //Assures no double jumps
    canjump = true;
  }
   
  //Contact between water and lava (and vice versa to ensure correct collisions)
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
   
  //Contact between player & lava blocks (and vice versa to ensure correct collisions)
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
