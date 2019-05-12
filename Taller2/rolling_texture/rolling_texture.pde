PGraphics pg;
  PImage texture; 
  PShape globe;

void setup() {

  size(600, 600, P3D);
  noStroke(); 
  pg = createGraphics(600, 600, P3D);
  texture = loadImage("data/texture.jpg");
  globe = createShape(SPHERE, 200);
  rolling_texture();
}

void draw() {

}

void rolling_texture() {
  
  globe.setTexture(texture);   
  pg.beginDraw();
  pg.image(texture, 0,0);
  pg.translate(width/2, height/2); 
  pg.shape(globe); 
  pg.endDraw();
  image(pg,0,0);
}
