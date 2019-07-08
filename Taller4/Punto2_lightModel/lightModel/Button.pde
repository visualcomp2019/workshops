class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  boolean on;
  
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    on = false;
  }
  
  void Draw() {
    if(on) fill(180); else fill(0);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(255);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && 
        mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
