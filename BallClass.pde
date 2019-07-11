class BallClass {
  PVector ballLoc, velocity; 
  int ballsize = 16; // width of ball
 
  int rand=0;
  int updown=0;
  int direction;
  int r=255;
  int b=0; 
  int g=0;
  //sound
  boolean bounceS=false;
  boolean pointS=false;
  
  
  BallClass() {
    ballLoc = new PVector(width/2, height/2);
    
  }
  void firstMove(){
  rand= round(random(0,1));
  updown=round(random(0,1));
  if(rand==0){
    if(updown==0){
    velocity= new PVector(random(6,8), random(1,10));
     direction=1;
    }else{
  velocity= new PVector(random(6,8),random(-1, -10));
  direction=1;
    }
  }else if(rand==1){
  if(updown==0){
    velocity= new PVector(random(-6,-8), random(1,10));
    direction=-1;
    }else{
  velocity= new PVector(random(-6,-8),random(-1,-10));
  direction=-1;
    }
  }

  }
  void move() {
    ballLoc.add(velocity); 
    
    if (ballLoc.y > height || ballLoc.y < 0) {
      velocity.y *= -1;
      bounceS=true;
    }
    
    
    if(ballLoc.x > width || ballLoc.x<0){
      if(ballLoc.x > width){
        pointS=true;
      scoreL++;
      }else{
      scoreR++;
       pointS=true;
      }
    ballLoc.x=width/2;
    ballLoc.y=height/2;
    ball.direction=0;
    ball.firstMove();
      
    }
  }
  void display() {
    fill(r,g,b);
    ellipse(ballLoc.x, ballLoc.y, ballsize, ballsize);
  }
}