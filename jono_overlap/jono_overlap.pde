Robot bot1;
Robot bot2;

void setup() {
  size(720, 480); // make sure this matches the global variables above
  bot1 = new Robot("rect");
  bot1.key1 = 'a';
  bot1.key2 = 's';
  bot2 = new Robot("circ");
  bot2.key1 = 'o';
  bot2.key2 = 'p';
  smooth();
  textSize(24);
  textAlign(CENTER);
  println("setup completed");
}

void draw() {
  background(0);
  // Update and display first robot
  if (bot1.moveShape(bot2, 1))
    bot1.update();
  bot1.display();
  // Update and display second robot
  if(bot2.moveShape(bot1, -1))
    bot2.update();
  bot2.display();
  
}

class Robot {
  float sizeMin = 50;
  float xpos;
  float ypos;
  float initialSize;
  float size;
  String shape;
  float angle;
  float boundw = 720;
  float boundh = 480;
  char key1; // key to press to grow the shape
  char key2; // key to press to shrink the shape
  int r = 255; int g = 255; int b = 255;
  int[] border = {10,10};
  //float yoffset = 0.0;
  // Set initial values in constructor
  Robot(String desiredShape){
    xpos = random(0, 200);
    ypos = random(0,200);
    initialSize = random(50,200);
    size = initialSize;
    r = (int)random(0, 100);
    g = (int)random(0,100);
    b = (int)random(100,220);
    shape = desiredShape;
  }
  
  float[][] shapePts(){
    float[] pt1 = {this.xpos, this.ypos}; //top left corner
    float[] pt3 = {this.xpos+this.size, this.ypos+this.size}; //bottom right corner
    float[][] shapePts = {pt1, pt3};
    return shapePts;
  }
  
  // Checks if this bot is inside the boundaries of the window
  // Returns 0,0 if the shape is inside boundaries, direction to move if it's not
  int[] boundaryCheck(){
    float[][] pts = this.shapePts();
    int[] check = {0,0}; //returns X and Y check
    if (pts[0][0] < this.border[0]) // Check that shape is inside top left corner
      check[0] = 1;
    if(pts[1][0] > boundw) 
      check[0] = -1;
    if (pts[0][1] < this.border[1])
      check[0] = 1;
    if (pts[1][1] > boundh) // check that shape is inside bottom R corner
        check[1] = -1;
    return check;
  }
  
  //Takes new bot and direction (-1 or 1) to determine which way to move
  // Returns a value for update; false means overlaps and boundary crash >> don't grow anymore!
  boolean moveShape(Robot bot2, int dir){
    boolean check = true;
    int[] collision = this.checkOverlap(bot2);
    //println("checkOverlap is returning ", collision[0], ", ", collision[1]);
    if (this.boundaryCheck()[0] == 0){ //check boundary (X)
      this.xpos += dir*3*collision[0];
    } 
    else if (collision[0] != 0) // IF outside boundaries (X) AND there IS overlap (X)
      check = false;
    else this.xpos += this.boundaryCheck()[0];
    if(this.boundaryCheck()[1] == 0){
       this.ypos += dir*3*collision[1];
    }
    else if (collision[1] != 0) // IF outside boundaries (Y) AND there IS overlap (Y)
      check = false;
    else this.ypos += this.boundaryCheck()[1];
    //if(this.boundaryCheck()[0] && this.boundaryCheck()[1]) // If hitting X and Y boundaries
    //  check = false;
    return check;
  } 
   
   
   //Compares this (bot1) to bot2 to check overlap
   //If overlap, this returns x, y values of which way to move bot1 away from bot2
   int[] checkOverlap(Robot shape2){
     float[][] newPts = this.shapePts();
     //println("this shape points are {", newPts[0][0], ", ", newPts[0][1], "}, {", 
     //          newPts[1][0], ", ", newPts[1][1], "}");
     float[][] comparePts = shape2.shapePts();
     //println("shape2 points are {", comparePts[0][0], ", ", comparePts[0][1], "}, {", 
     //          comparePts[1][0], ", ", comparePts[1][1], "}");
     float ax0  = newPts[0][0]; float ay0 = newPts[0][1];
     float ax1 = newPts[1][0]; float ay1 = newPts[1][1]; 
     float bx0 = comparePts[0][0]; float by0 = comparePts[0][1]; 
     float bx1 = comparePts[1][0]; float by1 = comparePts[1][1];
     float topA = min(ay0, ay1);
     float botA = max(ay0, ay1);
     float leftA = min(ax0, ax1);
     float rightA = max(ax0, ax1);
     float topB = min(by0, by1);
     float botB = max(by0, by1);
     float leftB = min(bx0, bx1);
     float rightB = max(bx0, bx1);
     int[] move = {0,0};
     if (!(botA <= topB  || botB <= topA || rightA <= leftB || rightB <= leftA)){ 
       if (botA > topB){
        move[1] = 1; //this shape needs to move up (pos y)
        } if (botB > topA){
        move[1] =  -1; //this shape needs to move down (neg y)
        } if (rightA > leftB){
        move[0] =  -1; //this shape needs to move left (negative x)
        } if (rightB < leftA){
        move[0] = 1; // this shape needs to move right (positive x)
        }
     }
     return move;
   }
    
  // Update the fields
  void update() {
    if (mousePressed){
    size += 3;
    }
    if (keyPressed){
      //println("keyPressed is " + int(key));
      if (key == key1)
        size += 3;
      else if ((key == key2) && size > sizeMin)
        size -= 3;
      else if (int(key) == 32)
        setup();
    }
    if (size > initialSize ){
      size += -0.5;
    }
    
 
  }
  // Draw the robot to the screen
  void display() {
    fill(r, g, b);
    if (shape == "circ")
        ellipse(xpos+size/2, ypos+size/2, size, size);
    else rect(xpos, ypos, size, size); 
    fill(0, 0, 0);
    text("+: "+key1, xpos+size/2, ypos+size/2-16);
    text("-: "+key2, xpos+size/2, ypos+size/2+16);
  }
}