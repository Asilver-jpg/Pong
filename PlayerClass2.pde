class PlayerClass2{
  float ability=0;
int playerW = 15; // width of paddle
float playerH = height*.2; // hieght of paddle
float initialX;
PVector Location= new PVector(0,0);
PVector Velocity= new PVector(0,0);
PVector Acceleration= new PVector(0,0);
int paddleGrow =0;
float endTime;
float refractoryTime=0;
boolean refractory=false;
float ballShoot=0;

//sound
boolean paddleBounceS;
boolean laserS=false;
boolean growS=false;

boolean upPress=false;
boolean downPress=false;

PlayerClass2(float x, float y){
Location.x=x;
Location.y=y; 
initialX= x;


}

void nav(){
if(keyPressed){
  
if(upPress==true){
Location.y-=30;
upPress=false;
}else if (downPress==true){
  Location.y+=30;
  downPress=false;
}
}
}
void refractory(float timeStart){
if(refractory==true && refractoryTime==0){

refractoryTime= timeStart+3;
}

 if(refractory==true && refractoryTime-timeStart <=0.0){
   
 refractory=false;
 refractoryTime=0;
 
 } 
}
void large(float timeStart){
 
if(keyPressed){
  
if((key=='j' || key =='J') && ability==0 && paddleGrow==0 && refractory==false){
paddleGrow=1;
ability=1;
growS=true;
}
}
if(paddleGrow==1 && playerH<height*.4){
playerH+=10;
}else if(playerH>=(height*.4)&& paddleGrow!=2){
  endTime=timeStart+6;
 paddleGrow=2;
 
}else if(paddleGrow==2 && timeStart>= endTime && playerH>=height*.2){
  
playerH=playerH-8;

}else if(paddleGrow==2 && playerH<=height*.2){
paddleGrow=3;
playerH=height*.2;
}
if(paddleGrow==3){
this.refractory=true;
paddleGrow=0;
ability=0;
}

}
void ballShoot(){
  
if((key=='k' || key =='K') && ability==0 && refractory==false){
 
ability=1;
ballShoot=1;
}if((key=='l' || key =='L')&& ballShoot==1){
  laserS=true;
ballShoot=2;
}if(ballShoot==3){
ballShoot=0;
ability=0;
}
}

void play1(){
if((key==';' && Location.x>=width/2)){
 
Velocity.x-= 6; 
}
}


void display(){
  if(refractory==false){
fill(0,255,0);
  }else if(refractory==true){
  fill(130,20,80);
  }
rect(Location.x,Location.y, playerW, playerH);
}

void collide(BallClass ball){


if(Location.x -playerW/2 < ball.ballLoc.x + ball.ballsize/2 && Location.x+playerW/2 >ball.ballLoc.x-ball.ballsize/2
&& Location.y-playerH/2 < ball.ballLoc.y+ball.ballsize/2 && Location.y +playerH/2>ball.ballLoc.y-ball.ballsize/2){
  frameRate(14);
    ball.r=255;
      ball.g=255;
      ball.b=255;
      ball.ballsize=25;
ball.velocity.x+=1;
paddleBounceS=true;
ball.velocity.x=ball.velocity.x *-1;
ball.direction= ball.direction*-1;

}


}
void update(){
  if(Location.x<=initialX){
Acceleration.x=+.35;   //ACCELERATION NEGATIVE
}else{
Acceleration.x= 0;
Location.x=initialX;
Velocity.x=0;
}
Velocity.limit(6);
Velocity.add(Acceleration);
Location.add(Velocity);

}
void col(){
  if(refractory==false){
  fill(0,255,0);
  }else if(refractory==true){
  fill(254,91,53);
  }
}
}