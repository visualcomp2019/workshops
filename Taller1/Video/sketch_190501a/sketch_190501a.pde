
import processing.video.*;
Movie myMovie;

void setup() {
  size(960, 540);
  background(0);
  myMovie = new Movie(this, "0321_presentschristmasclose_720p.mov");
  myMovie.loop();
  //myMovie.frameRate(10);
  //frameRate(10);
}

void draw() {
  if(myMovie.available()){
    myMovie.read();
    grayscale(myMovie);
  }
  
  
  
  image(myMovie, 0, 0);

}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  
}

void grayscale(Movie img) {  
  for(int i=0; i<img.width; i++){
    for(int j=0; j<img.height; j++){
      color c = img.get(i,j);
      c = color(Math.round((red(c) + green(c) + blue(c))/3));
      img.set(i,j,c);      
    } //<>//
  }
}
