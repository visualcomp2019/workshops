import processing.video.*;
Movie myMovie;
PGraphics pg1, pg2;
PImage frame, conv;
PShape texFrame;
PShader texShader;
int option=0;
final int pg_x=600, pg_y=400;

Button blur_bttn, sharpen_bttn, edge_bttn, identity_bttn, frameRate_bttn;
PrintWriter output;

// Convolution matrices
float[][] sharpenKernel = { { -1, -1, -1 },
                            { -1,  9, -1 },
                            { -1, -1, -1 } };
float k = 1.0/9;
float[][] blurKernel = { { k, k, k },
                         { k, k, k },
                         { k, k, k } };
//float [][] edgeKernel = {{0, 1, 0},
//                         {1, -4, 1},
//                         {0, 1, 0}};
float [][] edgeKernel = {{-1, -1, -1},
                         {-1, 8, -1},
                         {-1, -1, -1}};
float[][] identityKernel = { { 0, 0, 0 },
                         { 0, 1, 0 },
                         { 0, 0, 0 } };

void setup() {
  size(1210, 460, P2D);
  pg1 = createGraphics(pg_x,pg_y, P2D);
  pg2 = createGraphics(pg_x,pg_y, P2D);
  myMovie = new Movie(this, "navidad.mov");
  myMovie.loop();
  
  // Create a new file in the sketch directory
  output = createWriter("softwareVid_fps.txt");

  //Buttons for navbar
  blur_bttn = new Button("Conv blur", 640, 0, 100, 30); 
  sharpen_bttn = new Button("Conv sharpen", 780, 0, 100, 30);  
  edge_bttn = new Button("Conv edge", 920, 0, 100, 30); 
  identity_bttn = new Button("Conv identity", 1060, 0, 100, 30);
  frameRate_bttn = new Button("", 860, 430, 100, 30);
  
  background(0); 
}

void draw() {
  switch(option){
    case 1:
      //Apply blur convolution kernel
      conv = convolution(blurKernel, frame, 3);     
      break;
    case 2:
      //Apply sharpen convolution kernel
      conv = convolution(sharpenKernel, frame, 3);
      break;
    case 3:
      //Apply edge convolution kernel
      conv = convolution(edgeKernel, frame, 3);
      break;
    default:
      //original
      conv = convolution(identityKernel, frame, 3);
      break;
  }
  
  myMovie.read();
  
  pg1.beginDraw();  
  pg1.shape(createShapeT(frame,600,400));
  pg1.endDraw();
  
  pg2.beginDraw();
  pg2.shape(createShapeT(conv,600,400));
  pg2.endDraw();
  
  navbar();
  image(pg1, 0, 30);
  image(pg2, 610, 30);
  
  frameRate_bttn.label = str(frameRate);  
  frameRate_bttn.Draw();  
  output.println(frameRate);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  frame = m;  
  texFrame = createShapeT(m, pg_x,pg_y);
  
  
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

color applyKernel(int x, int y, float[][] kernel, int kernelsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = kernelsize / 2;
  // Loop through convolution kernel
  for (int i = 0; i < kernelsize; i++){
    for (int j= 0; j < kernelsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we have not walked off the edge of the pixel array
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(img.pixels[loc]) * kernel[i][j]);
      gtotal += (green(img.pixels[loc]) * kernel[i][j]);
      btotal += (blue(img.pixels[loc]) * kernel[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  // Return the resulting color
  return color(rtotal,gtotal,btotal);
}

PImage convolution(float[][] kernel, PImage source, int kernelSize){
  // We are going to look at both image's pixels
  PImage dest = source.copy();
  source.loadPixels();
  dest.loadPixels();
  
  // Begin our loop for every pixel
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      color c = applyKernel(x,y,kernel, kernelSize,source);
      int loc = x + y*source.width;
      dest.pixels[loc] = c;
    }
  }
  
  // We changed the pixels in destination
  dest.updatePixels();
  return dest;
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
