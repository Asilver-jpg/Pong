import processing.sound.*;

import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
PlayerClass player1;
PlayerClass2 player2;
BallClass ball; 
int upPin = 6;
int downPin= 7;
int shootPin=8;
int laserPin=9;
int growPin=10;


int firstSwitch=1;
int time;
int timeEnd;
pellet pelletOne;
pellet pelletTwo;
int scoreL= 0;
int scoreR=0;
int gameState=0;
boolean press=false;


boolean laserToggle=false;
boolean shootToggle=false;

//sound
SoundFile bounce;
SoundFile explode;
SoundFile grow;
SoundFile laser;
SoundFile paddleBounce;
SoundFile pause;
SoundFile point;
SoundFile bit;

boolean pauseS=false;
boolean pointS=false;
//fan variables

int read;
int base;
int arrayVal=0;
boolean baseSwitch=true;
ArrayList <Integer> baseNumbers= new ArrayList<Integer>();
int total=0;

void setup() {
  //fullScreen();
 
  smooth();// make the graphics look purdy. 
  rectMode(CENTER); // draw rects from center
  player1 = new PlayerClass(20, height/2); 
  player2 = new PlayerClass2(width -20, height/2); 
  ball = new BallClass();
  pelletOne=new pellet(player1, ball);
  pelletTwo=new pellet(player2,ball);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(upPin, Arduino.INPUT);
    arduino.pinMode(downPin, Arduino.INPUT);
   arduino.pinMode(laserPin, Arduino.INPUT);
    arduino.pinMode(growPin, Arduino.INPUT);
     arduino.pinMode(shootPin, Arduino.INPUT);
  
  bounce= new SoundFile(this,"bounce.wav");
   explode= new SoundFile(this,"explode.wav");
    grow= new SoundFile(this,"grow.wav");
     laser= new SoundFile(this,"laser.wav");
      paddleBounce= new SoundFile(this,"paddleBounce.wav");
       pause= new SoundFile(this,"pause.wav");
        point= new SoundFile(this,"point.wav");
        bit= new SoundFile(this,"8bit.wav");
        bit.play();
        if(arduino.digitalRead(8)==1){
        shootToggle=true;
        }
        if( arduino.digitalRead(9)==1){
        laserToggle=true;
        }
}

void draw () {
  
frameRate(60);
ball.r=255;
ball.g=0;
ball.b=0;
ball.ballsize=16;
read=arduino.analogRead(0);
if(baseSwitch==true){
base();
}else if(baseSwitch==false){
checkOver();
}
if(gameState==0){
   background(0);
  textSize(140);
  text("Super Pong", width/3-120, height/3);
  textSize(30);
  text("Press the spacebar to start. Play till 10",width/3-20, height-300);
 text("Press the spacebar again to pause",width/3, height-200);
 if(shootToggle==true){
 text("Turn off button", width/3,height-300);
 }
 if(laserToggle==true){
 text("Turn off switch", width/3, height-400);
 }
  if(press==true){
  gameState++;
  press=false;
  }
}else if(gameState==1){
  
  if(press==true){
  gameState++;
  press=false;
  pauseS=true;
  }
 background (0);// background color

  time=millis()/1000;

  player1.display();
  player2.display();
  if (firstSwitch==1) {
    ball.firstMove();
    firstSwitch=0;
  }
  if (ball.direction==1) {
    player2.collide(ball);
  } else if (ball.direction==-1) {
    player1.collide(ball);
  }
  player1.nav();
  player2.nav();
  player1.play1();
  player2.play1();
  player1.large(time);
  player1.refractory(time);
  player1.ballShoot();
  player2.large(time);
  player2.refractory(time);
  player2.ballShoot();

//read= arduino.analogRead(buttonPin);


  
  if (player1.ballShoot==1) {
    pelletOne.position();
    pelletOne.display();
  } else if (player1.ballShoot==2) {
    pelletOne.shoot=true;
    pelletOne.shoot();
    pelletOne.update();
    pelletOne.display();
    pelletOne.collide();
  }
  
   if (player2.ballShoot==1) {
    pelletTwo.position2();
    pelletTwo.display();
  } else if (player2.ballShoot==2) {
    pelletTwo.shoot=true;
    pelletTwo.shoot();
    pelletTwo.update();
    pelletTwo.display();
    pelletTwo.collide();
  }
 
  player1.update();
  player2.update();
  ball.move(); 
  ball.display();
  scores();
//sounds
if(ball.bounceS==true){
bounce.play();
ball.bounceS=false;
}
if(pelletOne.explodeS==true || pelletTwo.explodeS==true){
explode.play();
pelletOne.explodeS=false;
pelletTwo.explodeS=false;
}
if(player1.laserS==true || player2.laserS==true){
laser.play();
player1.laserS=false;
player2.laserS=false;
}
if(player1.growS==true || player2.growS==true){
grow.play();
player1.growS=false;
player2.growS=false;
}
if(player1.paddleBounceS==true || player2.paddleBounceS==true){
  paddleBounce.play();
  player1.paddleBounceS=false;
  player2.paddleBounceS=false;
}
if(pauseS==true){
pause.play();
pauseS=false;
}
if(ball.pointS==true){
point.play();
ball.pointS=false;
}
}else if(gameState==2){
  textSize(20);
  text("Paused", width*.45, height*.5);
if(press==true){
  gameState--;
  press=false;
  }
}
}


void scores() {
  fill(255);
  textSize(100);
  text(scoreL, 100, 130);
  text(scoreR, width-200, 130);
  if(scoreR==10){
  gameState--;
  scoreR=0;
  scoreL=0;
  }else if(scoreL==10){
    gameState--;  
  scoreR=0;
  scoreL=0;  
}
}

void base() {
  if (time<=6) {

    baseNumbers.add(read);

    arrayVal++;
  } else if (time>6) {
    for (int i=0; i<baseNumbers.size(); i++) {
      total+=baseNumbers.get(i);
    }
    base= mode(baseNumbers);
    baseSwitch=false;
  }
}
public int mode(ArrayList<Integer> array) {
  int mode = array.get(0);
  int maxCount = 0;
  for (int i = 0; i < array.size(); i++) {
    int value = array.get(i);
    int count = 1;
    for (int j = 0; j < array.size(); j++) {
      if (array.get(j) == value) count++;
      if (count > maxCount) {
        mode = value;
        maxCount = count;
      }
    }
  }
  return mode;
}
 void checkOver(){
  
  if(abs(read-base)>100){
   
 player1.jump=true;
  
  }else if(abs(read-base)<100){
  player1.jump=false;
  }
 }
void keyPressed(){
if(key==32){
press=true;
}
if(key=='w' || key=='W'){
player2.upPress=true;
}
if(key=='d'|| key=='D'){
  player2.downPress=true;
}
}