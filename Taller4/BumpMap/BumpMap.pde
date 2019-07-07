PGraphics pg1, pg2;
PImage img;
PShape texImg;
PShader texShader;
int option=0;
final int pg_x=600, pg_y=400;


// Convolution matrices

float [] bump_map = {-1, -1,  0,
  -1,  0,  1,
   0,  1,  1};



void setup() {
  
  size(1230,460, P2D);
  pg1 = createGraphics(pg_x,pg_y, P2D);
  pg2 = createGraphics(pg_x,pg_y, P2D);
  img = loadImage("paisaje.jpg");
  texImg = createShapeT(img, pg_x,pg_y);
  texShader = loadShader("convfrag.glsl");
  
  
  background(0);

  pg1.beginDraw();
  pg1.shape(texImg);
  pg1.endDraw();
}

void draw() {
  
  texShader.set("kernel", bump_map);
  pg2.beginDraw();
  pg2.shader(texShader);
  pg2.shape(texImg);
  pg2.endDraw();
  
  image(pg1,10,30);
  image(pg2,620,30);
  
}

PShape createShapeT(PImage tex, int x, int y) {
  textureMode(NORMAL);
  PShape shape = createShape();
  shape.beginShape();
  shape.noStroke();  
  shape.texture(tex);
  shape.vertex(0, 0, 0, 0);
  shape.vertex(x, 0, 1, 0);
  shape.vertex(x, y, 1, 1);
  shape.vertex(0, y, 0, 1);
  
  shape.endShape();
  return shape;
}
