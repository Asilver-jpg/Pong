
class pellet{
  PVector ballLoc, velocity; 
  int ballSize = 65; // width of ball
  PlayerClass player;
  PlayerClass2 player2;
  boolean shoot=false;
  float side=3;
  BallClass balls;
  int direction;
  
  //sound
  boolean explodeS=false;
  boolean laserS=false;
  
  pellet(PlayerClass play, BallClass balls){
  player=play;
 ballLoc= new PVector(0,0);
 velocity=new PVector(0,0);
 ball= balls;
 direction=1;
  }
  pellet(PlayerClass2 play, BallClass balls){
  player2=play;
 ballLoc= new PVector(0,0);
 velocity=new PVector(0,0);
 ball= balls;
 direction=-1;
  }
  
  
void position(){
 if(shoot==false){
 ballLoc.x=player.Location.x+17;
 ballLoc.y=player.Location.y;
 side=1;
 }
 }
 void position2(){
   if(shoot==false){
  ballLoc.x=player2.Location.x-17;
 ballLoc.y=player2.Location.y;
 side=0;
 
 }
 }
 void shoot(){

 
 if(shoot==true && side==0){
 velocity.limit(65);
 ballLoc.y=ballLoc.y;
 velocity.x-=65;
 }else if(shoot==true && side==1){
  velocity.x+=65;
 velocity.limit(65);
 ballLoc.y=ballLoc.y;
 }
 }
 
 
 void update(){
 ballLoc.add(velocity);
 }
 void display(){
   fill(255,0,0);
 ellipse(ballLoc.x, ballLoc.y,ballSize, ballSize);
 }
 void collide(){

   if(ballLoc.x -ballSize/2 < ball.ballLoc.x + ball.ballsize/2 && ballLoc.x+ball.ballsize/2 >ball.ballLoc.x-ball.ballsize/2
&& ballLoc.y-ballSize/2 < ball.ballLoc.y+ball.ballsize/2 && ballLoc.y +ballSize/2>ball.ballLoc.y-ball.ballsize/2){
  explodeS=true;
  if(direction==1){
  if(ball.direction==1)
  {
ball.velocity.x=ball.velocity.x +=20;
player.ability=0;
player.ballShoot=0;
player.refractory=true;
player.startSwitch=2;
shoot=false;
  }else if(ball.direction==-1){
  ball.velocity.x= ball.velocity.x *-1;
  ball.direction= ball.direction*-1;
  player.ballShoot=0;
player.refractory=true;
player.startSwitch=2;
shoot=false;
  }

}else if(direction==1){
  if(ball.direction==1){
    ball.velocity.x= ball.velocity.x *-1;
  ball.direction= ball.direction*-1;
  player.ability=0;
player.ballShoot=0;
player.refractory=true;
player.startSwitch=2;
shoot=false;
  }else if(ball.direction==-1){
    ball.velocity.x=ball.velocity.x -=20;
  player.ability=0;
player.ballShoot=0;
player.refractory=true;
player.startSwitch=2;
shoot=false;
  }

}
}
if(ballLoc.x>=width || ballLoc.x<=0){
player.ballShoot=0;
player.ability=0;
player.refractory=true;
player.startSwitch=2;
shoot=false;
}

 
 }
 
 
}