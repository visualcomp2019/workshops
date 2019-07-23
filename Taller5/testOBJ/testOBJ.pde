PShape pieta;

void setup() {
  size(512, 512, P3D);
  pieta = loadShape("Only_Spider_with_Animations_Export.obj");
}

void draw() {
  background(0xffffffff);
  lights();
  camera(0, 0, height * .86602,
    0, 0, 0,
    0, 1, 0);
  shape(pieta);
  pieta.rotateY(.01);
}
