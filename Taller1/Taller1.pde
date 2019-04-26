PGraphics pgOriginal, pgFiltered, pgConv, pgSBT;
PImage img, g_img, sbt_img, sharpenK_img, blurK_img;
int pgO_x, pgO_y, pgF_x, pgF_y, g_hist[], o_hist[];
float[][] sharpenKernel = { { -1, -1, -1 },
                            { -1,  9, -1 },
                            { -1, -1, -1 } };
float k = 1.0/9;
float[][] blurKernel = { { k, k, k },
                         { k, k, k },
                         { k, k, k } };

void setup() {
  //Initialize variables
  size(1200,450);
  
  img = loadImage("./data/the_kiss_gustav_klimt.png");
  o_hist = histogram(img);  
  g_img = loadImage("./data/the_kiss_gustav_klimt.png");
  grayscale(g_img);
  g_hist = histogram(g_img);
  sbt_img = createImage(img.width, img.height, RGB);
  sharpenK_img = createImage(img.width, img.height, RGB);
  blurK_img = createImage(img.width, img.height, RGB);
  
  pgO_x = 0;
  pgO_y = 0;
  pgF_x = img.width+10;
  pgF_y = 0;
  
  pgOriginal = createGraphics(img.width, img.height);
  pgFiltered = createGraphics(img.width, img.height);
  
  //draw Original image with histogram
  pgOriginal.beginDraw();
  pgOriginal.background(img);
  pgOriginal.stroke(0);
  pgOriginal.endDraw();
  image(pgOriginal, pgO_x, pgO_y);
  drawHistogram(o_hist, img.width, img.height, pgO_x);
  
  //draw Grayscale image with histogram
  pgFiltered.beginDraw();
  pgFiltered.background(g_img);
  pgFiltered.stroke(75);
  pgFiltered.endDraw();
  image(pgFiltered, pgF_x, pgF_y);
  drawHistogram(g_hist, g_img.width, g_img.height, pgF_x);
  
  //Image segmentation with brightness threshold
  segBrightnessThreshold(g_hist, g_img, sbt_img);
  image(sbt_img, (img.width+10)*2, 0);
  
  //Apply sharpen convolution kernel
  convolution(sharpenKernel, img, sharpenK_img);
  image(sharpenK_img, (img.width+10)*3, 0);
  
  //Apply sharpen convolution kernel 
  convolution(blurKernel, img, blurK_img);
  image(blurK_img, (img.width+10)*4, 0);
}

void draw() {
  
}

void grayscale(PImage img) {  
  for(int i=0; i<img.width; i++){
    for(int j=0; j<img.height; j++){
      color c = img.get(i,j);
      c = color(Math.round((red(c) + green(c) + blue(c))/3));
      img.set(i,j,c);      
    } //<>//
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

void drawHistogram(int[] hist, int dest_width, int dest_height,  int origin_x){
  // Find the largest value in the histogram
  int histMax = max(hist);
  
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < dest_width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, dest_width, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist[which], 0, histMax, dest_height, 0));
    line(i+origin_x, dest_height*2, i+origin_x, y+dest_height);
  }
}

void segBrightnessThreshold (int[] hist, PImage source, PImage dest){
  float threshold = max(hist)*0.3;

  // We are going to look at both image's pixels
  source.loadPixels();
  dest.loadPixels();
  
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      int loc = x + y*source.width;
      // Test the brightness against the threshold
      if (brightness(source.pixels[loc]) > threshold) {
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

void convolution(float[][] kernel, PImage source, PImage dest){
  // We are going to look at both image's pixels
  source.loadPixels();
  dest.loadPixels();
  
  // Begin our loop for every pixel
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      color c = applyKernel(x,y,kernel, 3,img);
      int loc = x + y*img.width;
      dest.pixels[loc] = c;
    }
  }
  
  // We changed the pixels in destination
  dest.updatePixels();
}
