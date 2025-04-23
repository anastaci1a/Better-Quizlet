Desktop desktop;

void settings() {
  size(Config.WINDOW_WIDTH, Config.WINDOW_HEIGHT, P3D);
  
  PJOGL.setIcon(".media/icon.png");
}
void setup() {
  colorMode(HSB, 360, 100, 100, 255);
  
  cfgSurface();
  initSets();
  desktop = new Desktop("Testing", #6b3516);
}
void draw() {
  float backgroundHue = (frameCount % 360) / 20.0;
  background(backgroundHue, 20, 100);
  
  if(desktop != null) {
    desktop.update();
    desktop.draw();
  }
}
void mousePressed() {
  if(desktop != null) {
    desktop.mousePressed();
  }
}
void mouseReleased() {
  if(desktop != null) {
    desktop.mouseReleased();
  }
}
