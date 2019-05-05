import processing.video.*; //<>//

PGraphics canvas_initial;
PGraphics canvas_trans;

PImage image;
Movie video;

int maskSelected = 0;
float[][] edgeDetection = {{0, 1, 0}, {1, -4, 1}, {0,1,0}};
float[][] edgeDetection2 = {{-1, -1, -1},
                           {-1, 8, -1},
                           {-1, -1, -1}};
float[][] sharpen = { { -1, -1, -1 },
                      { -1,  9, -1 },
                      { -1, -1, -1 } };
                      
float k = 1.0/9;
float[][] boxBlur = { { k, k, k },
                      { k, k, k },
                      { k, k, k } };
float[][] gaussianBlur = {{0.0625, 0.125, 0.0625}, {0.125, 0.25, 0.125}, {0.0625, 0.125, 0.0625}};
float[][] gaussianBlur5 = {
  {0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625}, 
  {0.015625, 0.0625, 0.09375, 0.0625, 0.015625}, 
  {0.0234375, 0.09375, 0.125, 0.09375, 0.0234375}, 
  {0.015625, 0.0625, 0.09375, 0.0625, 0.015625},
  {0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625}
};

boolean showImage = true;
boolean showGray = false;
boolean showMask = false;

int[] heightsOfBars = new int[256];
int starting = 550;
int ending = 1000;
int initialFrameRate = 60;

color basicTextColor = color(0,0,0);


//Define position and size for all buttons
int buttonSizeX = 200, buttonSizeY = 50;
int buttonSeparationX = 20, buttonSeparationY = 20;

int buttonImageAndVideoY = 550; //shared
int buttonImageX = 50;
int buttonVideoX = 50;

int buttonConvY = buttonImageAndVideoY+buttonSizeY+buttonSeparationY; //shared
int[] buttonConvX = new int[7];

int buttonGrayAndHistoY = buttonImageAndVideoY; //shared
int buttonGrayX = buttonVideoX+buttonSizeX+buttonSeparationX;;


float[][] getMask() {
  switch(maskSelected) {
    case 1: return edgeDetection;
    case 2: return edgeDetection2;
    case 3: return sharpen;
    case 4: return boxBlur;
    case 5: return gaussianBlur;
    case 6: return gaussianBlur5;
    default: return edgeDetection;
  }
}

void chargeMedia(boolean media, PGraphics canvas) {
  canvas.beginDraw();
  if(media) {
    video = new Movie(this, "0321_presentschristmasclose_720p.mov");
    canvas.image(video, 0, 0, 450, 450);
    video.play();
    video.loop();
  } 
  canvas.endDraw();
  image(canvas, 50, 50);
}
void drawButtons(){
  pushStyle();
  textAlign(CENTER,CENTER);
  stroke(255);
  color buttonBaseColor = basicTextColor;
  color buttonDisabledColor = color(56,56,80);
  color buttonTextColor = color(255);
  int roundedCorner = 10;
  
  
  //Button video
  if(showImage){
    fill(buttonDisabledColor);
  }
  else{
    fill(buttonBaseColor);
  }
  rect(buttonVideoX, buttonImageAndVideoY, buttonSizeX, buttonSizeY,roundedCorner);
  fill(buttonTextColor);
  text("Movie", buttonVideoX,buttonImageAndVideoY, buttonSizeX,buttonSizeY);
  
  //Buttons Convolutions
  for (int i = 1; i < buttonConvX.length ;i++){
    if(i==maskSelected){
      fill(buttonDisabledColor);
    }
    else{
      fill(buttonBaseColor);
    }
    rect(buttonConvX[i], buttonConvY, buttonSizeX, buttonSizeY,roundedCorner);
    fill(buttonTextColor);
    text("Conv "+i, buttonConvX[i],buttonConvY, buttonSizeX,buttonSizeY);
  }
  
  //button gray
  if(!showGray){
    fill(buttonBaseColor);
  }
  else{
    fill(buttonDisabledColor);
  }
  rect(buttonGrayX, buttonGrayAndHistoY, buttonSizeX, buttonSizeY,roundedCorner);
  fill(buttonTextColor);
  text("Gray", buttonGrayX, buttonGrayAndHistoY, buttonSizeX,buttonSizeY);
  
  //button histo
  popStyle();
}
void setup() {
  
  buttonConvX[1] = buttonImageX;
  buttonConvX[2] = buttonConvX[1]+buttonSizeX+buttonSeparationX ;
  buttonConvX[3] = buttonConvX[2]+buttonSizeX+buttonSeparationX ;
  buttonConvX[4] = buttonConvX[3]+buttonSizeX+buttonSeparationX ;
  buttonConvX[5] = buttonConvX[4]+buttonSizeX+buttonSeparationX ;
  buttonConvX[6] = buttonConvX[5]+buttonSizeX+buttonSeparationX ;

  textSize(18);
  fill(basicTextColor);
  size(1500, 800);
  frameRate(initialFrameRate);
  background(255);
  text("Original:",50,35);
  canvas_initial = createGraphics(650, 450);
  text("Modificado:",750,35);
  canvas_trans = createGraphics(650, 450);
  chargeMedia(showImage, canvas_initial);
  drawButtons();
}


