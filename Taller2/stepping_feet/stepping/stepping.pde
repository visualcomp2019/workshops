
int a,b,c,d;

void setup(){
  size(600, 600);
  background(150);
  a = (-height/2);
  b = 0;
  c = (-height/2);
  d = 0;
  
}

void draw(){

  
  noFill();
  

  for (int i=width; i >0; i-=25) {
    if (i%2 == 0) {
      fill(255);
      ellipse(width/2, height/2, i, i);
    } else {
      fill(0);
      ellipse(width/2, height/2, i, i);

    }

  }
  
  
  fill(255, 255, 255);
  stroke(255);
  ellipse(b, 260, 30, 15);
  ellipse(d, 340, 30, 15);

  fill(0, 0, 0);
  stroke(0);
  ellipse(260, c, 15, 30);
  ellipse(340, a, 15, 30);
  
  if (mousePressed == true) {
    background(150);
    fill(255, 255, 255);
    stroke(255);
    ellipse(b, 260, 30, 15);
    ellipse(d, 340, 30, 15);
    
    fill(0, 0, 0);
    stroke(0);
    ellipse(260, c, 15, 30);
    ellipse(340, a, 15, 30);
  }
  
  a += 5;
  if (a > height) {
    a = 0;
  }  
  b += 5;
  if (b > width) { 
    b = 0;
  }
  c += 5;
  if (c > height) {
    c = 0;
  }
  d += 5;
  if (d > width) { 
    d = 0;
  }


}
