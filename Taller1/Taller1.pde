import javafx.util.Pair; //<>//
PGraphics pgOriginal, pgFiltered, pgConv, pgSBT, pgHist;
PImage img, g_img, gray_img, sbt_img, sharpenK_img, blurK_img, edgeD_img;
int pgO_x, pgO_y, pgF_x, pgF_y, g_hist[], hist[], option = 1;
float seg_s=-1.0, seg_e=-1.0;
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

float[][] blurKernel5 = { { k, k, k, k, k },
                         { k, k, k, k, k },
                         { k, k, k , k, k},
                       { k, k, k, k, k },
                     { k, k, k, k, k },};

void setup() {
  //Initialize variables
  size(1200,520);
  
  img = loadImage("paisaje.jpg");
  hist = histogram(img);
  g_img = loadImage("paisaje.jpg");
  gray_img = createImage(img.width, img.height, RGB);
  sbt_img = createImage(img.width, img.height, RGB);
  sharpenK_img = createImage(img.width, img.height, RGB);
  blurK_img = createImage(img.width, img.height, RGB);
  edgeD_img = createImage(img.width, img.height, RGB);
  
  pgO_x = 40;
  pgO_y = 80;
  pgF_x = img.width+30+pgO_x;
  pgF_y = 0;
  
  frameRate(60);
  pgHist = createGraphics(img.width, img.height);

  //pgOriginal = createGraphics(img.width, img.height);
  //pgFiltered = createGraphics(img.width, img.height);
  
  //draw Original image with histogram
  //pgOriginal.beginDraw();
  //pgOriginal.background(img);
  //pgOriginal.stroke(0);
  //pgOriginal.endDraw();
  //image(pgOriginal, pgO_x, pgO_y);
  //drawHistogram(o_hist, img.width, img.height, pgO_x);
  
  //draw Grayscale image with histogram
  //pgFiltered.beginDraw();
  //pgFiltered.background(g_img);
  //pgFiltered.stroke(75);
  //pgFiltered.endDraw();
  //image(pgFiltered, pgF_x, pgF_y);
  //drawHistogram(g_hist, g_img.width, g_img.height, pgF_x);
  
  //Image segmentation with brightness threshold
  //segBrightnessThreshold(g_hist, g_img, sbt_img);
  //image(sbt_img, (img.width+10)*2, 0);
  
}

void draw() {
  navbar();
  if(option == 1){
    image(img, pgO_x, pgO_y);
    //Image with gray scale 
    grayscale(g_img);
    image(g_img, pgF_x, pgO_y);
  }else if(option == 2){
    image(img, pgO_x, pgO_y);
    //Apply blur convolution kernel 
    convolution(blurKernel, img, blurK_img,3);
    image(blurK_img, pgF_x, pgO_y);
  }else if(option == 3){
    image(img, pgO_x, pgO_y);
    //Apply sharpen convolution kernel
    convolution(sharpenKernel, img, sharpenK_img, 3);
    image(sharpenK_img, pgF_x, pgO_y);
  }else if(option == 4){
    image(img, pgO_x, pgO_y);
    //Apply edge convolution kernel
    convolution(edgeKernel, img, edgeD_img, 3);
    image(edgeD_img, pgF_x, pgO_y);
  }else if(option == 5){
    image(img, pgO_x, pgO_y);
    pgHist.beginDraw();
    drawHistogram(hist, pgHist);
    pgHist.endDraw();
    image(pgHist, pgF_x, pgO_y);
  }else if(option == 6){
    image(img, pgO_x, pgO_y);
    //Image segmentation with brightness threshold
    //firstHistLocalPeak(hist);
    segBrightnessThreshold(img, sbt_img, min(seg_s,seg_e), max(seg_s,seg_e));
    image(sbt_img, pgF_x, pgO_y);
  }
}

