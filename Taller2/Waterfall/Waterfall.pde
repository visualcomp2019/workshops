int radius=600;
float n = PI/6;
boolean change = true;
int d = 0; 
 
void setup(){
  size(600,600);
}
 
void draw(){
  if(d%2==0){
    background(127);
    for(int i=0;i<12;i++){
      if(i%2==0){
        fill(255);
        arc(width/2, width/2, radius, radius, i*n,(i+1)*n);
      }else{
        fill(0);
        arc(width/2, width/2, radius, radius, i*n,(i+1)*n);
      }
    } 
  }else{
    for(int i=0;i<12;i++){
      if(i%2==0){
        fill(0);
        arc(width/2, width/2, radius-30, radius-30, i*n,(i+1)*n);
      }else{
        fill(255);
        arc(width/2, width/2, radius-30, radius-30, i*n,(i+1)*n);
      }
    }
  }
  if(radius>0)radius--;  
  d+=15;
}