void ScaleOfGray(PGraphics canvas, PImage image) {
  canvas.beginDraw();
  PImage image_gray;
  image_gray = createImage(image.width, image.height, RGB);
  image_gray.loadPixels();
  for (int i = 0; i < image.pixels.length; i++) {
    float green = green(image.pixels[i]);
    float blue = blue(image.pixels[i]);
    float red = red(image.pixels[i]);
    image_gray.pixels[i] = color((green + blue + red)/3);
  }
  image_gray.updatePixels();
  canvas.image(image_gray, 0, 0, 750, 450);
  canvas.endDraw();
  image(canvas, 750, 50);
}


void ConvolutionMask(PGraphics canvas, PImage image, float[][] convolutionMask) {
  canvas.beginDraw();
  PImage image_with_mask;
  image_with_mask = createImage(image.width, image.height, RGB);
  for(int i = 0; i < image.height; i++){
    for(int j = 0; j < image.width; j++) {
      float avgR = 0, avgG = 0, avgB = 0;
      for(int n = 0; n < convolutionMask.length; n++) {
        for(int m = 0; m < convolutionMask[0].length; m++) {
          int x = i + n - convolutionMask.length/2;
          int y = j + m - convolutionMask.length/2;
          if( x < image.height && x >= 0 && y < image.width && y >= 0) {  
            int index = x * image.width + y;
            avgR += red(image.pixels[index]) * convolutionMask[n][m];
            avgG += green(image.pixels[index]) * convolutionMask[n][m];
            avgB += blue(image.pixels[index]) * convolutionMask[n][m];
          }
        }
      }
      image_with_mask.pixels[i * image.width + j] = color(avgR, avgG, avgB);
    }
  }
  image_with_mask.updatePixels();
  canvas.image(image_with_mask, 0, 0, 750, 450);
  canvas.endDraw();
  image(canvas, 750, 50);
}



void draw() {
  if (!showImage) {
    if (video.available()) {
      pushStyle();
      stroke(255);
      rectMode(CORNER);
      fill(255);
      rect(50,500,900,40);
      popStyle();
      fill(basicTextColor);
      String frameRateText = "Eficiencia Computacional "+ frameRate/initialFrameRate*100 + "%";
      textSize(18);
      text(frameRateText, 50, 520);
      video.read();
      if(showGray) {
        ScaleOfGray(canvas_trans, video);
      }
      if(showMask) {
        ConvolutionMask(canvas_trans, video, getMask()); 
      }
      canvas_initial.beginDraw();
      canvas_initial.image(video, 0, 0, 650, 450);
      canvas_initial.endDraw();
      image(canvas_initial, 50, 50);
    }
  }
}

void handleButtonPress(int x, int y){

  if(x > buttonVideoX && x < buttonVideoX + buttonSizeX && y > buttonImageAndVideoY && y < buttonImageAndVideoY + buttonSizeY){
    handleKeyPress('m');
    return;
  }
  if(x > buttonGrayX && x < buttonGrayX + buttonSizeX && y > buttonGrayAndHistoY && y < buttonGrayAndHistoY + buttonSizeY){
    handleKeyPress('g');
    return;
  }  

  for (int i = 1; i < buttonConvX.length ;i++){
    if(x > buttonConvX[i] && x < buttonConvX[i] + buttonSizeX && y > buttonConvY && y < buttonConvY + buttonSizeY){
      handleKeyPress(str(i).charAt(0));
      return;
    }
  }
}

//Handles mouse dragging across histogram
void mousePressed(){

  if(mouseX>buttonImageX && mouseY > buttonImageAndVideoY){
    handleButtonPress(mouseX,mouseY);
  }
}


void applyConvolution() {
  showMask = true;
  showGray = false;

  if(showImage) ConvolutionMask(canvas_trans, image, getMask());
  //Video will be process in movieEvent
}

void keyPressed() {
  handleKeyPress(key);
}
void handleKeyPress(char pressed){
  if(pressed == 'm') {
    showImage = false;
    showGray = false;

    maskSelected = 0;
    chargeMedia(showImage, canvas_initial);
  }
  if(pressed == 'i') {
    showImage = true;
    showGray = false;
    showMask = false;

    maskSelected = 0;
    chargeMedia(showImage, canvas_initial);
  }
  if(pressed == 'g') {
    showGray = true;
    showMask = false;

    maskSelected = 0;
    if(showImage) ScaleOfGray(canvas_trans, image);
    //Video will be process in movieEvent
  }
  if(pressed == 'h' && showImage) {
    showImage = true;
    showGray = false;
    showMask = false;

    maskSelected = 0;

    //Video will be process in movieEvent
  }
  if(pressed == '1') {
    maskSelected = 1;
    applyConvolution();
  }
  if(pressed == '2') {
    maskSelected = 2;
    applyConvolution();
  }
  if(pressed == '3') {
    maskSelected = 3;
    applyConvolution();
  }
  if(pressed == '4') {
    maskSelected = 4;
    applyConvolution();
  }
  if(pressed == '5') {
    maskSelected = 5;
    applyConvolution();
  }
  if(pressed == '6') {
    maskSelected = 6;
    applyConvolution();
  }
  drawButtons();
}
