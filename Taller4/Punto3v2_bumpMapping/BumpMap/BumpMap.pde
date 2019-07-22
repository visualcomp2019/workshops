PGraphics drawGraphics, pg1, pg2, normalMapPGraphics, bumpPGraphics;
PImage img, grayimg, normalMap;
PShape texImg;
PShader normalShader, bumpShader;
int option=0;
final int pg_x=600, pg_y=400;

void setup() {
  
  size(1230,460, P3D);
  pg1 = createGraphics(pg_x,pg_y, P3D);
  pg2 = createGraphics(pg_x,pg_y, P3D);
  img = loadImage("paisaje.jpg");
  // img = loadImage("bricks.gif");  
  grayimg = grayscale(img);
  texImg = createShapeT(img, pg_x,pg_y);

  // texShader.set("normalMap", normalMap);

  pointLight(255, 255, 255, width/2, height, 200);

  background(0);

  pg1.beginDraw();
  pg1.shape(texImg);
  pg1.endDraw();
  
  bumpShader = loadShader("frag.glsl", "vert.glsl");
  // bumpShader = loadShader("pixelate.glsl");
  bumpPGraphics = createGraphics(pg_x, pg_y, P3D);
  bumpPGraphics.shader(bumpShader);
  
  normalShader = loadShader("testfrag.glsl");
  normalMapPGraphics = createGraphics(pg_x, pg_y, P3D);
  normalMapPGraphics.shader(normalShader);
  
}

void draw() {
   
  normalMapPGraphics.beginDraw();
  normalMapPGraphics.shape(createShapeT(grayimg,pg_x, pg_y));
  normalMapPGraphics.endDraw();
  pg2 = normalMapPGraphics;
  
  normalMapPGraphics.rotate(PI);
  
  bumpPGraphics.beginDraw();
  bumpPGraphics.shape(texImg);
  
  bumpShader.set("normalMap", normalMapPGraphics); 
  // bumpPGraphics.image(pg2,0,0);
  bumpPGraphics.endDraw();
  pg2 = bumpPGraphics;
  
   /*
  
  //texShader.set("kernel", bump_map);
  pg2.beginDraw();
  pg2.shader(texShader);
  pg2.shape(createShapeT(normalMap, pg_x, pg_y));
  pg2.endDraw();
  */
  image(pg1,10,30);
  image(pg2,620,30);
  
}

PImage grayscale(PImage img) {  
  PImage gray = createImage(img.width, img.height, RGB);
  for(int i=0; i<img.width; i++){
    for(int j=0; j<img.height; j++){
      color c = img.get(i,j);
      c = color(Math.round((red(c) + green(c) + blue(c))/3));
      gray.set(i,j,c);      
    }
  }
  return gray;
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

PImage grayscaleToNormalMap(PImage gray){
  PImage normalMapImg = createImage(img.width, img.height, RGB);
  for(int i=0; i<gray.width; i++){
    for(int j=0; j<gray.height; j++){
      color o = img.get(i,j);
      color g = color(Math.round((red(o) + green(o) + blue(o))/3));
      normalMapImg.set(i,j,g);
    }
  }
  
  return normalMapImg;
}

void keyPressed(){
  if(key=='p'){
    normalMapPGraphics.save("normalMtree.png");
  }
  
}
