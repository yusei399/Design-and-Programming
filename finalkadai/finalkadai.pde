import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import processing.opengl.*;
Minim minim;
AudioPlayer player;
AudioInput in;
FFT fft;
//int waveH = 100;
float elapsetime = 0, time = 0, timestamp = 0;

void setup(){
  size(displayWidth , displayHeight, OPENGL);
  blendMode(SCREEN);
  minim = new Minim(this);
  //in = minim.getLineIn(Minim.STEREO, 1024);
  player = minim.loadFile("New Composition #13.mp3", 1024);
  player.play();
  
  fft = new FFT(player.bufferSize(), player.sampleRate());
}

void draw(){
  elapsetime = float(millis()) / 1000;
  time = elapsetime - timestamp;
  //colorMode(RGB, #00FFFF);
  background(0);
  fft.forward(player.mix);
  
  noStroke();
  
  
  colorMode(HSB, 360, 100, 100, 255);
  //colorMode(RGB, #00FFFF);
  for(int i = 0; i < fft.specSize(); i++){
    text(time , 100, 100);
    float hue = map(i, 0, fft.specSize(), 0, width);
    fill(hue, 100, 100, 10);
    float radious = fft.getBand(i) * 5;
    ellipse(width / 2 , height / 2 , radious * 2, radious * 2);
  }
  //rects();
}

//void rects(){
//  translate(500, 500);
//  rotateY(radians(50));
//  box(150, 150, 150);
//}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
