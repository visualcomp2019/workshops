import processing.video.*;

Movie video;
PGraphics pg1, pg2;

PShape window;
PShape texVid;
PShader convShader;
int option=0;
Button blur_bttn, sharpen_bttn, edge_bttn, edge2_bttn;

// Convolution matrices
float k = 1.0/9;
float [] original_vec = {0,0,0,0,1,0,0,0,0};
float [] blur_vec = {k,k,k,k,k,k,k,k,k};
float [] edge_vec = {-1,-1,-1,-1,8,-1,-1,-1,-1};
float [] sharpen_vec = {-1,-1,-1,-1,9,-1,-1,-1,-1};

void setup() {
  size(1630, 550, P2D);
  pg1 = createGraphics(800,540, P2D);
  pg2 = createGraphics(800,540, P2D);
  
  video = new Movie(this, "navidad.mov");
  video.play();
  video.loop();
  texVid = createWindow(800, 540, video, 100);
  convShader = loadShader("convfrag.glsl");
  background(0);
  //Buttons for navbar
  blur_bttn = new Button("Conv blur", 640, 0, 100, 30); 
  sharpen_bttn = new Button("Conv sharpen", 780, 0, 100, 30);  
  edge_bttn = new Button("Conv edge", 920, 0, 100, 30); 
  edge2_bttn = new Button("Conv edge2", 1060, 0, 100, 30);

}

void draw() {
  
  background(0);
  switch(option){
    case 1:
      //Apply blur convolution kernel 
      convShader.set("kernel", blur_vec);
      break;
    case 2:
      //Apply sharpen convolution kernel
      convShader.set("kernel", sharpen_vec);
      break;
    case 3:
      //Apply edge convolution kernel
      convShader.set("kernel", edge_vec);
      break;
    default:
      //original
      convShader.set("kernel", original_vec);
      break;
  }
  navbar();
  translate(0, height/3);
  pg1.beginDraw();
  video.read();
  pg1.shape(texVid);
  pg1.endDraw();
  pg2.beginDraw();
  video.read();
  pg2.shader(convShader);
  pg2.shape(texVid);
  pg2.endDraw();
  image(pg1, 10, 0);
  image(pg2, 820, 0);
  
  //convShader.set("maskSelected", maskSelected);
  //convShader.set("showMask", showMask);
  /*translate(50, height/2);
  if (video.available()) {
    video.read();
    window  = createWindow(1100, 500, video, 100);
    shape(window);
  }
  */
  
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
  if(key == 'p'){
    //output.flush();
    //output.close();    
    exit();
  }
}

PShape createWindow(int imageW, int imageH, PImage texture, int detail) {
  textureMode(NORMAL); // Normalize the coordinates in texture [0,1]
  PShape wd = createShape();
  wd.beginShape(QUAD_STRIP); // First 4 coordinates generate an rectangle the next two too.
  wd.noStroke();
  wd.texture(texture);
  for (int i = 0; i <= detail; i++) {
    float u = float(i) / detail;
    float x = (imageW / detail) * i;
    wd.normal(1, 0, 1); // Out side in plane z-x
    wd.vertex(x, -imageH/2, 1, u, 0);
    wd.vertex(x, imageH/2, 1, u, 1);
  }
  wd.endShape();  
  return wd;
}
