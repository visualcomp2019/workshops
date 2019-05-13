int s;

void setup() {
   size(500, 500);
}

void draw() {
  background(255);
  for(s=-100;s<width+100;s+=20){  
     stroke(0);
     strokeWeight(10);
     line(0,s+10,width,s+10);
   }
   for(int f=0;f<width;f+=20){  
     stroke(127);
     strokeWeight(10);
     line(100,f+10,200,f+10);
     line(300,f+20,400,f+20);
   }
   
  if (mousePressed) {
   background(255);
   for(int f=0;f<width;f+=20){  
     stroke(127);
     strokeWeight(10);
     line(100,f+10,200,f+10);
     line(300,f+20,400,f+20);
   }
 }
 if (keyPressed){
    if(key=='+'){
      s++;
    }else if(key=='-'){
      s--;
    }
  }
}
