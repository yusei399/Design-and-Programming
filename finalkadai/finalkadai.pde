//1,プログラミングを使用することで音楽に合わせた３Dのアニメーションを実装することができた。
//2-1,3Dの図形を表示したりするのに配列とアニメーションを用いた。（配列とアニメーション）
//2-2,時間ごとにアニメーションが変わるよう実装した（時間・展開）
//2-3, アニメーションを実装する際に要素ごとの関数を作った。
//参考資料　https://yoppa.org/proga10/1301.html 256行目~260（値は変えています） 242〜246　61~64（授業資料）
//https://processing.org/（processing公式）
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

float elapsetime = 0;
float time = 0;
float timestamp = 0;
int NUM = 30;
float[] x = new float[NUM];
float[] y = new float[NUM];
float[] z = new float[NUM];
float[] rot = new float[NUM];
float[] rSpeed = new float[NUM];
color[] col = new color[NUM];

int n = 100;
int[] circleX = new int[n];
int[] circleY = new int[n];
int[] circleD = new int[n];
int[] circleVX = new int[n];
int[] circleVY = new int[n];
color[] c = new color[n];

int number = 128;
color[] colors = new color[number];
float offset = PI / NUM;
float i;
float x1 = 0.1, y1 = 0.1;
static final float a =  1.25, b = 0.75;

void setup(){
  size(displayWidth , displayHeight, OPENGL);
  frameRate(150);
  noStroke();
  smooth();
  minim = new Minim(this);
  player = minim.loadFile("New Composition #13.mp3", 1024);
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());

  for (int i = 0; i < circleX.length; i++) {
        circleD[i] = (int)random(2, 20);
        circleX[i] = (int)random(0, width);
        circleY[i] = (int)random(0, height);
        while (circleVX[i] == 0)
            circleVX[i] = (int)random(-5, 5);
        while (circleVY[i] == 0)
            circleVY[i] = (int)random(-5, 5);
        c[i] = color(random(100, 200), random(50, 200), 200, 100);
    }

  for (int j = 0; j < NUM; j++)
  {
    x[j] = random(width);
    y[j] = random(height);
    z[j] = random(-5000, 0);
    rot[j] = 0;
    rSpeed[j] = random(-0.1, 0.1);
    col[j] = color(random(100, 140), random(150, 220), random(150, 250));
  }
  for (int k = 0; k < number; k++)
    colors[k] = color(k * 2 + 100, 70, 100, 25);
  lights();
}