void navbar(){
  fill(255);
  rect(150, 25, 100, 30);
  rect(300, 25, 100, 30);
  rect(450, 25, 100, 30);
  rect(600, 25, 100, 30);
  rect(750, 25, 100, 30);
  rect(900, 25, 100, 30);
  fill(0);
  text("Gray", 185, 45);
  text("Conv blur", 325, 45);
  text("Conv sharpen", 464, 45);
  text("Conv edge", 623, 45);
  text("Histogram", 774, 45);
  text("Segmentation", 915, 45);
  noFill();
}

void mouseClicked() {
  background(200);
  if(mouseX > 150 && mouseX < 250 && mouseY > 25 && mouseY < 55) {
    option = 1;
  }else if(mouseX > 300 && mouseX < 400 && mouseY > 25 && mouseY < 55) {
    option = 2;
  }else if(mouseX > 450 && mouseX < 550 && mouseY > 25 && mouseY < 55) {
    option = 3;
  }else if(mouseX > 600 && mouseX < 700 && mouseY > 25 && mouseY < 55) {
    option = 4;
  }else if(mouseX > 750 && mouseX < 850 && mouseY > 25 && mouseY < 55) {
    option = 5;
    seg_s=-1.0;
    seg_e=-1.0;
  }else if(mouseX > 900 && mouseX < 1000 && mouseY > 25 && mouseY < 55) {
    option = 6;
  }else if(option == 5 && mouseX > pgF_x && mouseX < pgF_x + img.width && mouseY > pgO_y && mouseY < pgO_y + img.height){
    //Draw lines on histogram to be used for segmentation
    if(seg_s == -1.0){
      seg_s = mouseX-pgF_x;
      line(mouseX, pgO_y, mouseX, pgO_y + pgHist.height);
    }else if(seg_e == -1.0){
      seg_e = mouseX-pgF_x;
      line(seg_s+pgF_x, pgO_y, seg_s+pgF_x, pgO_y + pgHist.height);
      line(mouseX, pgO_y, mouseX, pgO_y + pgHist.height);
    }
  }
  println("("+mouseX+", "+mouseY+")");
}


void grayscale(PImage img) {  
  for(int i=0; i<img.width; i++){
    for(int j=0; j<img.height; j++){
      color c = img.get(i,j);
      c = color(Math.round((red(c) + green(c) + blue(c))/3));
      img.set(i,j,c);      
    }
  }
}

int [] histogram(PImage img){
  int[] hist = new int[256];
  
  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(img.get(i, j)));
      hist[bright]++; 
    }
  }
  return hist;
}

void drawHistogram(int[] hist, PGraphics pgHist){
  // Find the largest value in the histogram
  int histMax = max(hist);
  
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < pgHist.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, pgHist.width, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist[which], 0, histMax, pgHist.height, 0));
    pgHist.line(i, pgHist.height, i, y);
  }
}

void segBrightnessThreshold (PImage source, PImage dest, float start, float end){
  if (start ==-1.0 || end == -1.0){
    start=5;
    end=150;
  }else{
    start  = map(start, 0, pgHist.width, 0, 255);
    end = map(end, 0, pgHist.width, 0, 255);
  }
  // We are going to look at both image's pixels
  source.loadPixels();
  dest.loadPixels();
  
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      int loc = x + y*source.width;
      // Test the brightness against the threshold
      float b = brightness(source.pixels[loc]);
      if (b > start && b < end) {        
        dest.pixels[loc]  = color(255);  // White
      }  else {
        dest.pixels[loc]  = color(0);    // Black
      }
    }
  }

  // We changed the pixels in destination
  dest.updatePixels();
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

void convolution(float[][] kernel, PImage source, PImage dest, int kernelSize){
  // We are going to look at both image's pixels
  source.loadPixels();
  dest.loadPixels();
  
  // Begin our loop for every pixel
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      color c = applyKernel(x,y,kernel, kernelSize,img);
      int loc = x + y*img.width;
      dest.pixels[loc] = c;
    }
  }
  
  // We changed the pixels in destination
  dest.updatePixels();
}
