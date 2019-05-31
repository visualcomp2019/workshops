import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P2D;

// 4. Window dimension
int dim = 9;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  rectMode(CENTER);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    popStyle();
  }
  
  
  // Lizzy: get box around triangle
  /*
  float minX = min(v1.x(), min(v2.x(),v3.x()));
  float maxX = max(v1.x(), max(v2.x(),v3.x()));
  float minY = min(v1.y(), min(v2.y(),v3.y()));
  float maxY = max(v1.y(), max(v2.y(),v3.y()));
  */
  
  pushStyle();
  stroke(126, 250, 252);
  
  // Lizzy: loop through each pixel
  for(float py = pow(2, n)/2; py>=-pow(2, n)/2;py--){
    for(float px = -pow(2, n)/2; px<=pow(2, n)/2; px++){
      // From v1 to v2
      float f_12 = orient2D(node.location(v1).x(),node.location(v1).y(),node.location(v2).x(),node.location(v2).y(),px,py);
      // From v2 to v3
      float f_23 = orient2D(node.location(v2).x(),node.location(v2).y(),node.location(v3).x(),node.location(v3).y(),px,py);
      // From v3 to v1
      float f_31 = orient2D(node.location(v3).x(),node.location(v3).y(),node.location(v1).x(),node.location(v1).y(),px,py);
      
      // Lizzy: if all f's are positive, then the point is inside the triangle
      if(f_12>=0 && f_23>=0 && f_31>=0){
        //point(px,py);
        rect(px, py,1,1);
      }
    }  
  }
  popStyle();  
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  
  // Lizzy: always make a "positive" counter-clockwise triangle
  if(orient2D(v1.x(),v1.y(),v2.x(),v2.y(),v3.x(),v3.y())<0){
    Vector temp = v1;
    v1=v2;
    v2=temp;
  }
}

float orient2D(float ax, float ay, float  bx, float  by, float  cx, float cy){
  return (bx-ax)*(cy-ay)-(by-ay)*(cx-ax);
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
    println(n);
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
    println(n);
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
