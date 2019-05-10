PGraphics pg;
int illusion;

void setup() {
  illusion = 0;  
  size(600, 600, P3D);
  noStroke(); 
  pg = createGraphics(600, 600, P3D);
  illusion0();
}

void draw() {   
 
}

void keyPressed() {
  if(keyCode == RIGHT) {
    if(illusion == 5){
      illusion = 0;
    }else{
      illusion++;
    }
    illusionSelector();
  }else if(keyCode == LEFT) {
    if(illusion == 0){
      illusion = 5;
    }else{
      illusion--;      
    }
    illusionSelector();
  }
}

void illusionSelector() {
  pg.clear();
  switch(illusion) {
    case 0:
      illusion0();
      break;
   
    case 1:
      illusion1();
      break;
   
    case 2:
      illusion2();    
    
    case 3:
      illusion3();
      
    case 4:
      illusion4();
    
    case 5:
      illusion5();
  
  }  
}

void illusion0() {
  PImage texture; 
  PShape globe;
  texture = loadImage("data/texture.jpg");
  globe = createShape(SPHERE, 200);
  globe.setTexture(texture);
  
  
  pg.beginDraw();
  pg.image(texture, 0,0);
  pg.translate(width/2, height/2); 
  pg.shape(globe); 
  pg.endDraw();
  image(pg,0,0);
}

void illusion1() {

}

void illusion2() {

}

void illusion3() {

}

void illusion4() {

}

void illusion5() {

}
