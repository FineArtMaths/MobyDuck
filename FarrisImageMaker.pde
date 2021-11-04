class FarrisImageMaker{

  int firstDivisor = 3;
  int secondDivisor = 2;
  float halfWidth;
  float halfHeight;
  float mult;
  PGraphics pg;
  int imgWidth = 800;
  int imgHeight = 800;
  int max = 200;
  int rad = 4;
  float fullCircle = 2*PI;
  int scalar = 1;
  
  FarrisImageMaker(){
    pg = createGraphics(imgWidth,imgHeight);
    halfWidth = (float)imgWidth/2;
    halfHeight = (float)imgHeight/2;  
  }
      
  PGraphics makeImage(float xVar, float yVar){
    if(random(0, 1) > 0.8){
      xVar/=10;
      yVar/=10;
    } else {
      while(random(0, 1)  > 0.8){
        xVar+=1;
      }
      while(random(0, 1)  > 0.8){
        yVar+=1;
      }
    }
    secondDivisor = round(random(1, 5));
    firstDivisor = secondDivisor + round(random(1, 5));
    scalar = floor(random(1, 4));
    mult = halfHeight/(1 + 2*scalar/firstDivisor + 2*scalar/secondDivisor);
    setRandomColourScheme();
    makeShape(xVar, yVar, false);
    pg.beginDraw();
    pg.clear();
    pg.fill(255, 200, 200);
    pg.noStroke();
    makeShape(xVar, yVar, true);
    pg.endDraw();
    return pg;
  }
  
  int xRange = 0;
  int yRange = 0;
  void makeShape(float xVar, float yVar, boolean drawIt){
    float maxX = 0;
    float maxY = 0;
    float minX = 0;
    float minY = 0;
    int var1 = floor((scalar * max *xVar) - max);
    int var2 = floor((scalar * max*yVar) - max);
    float wobble = 0.0;
    if(random(0, 1) > 0.5){
      wobble = random(1, 20);
    }
    int yOffset = round(random(-200, 0));
    for(float t = 0.0; t < fullCircle; t+=0.00001){
      float x = mult * (cos(t) + cos(var1 * t)/firstDivisor + sin(var2 * t)/secondDivisor) + random(-1*wobble, wobble);
      float y = yOffset + mult * (sin(t) + sin(var1 * t)/firstDivisor + cos(var2 * t)/secondDivisor) + random(-1*wobble, wobble);
      int dist = round(sqrt(pow(x, 2) + pow(y, 2)));
      if(drawIt){
        setFill(dist);
        pg.ellipse(halfWidth + x, halfHeight + y, rad, rad);
        dist = dist/2;
        setFill(dist);
        pg.ellipse(halfWidth + x + 3, halfHeight + y + 3, rad, rad);
      } else {
        if(halfWidth + x > maxX){
          maxX = halfWidth + x;
        }
        if(halfWidth + x < minX){
          minX = halfWidth + x;
        }
        if(halfHeight + y > maxY){
          maxY = halfHeight + y;
        }
        if(halfHeight + y < minY){
          minY = halfHeight + y;
        }
      }
    }
    if(!drawIt){
      xRange = round(maxX-minX)+1;
      yRange = round(maxY-minY)+1;
      println(xRange + ", " + yRange);
    }
  }
  
  int redOffset = 0; 
  int blueOffset = 0; 
  int greenOffset = 0; 
  void setRandomColourScheme(){
    redOffset = round(random(0, 100)-70);
    blueOffset = round(random(0, 100)-70);
    greenOffset = round(random(0, 100)-70);
  }
  
  void setFill(int dist){
    pg.fill(dist + redOffset, dist + blueOffset, dist + greenOffset, dist);
  }
}