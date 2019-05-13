PGraphics pg;
PImage texture; 
PShape globe;
color green_c = #7FB538; // Green
color blue_c = #173caa; // Blue
color black_c = #000103; // Black
PGraphics texture1, texture2;
int concentration;

void setup() {

  size(900, 600, P3D);
  noStroke();
  directionalLight(242,241,232, 0, 0, -1); 
  spotLight(250, 229, 96, 0, 0, 400, 0, 0, -1, PI/16, 1);
  concentration = 1;  // Try 1 -> 10000
  pg = createGraphics(900, 600, P3D);
  texture = loadImage("data/texture.jpg");
  globe = createShape(SPHERE, 250);
  //rolling_texture();
  texture1 = makeTexture(color(255), black_c, blue_c, 40, 45);
  texture2 = makeTexture(black_c, color(255), blue_c, 20, 22);
  apply_texture();
}

void apply_texture() {
  
  globe.setTexture(texture2);   
  pg.beginDraw();
  pg.image(texture1, 0,0);
  pg.translate(width/2, height/2); 
  pg.shape(globe); 
  pg.endDraw();
  translate(0,0,0);
  image(pg,0,0);
}

PGraphics makeTexture(color c1, color c2, color c3, int diameter, int separation){
  PGraphics texture = createGraphics(900, 600);
  texture.beginDraw();
  texture.background(green_c);
  texture.noStroke();
  boolean b = false;
  int offset = int(diameter*0.15);
  for(int i=0; i < texture.width-2*offset; i+=separation){
    for(int j=0; j < texture.height; j+=separation){
      if(b){
        texture.fill(c1);
        texture.circle(i,j,diameter);
        texture.fill(c2);
        texture.circle(i+2*offset,j,diameter);
        texture.fill(c3);
        texture.circle(i+offset,j,diameter);
      }
      b=!b;
    }
    b = !b;
  }
  
  texture.endDraw();
  
  return texture;
}
