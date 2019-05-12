int[] circulos;
int udiametro;
int espacio;

void setup(){

  size(650,650);
  espacio = 50;
  circulos = new int[100];
  int i=0;
  //Se guarda el espacio entre lineas apartir del ancho de recuadro
  while (i<= circulos.length -1){
    circulos[i] = width + (i * espacio/3);
    i++;
  }
  
}

void draw(){
  background(255);
  strokeWeight(2);
  noFill();
  
  
  
  stroke(0);
  int count=0;
  int salto=15;
  
  while(count < width){
    line(0, count, width, count);
    
    count += salto;
  }
  stroke(0);
  
  int i = 0;
  while (i <= circulos.length-1){
    int diametro = circulos[i];
    /*
    if(diametro>=0){
      circulos[i] -= 5;
    }*/
    if(diametro <= 0){
      circulos[i] = udiametro + espacio/3;
      diametro = udiametro + espacio/2;
    }
    else{
      circulos[i] -= 10;
    }
    ellipse(3*width/4,height/2,diametro,diametro);
    ellipse(width/4,height/2,diametro,diametro);
    //ellipse(width/2,height/4,diametro,diametro);
   // ellipse(width/2,3*height/4,diametro,diametro);
    udiametro = diametro;
    i++;
    
  }
  
}
