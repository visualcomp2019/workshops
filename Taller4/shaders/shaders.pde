PImage img;
PShape texImg;
int option=0;

PShader texShader;

void setup() {
  size(600,400, P2D);
  img = loadImage("paisaje.jpg");
  texImg = createShape(img);
  texShader = loadShader("original.glsl");
}

void draw() {
  background(0);
  shader(texShader);
  shape(texImg);
  navbar();
  if(option == 1){
    //Apply blur convolution kernel 
    texShader = loadShader("blurKernel.glsl");
  }else if(option == 2){
    //Apply sharpen convolution kernel
    texShader = loadShader("sharpenKernel.glsl");
  }else if(option == 3){
    //Apply edge convolution kernel
    texShader = loadShader("edgeKernel.glsl");
  }else{
    //original
    texShader = loadShader("original.glsl");
  } 
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
  stroke(255);
  rect(40, 25, 100, 30);
  rect(180, 25, 100, 30);
  rect(320, 25, 100, 30);
  rect(460, 25, 100, 30);
  stroke(0);
  text("Conv blur", 60, 45);
  text("Conv sharpen", 190, 45);
  text("Conv edge", 340, 45);
  text("Conv edge", 480, 45);
  noStroke();
}

void mouseClicked() {
  background(200);
  if(mouseX > 40 && mouseX < 140 && mouseY > 25 && mouseY < 55) {
    option = 1;
  }else if(mouseX > 180 && mouseX < 280 && mouseY > 25 && mouseY < 55) {
    option = 2;
  }else if(mouseX > 320 && mouseX < 420 && mouseY > 25 && mouseY < 55) {
    option = 3;
  }else if(mouseX > 460 && mouseX < 560 && mouseY > 25 && mouseY < 55) {
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
