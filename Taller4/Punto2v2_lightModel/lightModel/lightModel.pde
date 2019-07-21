import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;
import net.java.games.input.*;

// https://github.com/processing/processing/blob/master/core/src/processing/opengl/shaders/TexLightVert.glsl

Scene scene;
PShape sphere, sphere1, sphere2, texImg;
PImage redImg, greenImg;
PShader texlightShader;
Node l1, l2, img1_n, obj;
color cl1, cl2;
Vector posl1, posl2;
PImage img;
PGraphics pg1, pg2;
int option=4;

final int pg_x=600, pg_y=400;

void setup(){
  size(1200, 600, P3D);
  scene = new Scene(this);  
  scene.setRadius(1000);
  scene.fit(1);  
  /*
  obj = new Node(scene, loadShape("rocket.obj"));
  obj.setPickingThreshold(0);
  obj.setPosition(new Vector(0,0,0));
  */
  noStroke();  

  sphere = createShape(SPHERE, 300);
  sphere.setTexture(loadImage("paisaje.jpg"));  
  obj = new Node(scene, sphere);
  obj.setPosition(new Vector(0,0,0));
  obj.setPickingThreshold(0);
  
  cl1 = color(255,0,0);
  sphere1 = createShape(SPHERE, 50);
  sphere1.setTexture(createImg(100,100,cl1));
  l1 = new Node(scene, sphere1);
  l1.setPosition(new Vector(200,0,800));
  l1.setPickingThreshold(0);
   
  cl2 = color(0,255,0);
  sphere2 = createShape(SPHERE, 50);
  sphere2.setTexture(createImg(100,100,cl2));
  l2 = new Node(scene, sphere2);  
  l2.setPosition(new Vector(-200,0,800));  
  l2.setPickingThreshold(0);  
  
  texlightShader = loadShader("texlightfrag.glsl", "texlightvert2.glsl");
  //texlightShader = loadShader("convfrag.glsl");
}

void draw() {
  background(0);
  lights();

  scene.drawAxes();
  scene.render();  
  
  
  posl1 = scene.eye().location(l1.position());
  posl2 = scene.eye().location(l2.position());
  
  Scene.setUniform(texlightShader, "posl1", posl1);
  Scene.setUniform(texlightShader, "posl2", posl2);
  texlightShader.set("colorl1", red(cl1),green(cl1), blue(cl1));
  texlightShader.set("colorl2", red(cl2),green(cl2), blue(cl2));
  
  shader(texlightShader);

}

PImage createImg(int iwidth, int iheight, color c){
  PImage img = createImage(iwidth, iheight, RGB);
  img.loadPixels(); 
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = color(red(c), green(c), blue(c)); 
  }
  img.updatePixels();
  return img;
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


void mouseClicked() {
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
