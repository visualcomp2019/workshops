PGraphics pg_stars;
int loop=0;
color blue_c = color(107, 195, 181); //Blue color
color pink_c = color(220, 148, 152); //Pink color
color lavanda_c = color(173,169,180);  //Lavanda color
int offset = 100;

void setup() { 
  size(600, 600);    
  pg_stars = createGraphics(410, 200);  
}

void draw() {      
  clear();
  noStroke();
  background(255);
  
  pg_stars.beginDraw();  
  pg_stars.clear();
  starsLoop();  
  pg_stars.strokeWeight(3);
  pg_stars.point(pg_stars.width*0.5,pg_stars.height*0.5);
  pg_stars.strokeWeight(1);
  pg_stars.endDraw();
  
  image(pg_stars,width/2-pg_stars.width/2, height/2 - pg_stars.height/2);  
}

void starsLoop(){  
  PShape star;
  star = star(0, 0, 30, 80, 4);

  switch(loop) {
    case 0:
      pg_stars.shape(star, pg_stars.width/2 - offset, pg_stars.height*0.5);
      star.rotate(PI/4.0);
      pg_stars.shape(star, pg_stars.width/2 + offset,pg_stars.height*0.5);
      loop++;
      delay(900);
      break;
    case 1:
      star.rotate(PI/4.0);
      pg_stars.shape(star, pg_stars.width/2 - offset, pg_stars.height*0.5);
      star.rotate(PI/4.0);
      pg_stars.shape(star, pg_stars.width/2 + offset,pg_stars.height*0.5);
      loop++;
      delay(550);
      break;
    case 2:
      pg_stars.shape(makeColoredStar(), pg_stars.width/2 - offset, pg_stars.height*0.5);
      pg_stars.shape(makeColoredStar(), pg_stars.width/2 + offset,pg_stars.height*0.5);
      loop=0;
      delay(550);
      break;
  }
}

PShape makeColoredStar() {
  PShape ps = createShape(GROUP);
  PShape star1, star2, square1, square2;
  star1 = star(0, 0, 30, 80, 4);
  star2 = star(0, 0, 30, 80, 4);
  square1 = polygon(0, 0, 41, 4);
  square2 = polygon(0, 0, 41, 4);

  star1.setFill(blue_c);
  star1.setStrokeWeight(0);
  ps.addChild(star1);

  star2.setFill(pink_c);
  star2.setStrokeWeight(0);
  star2.rotate(PI/4.0);
  ps.addChild(star2);
  
  square1.setFill(lavanda_c);
  square1.setStrokeWeight(0);
  square1.rotate(PI/2.63); 
  ps.addChild(square1);  
  
  square2.setFill(lavanda_c);
  square2.setStrokeWeight(0);
  square2.rotate(PI/0.615); 
  ps.addChild(square2);
  
  return ps;
}

PShape polygon(float x, float y, float radius, int npoints) {
  PShape ps = createShape();
  float angle = TWO_PI / npoints;
  ps.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    ps.vertex(sx, sy);
  }
  ps.endShape(CLOSE);
  return ps;
}

PShape star(float x, float y, float radius1, float radius2, int npoints) {
  PShape ps = createShape();
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  ps.beginShape();
  ps.stroke(0);
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    ps.vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    ps.vertex(sx, sy);
  }
  ps.endShape(CLOSE);
  return ps;
}
