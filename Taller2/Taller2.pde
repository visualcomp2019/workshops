PGraphics pg;
int illusion;

void setup() {
  illusion = 0;  
  size(600, 600, P3D);
  noStroke(); 
  pg = createGraphics(600, 600, P3D);
  illusion0();
}

void draw() {   
 
}

void keyPressed() {
  if(keyCode == RIGHT) {
    if(illusion == 5){
      illusion = 0;
    }else{
      illusion++;
    }
    illusionSelector();
  }else if(keyCode == LEFT) {
    if(illusion == 0){
      illusion = 5;
    }else{
      illusion--;      
    }
    illusionSelector();
  }
}

void illusionSelector() {
  pg.clear();
  switch(illusion) {
    case 0:
      illusion0();
      break;
   
    case 1:
      illusion1();
      break;
   
    case 2:
      illusion2();    
    
    case 3:
      illusion3();
      
    case 4:
      illusion4();
    
    case 5:
      illusion5();
  
  }  
}

void illusion0() {
  PImage texture; 
  PShape globe;
  texture = loadImage("data/texture.jpg");
  globe = createShape(SPHERE, 200);
  globe.setTexture(texture);
  
  
  pg.beginDraw();
  pg.image(texture, 0,0);
  pg.translate(width/2, height/2); 
  pg.shape(globe); 
  pg.endDraw();
  image(pg,0,0);
}

void illusion1() {
  pg.beginDraw();
  pg.noStroke();
  pg.background(255);
  pg.translate(width/2, height/2);
  pg.fill(107, 195, 181); //Blue color
  star(0, 0, 30, 80, 4, pg);
  rotate(PI/4.0);
  fill(220, 148, 152); //Pink color
  star(0, 0, 30, 80, 4,pg);
  rotate(PI/2.63); 
  fill(173,169,180);  //Intermediate color
  polygon(0, 0, 41, 4, pg);  // Square1
  rotate(PI/4.0);
  polygon(0, 0, 41, 4, pg);  // Square2
  pg.endDraw();
  image(pg,0,0);
}

void illusion2() {

}

void illusion3() {

}

void illusion4() {

}

void illusion5() {

}


void polygon(float x, float y, float radius, int npoints, PGraphics pgr) {
  float angle = TWO_PI / npoints;
  pgr.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pgr.vertex(sx, sy);
  }
  pgr.endShape(CLOSE);
}

void star(float x, float y, float radius1, float radius2, int npoints, PGraphics pgr) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  pgr.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    pgr.vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    pgr.vertex(sx, sy);
  }
  pgr.endShape(CLOSE);
}
