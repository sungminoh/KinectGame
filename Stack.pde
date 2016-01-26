class Stack{
  int x;
  int y;
  int size;
  PImage img;
  
  Stack(PImage InImg, int nx, int ny){
    x = nx;
    y = ny;
    img = InImg;
    size = int(random(50, 100));
  }
  
  void drawstack(){
    imageMode(CENTER);
    image(img, x, y, size, size);
  }
}
