int radius=0;

void setup() {
   size(450, 450);
}

void draw() {
  background(240,248,248);
  for(int y=75;y<width;y+=150){
    for(int x=75;x<width;x+=150){
      for (int i=162; i >=13; i-=13) {
        if (i%2 == 0) {
          fill(100);
          ellipse(x, y, i-13, i-13);
        } else {
          fill(240,248,248);
          ellipse(x, y, i, i);
        }
      }
    }
  }
  for(int y=-width+75;y<width;y+=150){  
     stroke(210,6,31);
     strokeWeight(2);
     line(y,0,450,width-y);
     line(y+width,0,y,450);
     stroke(0);
   }
  
  if (mousePressed == true) {
   background(240,248,248);
   for(int y=-width+75;y<width;y+=150){  
     stroke(210,6,31);
     strokeWeight(2);
     line(y,0,450,width-y);
     line(y+width,0,y,450);
     stroke(0);
   }
 }
}
