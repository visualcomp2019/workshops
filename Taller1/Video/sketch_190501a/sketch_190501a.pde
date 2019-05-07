import processing.video.*; //<>//

PGraphics canvas_initial;
PGraphics canvas_trans;

//PImage image;
Movie video;

int maskSelected = 0;
int c_trans_x = 825;


float[][] edgeKernel = {{-1, -1, -1}, 
                        {-1, 8, -1}, 
                        {-1, -1, -1}};
                        
float[][] sharpenKernel = { { -1, -1, -1 }, 
                            { -1, 9, -1 }, 
                            { -1, -1, -1 } };

float k = 1.0/9;
float[][] blurKernel = { { k, k, k, k, k }, 
                         { k, k, k, k, k }, 
                         { k, k, k, k, k },
                         { k, k, k, k, k },
                         { k, k, k, k, k }};


boolean showVideo = true;
boolean showGray = false;
boolean showMask = false;

int initialFrameRate = 60;

color basicTextColor = color(0, 0, 0);


//Define position and size for all buttons
int buttonSizeX = 200, buttonSizeY = 50;
int buttonSeparationX = 375, buttonSeparationY = 20;

int buttonImageAndVideoY = 550; //shared

int buttonVideoX = 50;

int buttonConvY = buttonImageAndVideoY+buttonSizeY+buttonSeparationY; //shared
int[] buttonConvX = new int[4];

int buttonGrayY = buttonImageAndVideoY; //shared
int buttonGrayX = buttonVideoX+buttonSizeX+buttonSeparationX;


float[][] getMask() {
  
  switch(maskSelected) {
  case 1: 
    return edgeKernel;
  case 2: 
    return sharpenKernel;
  case 3: 
    return blurKernel;

  default: 
    return edgeKernel;
  }
}

void chargeMedia(boolean media, PGraphics canvas) {
  canvas.beginDraw();
  if (media) {
    video = new Movie(this, "0321_presentschristmasclose_720p.mov");
    canvas.image(video, 0, 0, video.height, video.width);
    video.play();
    video.loop();
  } 
  canvas.endDraw();
  image(canvas, 50, 50);
}

void drawButtons() {
  pushStyle();
  textAlign(CENTER, CENTER);
  stroke(255);
  color buttonBaseColor = basicTextColor;
  color buttonDisabledColor = color(56, 56, 80);
  color buttonTextColor = color(255);
  int roundedCorner = 10;


  
  
  //Buttons Convolutions
  for (int i = 1; i < buttonConvX.length; i++) {
    if (i==maskSelected) {
      fill(buttonDisabledColor);
    } else {
      fill(buttonBaseColor);
    }
    rect(buttonConvX[i], buttonConvY, buttonSizeX, buttonSizeY, roundedCorner);
    fill(buttonTextColor);

    text("Conv edge", buttonConvX[1], buttonConvY, buttonSizeX, buttonSizeY);

    text("Conv sharpen", buttonConvX[2], buttonConvY, buttonSizeX, buttonSizeY);

    text("Conv blur", buttonConvX[3], buttonConvY, buttonSizeX, buttonSizeY);

  }

  //button gray
  if (!showGray) {
    fill(buttonBaseColor);
  } else {
    fill(buttonDisabledColor);
  }
  rect(buttonGrayX, buttonGrayY, buttonSizeX, buttonSizeY, roundedCorner);
  fill(buttonTextColor);
  text("Gray", buttonGrayX, buttonGrayY, buttonSizeX, buttonSizeY);

  popStyle();
}

void setup() {

  buttonConvX[1] = buttonVideoX;
  buttonConvX[2] = buttonConvX[1]+buttonSizeX+buttonSeparationX ;
  buttonConvX[3] = buttonConvX[2]+buttonSizeX+buttonSeparationX ;

  textSize(18);
  fill(basicTextColor);
  size(1600, 800);
  frameRate(initialFrameRate);
  background(255);
  
  text("Original:", 50, 35);
  canvas_initial = createGraphics(960, 540);
  text("Modificado:", 800, 35);
  canvas_trans = createGraphics(960, 540);
  chargeMedia(showVideo, canvas_initial);
  drawButtons();
}

void grayscale(PGraphics canvas, PImage img) { 
  canvas.beginDraw();
  
  PImage new_img;
  
  new_img = createImage(img.width, img.height, RGB);
  for(int i=0; i<img.width; i++){
    for(int j=0; j<img.height; j++){
      color c = img.get(i,j);
      c = color(Math.round((red(c) + green(c) + blue(c))/3));
      new_img.set(i,j,c);      
    }
  }
  new_img.updatePixels();
  canvas.image(new_img, 0, 0, 750, 450);
  canvas.endDraw();
  image(canvas, c_trans_x, 50);
}

