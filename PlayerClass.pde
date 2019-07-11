class PlayerClass {
  float ability=0;
  int playerW = 15; // width of paddle
  float playerH = height*.2; // hieght of paddle
  float initialX;
  PVector Location= new PVector(0, 0);
  PVector Velocity= new PVector(0, 0);
  PVector Acceleration= new PVector(0, 0);
  int paddleGrow =0;
  float endTime;
  float refractoryTime=0;
  boolean refractory=false;
  float ballShoot=0;
  int curr;
  float mov=0;
  int upSwitch=0;
  int downSwitch=0;
  int startSwitch=2;
  float x;
boolean jump=false;
  //sound
  boolean paddleBounceS=false;
  boolean laserS=false;
  boolean growS=false;

  PlayerClass(float x, float y) {
    Location.x=x;
    Location.y=y; 
    initialX= x;
  }

  void nav() {

   if(arduino.digitalRead(6)==1 && upSwitch==0){
     print("OK");
   mov=-18;
   upSwitch=1;
    Location.y= Location.y+mov;
   }else if(arduino.digitalRead(7)==1 && downSwitch==0){
   mov+=18;
   downSwitch=1;
    Location.y= Location.y+mov;
   }
   
   if(arduino.digitalRead(6)==0 && upSwitch==1){
   upSwitch=0;
   }else if(arduino.digitalRead(7)==0 && downSwitch==1){
   downSwitch=0;
   }
   
    //if(keyPressed){

    //if(key=='w' || key =='B'){
    //Location.y+=6;
    //}else if (key=='s' || key== 'S'){
    //  Location.y-=6;
    //}
    //}
  }
  void refractory(float timeStart) {
    if (refractory==true && refractoryTime==0) {
      fill(254, 91, 53);
      refractoryTime= timeStart+3;
    }

    if (refractory==true && refractoryTime-timeStart <=0.0) {
     
      fill(254, 91, 53); 
      refractory=false;
      refractoryTime=0;
    }
  }
  void large(float timeStart) {

    if (arduino.digitalRead(10)==0 && ability==0 && paddleGrow==0 && refractory==false) {
      paddleGrow=1;
      print("OK");
      ability=1;
      growS=true;
    }

    if (paddleGrow==1 && playerH<height*.4) {
      playerH+=10;
    } else if (playerH>=(height*.4)&& paddleGrow!=2) {
      endTime=timeStart+6;
      paddleGrow=2;
    } else if (paddleGrow==2 && timeStart>= endTime && playerH>=height*.2) {

      playerH=playerH-8;
    } else if (paddleGrow==2 && playerH<=height*.2) {
      paddleGrow=3;
      playerH=height*.2;
    }
    if (paddleGrow==3) {
      this.refractory=true;
      paddleGrow=0;
      ability=0;
    }
  }
  void ballShoot() {
    if(startSwitch==2){
startSwitch=arduino.digitalRead(9);
    }
    if (arduino.digitalRead(9)!=startSwitch && ability==0 && refractory==false) {

      ability=1;
      ballShoot=1;
    }
  
    if ((arduino.digitalRead(8)==1)&& ballShoot==1) {
      ballShoot=2;
      laserS=true;
    }
    if (ballShoot==3) {
      ballShoot=0;
      ability=0;
    }
  }

  void play1() {

    if (jump==true && Location.x<=width/2) {
      Velocity.x+= 6;
    }
  }


  void display() {
  if(refractory==false){
fill(0,2255,0);
  }else if(refractory==true){
  fill(130,20,80);
  }
    rect(Location.x, Location.y, playerW, playerH);
  }

  void collide(BallClass ball) {


    if (Location.x -playerW/2 < ball.ballLoc.x + ball.ballsize/2 && Location.x+playerW/2 >ball.ballLoc.x-ball.ballsize/2
      && Location.y-playerH/2 < ball.ballLoc.y+ball.ballsize/2 && Location.y +playerH/2>ball.ballLoc.y-ball.ballsize/2) {
      paddleBounceS=true;
      frameRate(14);
      ball.r=255;
      ball.g=255;
      ball.b=255;
      ball.ballsize=25;
      ball.velocity.x-=1;
      ball.velocity.x=ball.velocity.x *-1;
      ball.direction= ball.direction*-1;
    }
  }
  void update() {
    
    if (Location.x>=initialX) {
      Acceleration.x=-.35;   //ACCELERATION NEGATIVE
    } else {
      Acceleration.x= 0;
      Location.x=initialX;
      Velocity.x=0;
    }
    Velocity.limit(6);
    Velocity.add(Acceleration);
    Location.add(Velocity);
  }
}