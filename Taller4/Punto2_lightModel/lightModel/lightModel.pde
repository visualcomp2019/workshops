import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

Scene scene;
PShape sphere1, sphere2, texImg;
PShader texlightShader;
Node l1, l2, img1_n;
color cl1, cl2;
Vector posl1, posl2;
PImage img;
PGraphics pg1, pg2;
int option=4;

Button blur_bttn, sharpen_bttn, edge_bttn, identity_bttn, frameRate_bttn;
final int pg_x=600, pg_y=400;

// Convolution matrices
float k = 1.0/9;
float [] identity_vec = {0,0,0,0,1,0,0,0,0};
float [] blur_vec = {k,k,k,k,k,k,k,k,k};
float [] edge_vec = {-1,-1,-1,-1,8,-1,-1,-1,-1};
float [] sharpen_vec = {-1,-1,-1,-1,9,-1,-1,-1,-1};

void setup(){
  size(1200, 600, P3D);
  scene = new Scene(this);
  
  scene.setRadius(1000);
  scene.fit(1);
  img = loadImage("paisaje.jpg");
  texImg = createShapeT(img, 600, 400);
  cl1 = color(255,0,0);
  cl2 = color(0,255,0);
  sphere1 = createShape(SPHERE, 50);
  sphere1.setFill(cl1);
  sphere2 = createShape(SPHERE, 50);
  sphere2.setFill(cl2);
  l1 = new Node(scene, sphere1);
  l2 = new Node(scene, sphere2);
  l1.setPosition(new Vector(610,30,300));
  l2.setPosition(new Vector(1050,30,300));
  
  
  
  pg1 = createGraphics(600,400,P3D);
  pg2 = createGraphics(600,400,P3D);
  
  pg1.beginDraw();
  pg1.shape(texImg);
  pg1.endDraw();
  
  //Para seleccionar y mover el objeto
  
  l1.setPickingThreshold(0);
  //scene.randomize(l1);
  l2.setPickingThreshold(0);
  
  
  
  texlightShader = loadShader("texlightfrag.glsl", "texlightvert.glsl");
  //texlightShader = loadShader("convfrag.glsl");
  
  //Buttons for navbar
  blur_bttn = new Button("Conv blur", 640, 0, 100, 30); 
  sharpen_bttn = new Button("Conv sharpen", 780, 0, 100, 30);  
  edge_bttn = new Button("Conv edge", 920, 0, 100, 30); 
  identity_bttn = new Button("Conv identity", 1060, 0, 100, 30);
  frameRate_bttn = new Button("", 860, 430, 100, 30);
}

void draw() {
  background(0);
  scene.drawAxes();
  scene.render();
  
  switch(option){
    case 1:
      //Apply blur convolution kernel
      texlightShader.set("kernel", blur_vec);
      blur_bttn.on = true;
      sharpen_bttn.on = edge_bttn.on = identity_bttn.on = false; 
      break;
    case 2:
      //Apply sharpen convolution kernel
      texlightShader.set("kernel", sharpen_vec);
      sharpen_bttn.on = true;
      blur_bttn.on = edge_bttn.on = identity_bttn.on = false; 
      break;
    case 3:
      //Apply edge convolution kernel
      texlightShader.set("kernel", edge_vec);
      edge_bttn.on = true;
      sharpen_bttn.on = blur_bttn.on = identity_bttn.on = false; 
      break;
    default:
      //original
      texlightShader.set("kernel", identity_vec);
      identity_bttn.on = true;
      sharpen_bttn.on = edge_bttn.on = blur_bttn.on = false; 
      break;
  }
  
  posl1 = scene.eye().location(l1.position());
  posl2 = scene.eye().location(l2.position());
  //println(posl1);
  Scene.setUniform(texlightShader, "posl1", posl1);
  Scene.setUniform(texlightShader, "posl2", posl2);
  texlightShader.set("colorl1", red(cl1),green(cl1), blue(cl1));
  texlightShader.set("colorl2", red(cl2),green(cl2), blue(cl2));
  
  
  pg2.beginDraw();
  pg2.shader(texlightShader);
  pg2.shape(texImg);
  pg2.ambientLight(0, 0, 255);
  pg2.endDraw();
  
  image(pg1,0,30);
  image(pg2,610,30);
  navbar();
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

void navbar(){
  blur_bttn.Draw(); 
  sharpen_bttn.Draw(); 
  edge_bttn.Draw(); 
  identity_bttn.Draw();   
}

void mouseClicked() {
  if(blur_bttn.MouseIsOver()) {
    option = 1;
  }else if(sharpen_bttn.MouseIsOver()) {
    option = 2;
  }else if(edge_bttn.MouseIsOver()) {
    option = 3;
  }else if(identity_bttn.MouseIsOver()) {
    option = 4;
  }
}

void keyPressed(){
  if(key=='o'){
    option++;
    if(option>4) option=1;    
  }
}

void mouseMoved() {
  scene.cast();
}

void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate(scene.mouseDX(), scene.mouseDY());
  else
    scene.scale(scene.mouseDX());
}


void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}
