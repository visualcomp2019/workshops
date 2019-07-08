PGraphics pg1, pg2;
PImage img;
PShape texImg;
PShader texShader;
int option=0;
final int pg_x=600, pg_y=400;

Button blur_bttn, sharpen_bttn, edge_bttn, identity_bttn, frameRate_bttn;
PrintWriter output;

// Convolution matrices
float k = 1.0/9;
float [] identity_vec = {0,0,0,0,1,0,0,0,0};
float [] blur_vec = {k,k,k,k,k,k,k,k,k};
float [] edge_vec = {-1,-1,-1,-1,8,-1,-1,-1,-1};
float [] sharpen_vec = {-1,-1,-1,-1,9,-1,-1,-1,-1};


void setup() {
  
  size(1210,460, P2D);
  pg1 = createGraphics(pg_x,pg_y, P2D);
  pg2 = createGraphics(pg_x,pg_y, P2D);
  img = loadImage("paisaje.jpg");
  texImg = createShapeT(img, pg_x,pg_y);
  texShader = loadShader("convfrag.glsl");
  
  // Create a new file in the sketch directory
  output = createWriter("hardwareImg_fps.txt");

  //Buttons for navbar
  blur_bttn = new Button("Conv blur", 640, 0, 100, 30); 
  sharpen_bttn = new Button("Conv sharpen", 780, 0, 100, 30);  
  edge_bttn = new Button("Conv edge", 920, 0, 100, 30); 
  identity_bttn = new Button("Conv identity", 1060, 0, 100, 30);
  frameRate_bttn = new Button("", 860, 430, 100, 30);
  
  background(0);

  pg1.beginDraw();
  pg1.shape(texImg);
  pg1.endDraw();
}

void draw() {
  switch(option){
    case 1:
      //Apply blur convolution kernel
      texShader.set("kernel", blur_vec);      
      break;
    case 2:
      //Apply sharpen convolution kernel
      texShader.set("kernel", sharpen_vec);
      break;
    case 3:
      //Apply edge convolution kernel
      texShader.set("kernel", edge_vec);
      break;
    default:
      //original
      texShader.set("kernel", identity_vec);
      break;
  }
  pg2.beginDraw();
  pg2.shader(texShader);
  pg2.shape(texImg);
  pg2.endDraw();
  
  image(pg1,0,30);
  image(pg2,610,30);
  navbar();
  frameRate_bttn.label = str(frameRate);
  
  frameRate_bttn.Draw(); 
  
  output.println(frameRate);
  
  
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

void keyPressed() {
  if(key == 'p'){
    output.flush();
    output.close();    
    exit();
  }
}