void draw(){
  elapsetime = float(millis()) / 1000;
  time = elapsetime - timestamp;
  background(0);
  fft.forward(player.mix);
  noStroke();
  if (time <= 90)
  {
    for(int i = 0; i < fft.specSize(); i++)
    {
      colorMode(HSB, 360, 100, 100, 255);
      float hue = map(i, 0, fft.specSize(), 0, width);
      fill(hue, 100, 100, 10);
      float radious = fft.getBand(i) * 5;
      ellipse(width / 2 , height / 2 , radious * 2, radious * 2);
      if (time >= 2 && time <= 10)
      {
        fill(hue * 3,255);
        ellipse(width / 4, height / 4, radious * 2, radious * 2);
      }
      if (time >= 4 && time <= 10)
        ellipse(width / 4, height - (height / 4), radious * 2, radious * 2);
      if (time >= 6 && time <= 10)
        ellipse(width - (width /4) , height / 4, radious * 2, radious * 2);
      if (time >= 8 && time <= 10)
        ellipse(width - (width / 4) , height - (height / 4), radious * 2, radious * 2);
      if (time >= 10 && time <= 20)
      {
        background(0);
        for (int j = 0; j <NUM; j++)
        {
          if(j % 2 != 0 || j % 3 != 0)
          {          
            fill(random(0, 255),random(0, 255),random(0, 255));
            stroke(255);
            pushMatrix();
            translate(x[j], y[j], z[j]);
            rotateX(radious);
            rotateY(radious);
            rotateZ(radious);
            box(radious * 200);
            popMatrix();
            z[j]+= radious;
            rot[j] += rSpeed[j];
            if (z[j]>1000)
              z[j] -= 5000;
          }
          else
          {
            noFill();
            stroke(255);
            pushMatrix();
            translate(x[j], y[j], z[j]);
            rotateX(radious);
            rotateY(radious);
            rotateZ(radious);
            box(radious * 200);
            popMatrix();
            z[j]+= radious;
            rot[j] += rSpeed[j];
            if (z[j]>1000) 
              z[j] -= 5000;
          }
        }
      }
      if (time >= 20 && time <= 30)
        rects(); 
      if (time >= 80 && time <= 82)
      {
        fill(hue ,255);
        ellipse(width / 4, height / 4, radious * 2, radious * 2);
      }
      if (time >= 80 && time <= 84)
      {
        fill(hue ,255);
        ellipse(width / 4, height - (height / 4), radious * 2, radious * 2);
      }
      if (time >= 80 && time <= 86)
      {
        fill(hue,255);
        ellipse(width - (width /4) , height / 4, radious * 2, radious * 2);
      }
      if (time >= 80 && time <= 88)
      {
        fill(hue ,255);
        ellipse(width - (width / 4) , height - (height / 4), radious * 2, radious * 2);
      }
    }
    if (time >= 30 && time <= 50)
    {
      background(0);
      for (int n = 0; n < NUM; n++)
      {
        if (time >= 30 && time <= 35 || time >= 40 && time <= 45 || n % 2 == 0 || n % 3 == 0)
        {
          float radious = fft.getBand(n) * 5;
          fill(random(0, 255), random(0, 255), random(0, 255));
          stroke(255);
          pushMatrix();
          translate(x[n], y[n], z[n]);
          rotateX(radious);
          rotateY(radious);
          rotateZ(radious);
          sphere(radious);
          popMatrix();
          z[n]+= radious;
          rot[n] += rSpeed[n];
          if (z[n]>1000) 
            z[n] -= 5000;
        }
        else
        {
          float radious = fft.getBand(n) * 5;
          noFill();
          stroke(255);
          pushMatrix();
          translate(x[n], y[n], z[n]);
          rotateX(radious);
          rotateY(radious);
          rotateZ(radious);
          sphere(radious);
          popMatrix();
          z[n]+= radious;
          rot[n] += rSpeed[n];
          if (z[n]>1000) 
            z[n] -= 5000;
        }
      }
    }
    if (time >= 50 && time <= 70)
    {
      for (int m = 0; m < circleX.length; m++)
      {
        float hue = map(m, 0, fft.specSize(), 0, width);
        fill(hue, random(50, 200), 200, 100);
        float radious = fft.getBand(n) * 5;
        stroke(random(100, 200), random(50, 200), 200, 100);
        circles(m, radious, 0, 0);      
        if (time >= 55 && time <= 70)
        {
          noFill();
          circles(m, radious, 0, 0);
          connect(m, 100);
          if (time >= 60 && time <= 70)
          {
            circles(m, radious, width / 4, width / 4);
            connect(m, 100);
            if (time >= 65 && time <= 70)
            {
              circles(m, radious, width / 4, width / 4);
              connect(m, 200);
            }
          }             
        }
      }
    }
    if (time >= 70 && time <= 80)
    {
      float radious = fft.getBand(n) * 5;
      background(0);
      ambientLight(63, 31, 31);
      directionalLight(255, 255, 255, -1, 0, 0);
      pointLight(63, 127, 255, random(0, width / 100), random(0, height / 100), 200);
      spotLight(100, 100, 100, random(0, width / 100), random(0, height / 100), 200, 0, 0, -1, PI, 2);
      translate(width / 2, height / 2, -20);
      rotateX(random(0, width) / 200.0);
      rotateY(random(0, height) / 100.0);
      for (int i = 0; i < NUM; i++) 
      {
        pushMatrix();
        stroke(random(0, 255), random(0, 255), random(0, 255));
        fill(random(0, 255), random(0, 255), random(0, 255));
        rotateY(radious + offset * i);
        rotateX(radious / 2 + offset * i);
        rotateZ(radious / 3 + offset * i);
        box((width / 4) + radious);
        popMatrix();      
      }
    }
  }
  if (time >= 100)
    exit();
}

void connect(int i, int distance){
    stroke(c[i]);
    for (int j = 0; j < n; j++) 
    {
        if (i != j && i < j)
        {
            if (dist(circleX[i], circleY[i], circleX[j], circleY[j]) <= distance)
                line(circleX[i], circleY[i], circleX[j], circleY[j]);
        }
    }
}

void rects(){
  background(0);
  for (int j = 0; j <NUM; j++)
  {
    float radious = fft.getBand(j) * 5;
    noFill();
    stroke(random(0, 255), random(0, 255), random(0, 255));
    pushMatrix();
    translate(x[j], y[j], z[j]);
    rotateX(radious);
    rotateY(radious);
    rotateZ(radious);
    box(radious * 2);
    popMatrix();
    z[j]+=20;
    rot[j] += rSpeed[j];
    if (z[j]>1000) 
      z[j] -= 5000;
  }
}

void circles(int i, float radious, int n, int m) 
{
    colorMode(HSB, 360, 100, 100, 255);
    if (circleX[i] >= width - n|| circleX[i] <= m)
        circleVX[i] = -circleVX[i];
    if (circleY[i] >= height - n|| circleY[i] <= m)
        circleVY[i] = -circleVY[i];
    circleX[i] += circleVX[i];
    circleY[i] += circleVY[i];
    fill(random(0, 255));
    stroke(255);
    ellipse(circleX[i], circleY[i], radious * 20, radious * 20);
}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
