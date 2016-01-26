class fallingStar {
  int mx;
  float my;
  int mAlpha;
  float mSize;
  float mRotate;
  int mnPoints;
  //constructor
  fallingStar(int x, int y)
  {mx = x;
  my = y;
  mAlpha = 255;
  mSize = random(maxStarSize);
  mRotate = random(TWO_PI);
  mnPoints = 5 + (int)random(5);
  }

  boolean notVisible() {
    if (my < 0) {return false;}
    else
      return (my > height) || (mAlpha < 0)  || (mSize < 1.5);
  }

  void display()
  {
    if (!notVisible()) {
      fill(color(255,255,255), mAlpha);
      pushMatrix();
      translate(mx - mSize /2, my - mSize /2);
      rotate(mRotate);
      star(mnPoints,mSize, mSize/4);
      popMatrix();
    }
  }

  void fall()
  {
    mAlpha = mAlpha - 1;
    my = my + 1 + mSize / 5;
    mSize = mSize * 0.99;
  }
}
