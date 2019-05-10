PGraphics pg;
int illusion;
int loop=0;

void setup() {
  illusion = 0;  
  size(600, 600, P3D);
  noStroke(); 
  pg = createGraphics(600, 600, P3D);
  illusion0();
  
}

void draw() {
  illusionSelector();
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
  }
}

void illusionSelector() {
  clear();
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
  PGraphics pg_stars;
  pg_stars = createGraphics(410, 200);
  starsLoop(pg_stars);
  
  pg.beginDraw();
  pg.background(255);
  pg.image(pg_stars,pg.width/2-pg_stars.width/2,pg.height/2-pg_stars.height/2);
  pg.strokeWeight(3);
  pg.point(pg.width*0.5,pg.height*0.5);
  pg.strokeWeight(1);
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

void starsLoop(PGraphics pg_stars){
  PGraphics pg_star_izq, pg_star_der;
  pg_star_izq = createGraphics(200, 200);
  pg_star_der = createGraphics(200, 200);
  pg_star_izq.beginDraw();
  pg_star_der.beginDraw();
  pg_star_izq.translate(pg_star_izq.width/2, pg_star_izq.height/2);
  pg_star_der.translate(pg_star_der.width/2, pg_star_der.height/2);
  
  switch(loop) {
    case 0:
      star(0, 0, 30, 80, 4, pg_star_izq);
      pg_star_der.rotate(PI/4.0);
      star(0, 0, 30, 80, 4, pg_star_der);
      loop++;
      delay(900);
      break;
    case 1:
      pg_star_izq.rotate(PI/4.0);
      star(0, 0, 30, 80, 4, pg_star_izq);
      star(0, 0, 30, 80, 4, pg_star_der);
      loop++;
      delay(550);
      break;
    case 2:
      makeColoredStar(pg_star_izq);
      makeColoredStar(pg_star_der);
      loop=0;
      delay(550);
      break;
  }
  pg_star_izq.endDraw();
  pg_star_der.endDraw();
  
  pg_stars.beginDraw();
  pg_stars.image(pg_star_izq,pg_stars.width/2 - pg_star_der.width - 5,0);
  pg_stars.image(pg_star_der,pg_stars.width/2 + 5,0);
  pg_stars.endDraw();
}

void makeColoredStar(PGraphics pgr) {
  pgr.beginShape();
  pgr.noStroke();
  pgr.fill(107, 195, 181); //Blue color
  star(0, 0, 30, 80, 4, pgr);
  pgr.rotate(PI/4.0);
  pgr.fill(220, 148, 152); //Pink color
  star(0, 0, 30, 80, 4,pgr);
  pgr.rotate(PI/2.63); 
  pgr.fill(173,169,180);  //Intermediate color
  polygon(0, 0, 41, 4, pgr);  // Square1
  pgr.rotate(PI/4.0);
  polygon(0, 0, 41, 4, pgr);  // Square2
  pgr.endShape();
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
