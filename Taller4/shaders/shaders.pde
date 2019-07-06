PGraphics pg;
PImage img;
PShape texImg;
int option=0;
Button blur_bttn, sharpen_bttn, edge_bttn, edge2_bttn;

PShader texShader;

void setup() {
  size(600,400, P2D);
  pg = createGraphics(600,400, P2D);
  img = loadImage("paisaje.jpg");
  texImg = createShape(img);
  texShader = loadShader("original.glsl");
  
  //Buttons for navbar
  blur_bttn = new Button("Conv blur", 40, 25, 100, 30); 
  sharpen_bttn = new Button("Conv sharpen", 180, 25, 100, 30);  
  edge_bttn = new Button("Conv edge", 320, 25, 100, 30); 
  edge2_bttn = new Button("Conv edge2", 460, 25, 100, 30); 
}

void draw() {
  background(0);
  pg.shader(texShader);
  pg.shape(texImg);
  
  switch(option){
    case 1:
      //Apply blur convolution kernel 
      texShader = loadShader("blurKernel.glsl");
      break;
    case 2:
      //Apply sharpen convolution kernel
      texShader = loadShader("sharpenKernel.glsl");
      break;
    case 3:
      //Apply edge convolution kernel
      texShader = loadShader("edgeKernel.glsl");
      break;
    default:
      //original
      texShader = loadShader("original.glsl");
      break;
  }
  
  image(pg, 0, 0);
  navbar();
}

PShape createShape(PImage tex) {
  textureMode(NORMAL);
  PShape shape = createShape();
  shape.beginShape();
  //shape.noStroke();
  textureMode(NORMAL);
  shape.texture(tex);
  shape.vertex(0, 0, 0, 0);
  shape.vertex(width, 0, 1, 0);
  shape.vertex(width, height, 1, 1);
  shape.vertex(0, height, 0, 1);
  shape.endShape();
  return shape;
}

void navbar(){
  blur_bttn.Draw(); 
  sharpen_bttn.Draw(); 
  edge_bttn.Draw(); 
  edge2_bttn.Draw();   
}

void mouseClicked() {
  background(200);
  if(blur_bttn.MouseIsOver()) {
    option = 1;
  }else if(sharpen_bttn.MouseIsOver()) {
    option = 2;
  }else if(edge_bttn.MouseIsOver()) {
    option = 3;
  }else if(edge2_bttn.MouseIsOver()) {
    option = 4;
  }
}

void keyPressed() {
  if (key == '1') {  //Blur
     texShader = loadShader("blurKernel.glsl");
  }else if(key == '2'){ //Sharpen
    texShader = loadShader("sharpenKernel.glsl");
  }else if(key == '3'){ //Edge detection
    texShader = loadShader("edgeKernel.glsl");
  }else{ //original
    texShader = loadShader("original.glsl");
  }
}