void convolution(PGraphics canvas, PImage image, float[][] kernel) {
  canvas.beginDraw();
  PImage image_with_mask;
  
  image_with_mask = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.height; i++) {
    for (int j = 0; j < image.width; j++) {
      
      image_with_mask.pixels[i * image.width + j] = applyKernel(i,j,kernel,image);
    }
  }
  image_with_mask.updatePixels();
  canvas.image(image_with_mask, 0, 0, 750, 450);
  canvas.endDraw();
  image(canvas, c_trans_x, 50);
}

color applyKernel(int x, int y, float[][] kernel, PImage image){
  
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = kernel.length / 2;
  for (int n = 0; n < kernel.length; n++) {
    for (int m = 0; m < kernel[0].length; m++) {
      int xloc = x + n - offset;
      int yloc = y + m - offset;
      if ( xloc < image.height && xloc >= 0 && yloc < image.width && yloc >= 0) {  
        int index = xloc * image.width + yloc;
        rtotal += red(image.pixels[index]) * kernel[n][m];
        gtotal += green(image.pixels[index]) * kernel[n][m];
        btotal += blue(image.pixels[index]) * kernel[n][m];
      }
    }
  }
  return color(rtotal,gtotal,btotal);
}


void draw() {
  pushStyle();
  stroke(255);
  rectMode(CORNER);
  fill(255);
  rect(50, 500, 900, 40);
  popStyle();
  fill(basicTextColor);
  
  if (video.available()) {
    pushStyle();
    stroke(255);
    rectMode(CORNER);
    fill(255);
    rect(50, 500, 900, 40);
    popStyle();
    fill(basicTextColor);
    String frameRateText = "Eficiencia Computacional "+ frameRate/initialFrameRate*100 + "%";
    textSize(18);
    text(frameRateText, 50, 520);
    video.read();
    if (showGray) {
      grayscale(canvas_trans, video);
    }
    if (showMask) {
      convolution(canvas_trans, video, getMask());
    }
    canvas_initial.beginDraw();
    canvas_initial.image(video, 0, 0, 750, 450);
    canvas_initial.endDraw();
    image(canvas_initial, 50, 50);
    
  }
}

void handleButtonPress(int x, int y) {

  if (x > buttonVideoX && x < buttonVideoX + buttonSizeX && y > buttonImageAndVideoY && y < buttonImageAndVideoY + buttonSizeY) {
    handleKeyPress('m');
    return;
  }
  if (x > buttonGrayX && x < buttonGrayX + buttonSizeX && y > buttonGrayY && y < buttonGrayY + buttonSizeY) {
    handleKeyPress('g');
    return;
  }  

  for (int i = 1; i < buttonConvX.length; i++) {
    if (x > buttonConvX[i] && x < buttonConvX[i] + buttonSizeX && y > buttonConvY && y < buttonConvY + buttonSizeY) {
      handleKeyPress(str(i).charAt(0));
      return;
    }
  }
}


void mousePressed() {

  if (mouseX>buttonVideoX && mouseY > buttonImageAndVideoY) {
    handleButtonPress(mouseX, mouseY);
  }
}


void applyConvolution() {
  showMask = true;
  showGray = false;

  if (showVideo) convolution(canvas_trans, video, getMask());
  //Video will be process in movieEvent
}

void keyPressed() {
  handleKeyPress(key);
}

void handleKeyPress(char pressed) {
  if (pressed == 'm') {
    showVideo = false;
    showGray = false;

    maskSelected = 0;
    chargeMedia(showVideo, canvas_initial);
  }
  if (pressed == 'i') {
    showVideo = true;
    showGray = false;
    showMask = false;

    maskSelected = 0;
    chargeMedia(showVideo, canvas_initial);
  }
  if (pressed == 'g') {
    showGray = true;
    showMask = false;

    maskSelected = 0;
    if (showVideo) grayscale(canvas_trans, video);
    //Video will be process in movieEvent
  }
  if (pressed == 'h' && showVideo) {
    showVideo = true;
    showGray = false;
    showMask = false;

    maskSelected = 0;

    //Video will be process in movieEvent
  }
  if (pressed == '1') {
    maskSelected = 1;
    applyConvolution();
  }
  if (pressed == '2') {
    maskSelected = 2;
    applyConvolution();
  }
  if (pressed == '3') {
    maskSelected = 3;
    applyConvolution();
  }

  drawButtons();
}
