class DoodleImageMaker{
  
  int imgWidth =  displayWidth;
  int imgHeight = displayHeight;
  
  PGraphics pg;
  float halfWidth;
  float halfHeight;
  int radius = 250;

  DoodleImageMaker(){
    pg = createGraphics(imgWidth,imgHeight);
    halfWidth = (float)imgWidth/2;
    halfHeight = (float)imgHeight/2;  
  }
  
  PGraphics makeImage(float xVar, float yVar){
    pg.beginDraw();
    pg.clear();
    pg.noStroke();
    int numReps = floor(random(2, 10));
    int tintR = round(random(0, 255));
    int tintG = round(random(0, 255));
    int tintB = round(random(0, 255));
    float randWiggle = random(0, 1);
    int rad = round(random(1, 6));
    boolean fadeIn = random(0, 1) > 0.5;
    float mod1 = random(0, 1);
    float mod2 = random(0, 1);
    float mod3 = random(0.5, 20);
    float mod4 = random(0, 1) > 0.5 ? random(-5, 5) : 1;
    float maxDist = random(0.5, 10);
    float powValMin = random(1,1.5);
    float powValMax = random(1.5,2);    
    float rValMin = random(0,2);
    float rValMax = random(5, 100);
    float sValMin = random(0,2);
    float sValMax = random(5, 100);
    boolean multiply = random(0, 1) > 0.5;
    int yOffset = round(random(-200, 0));
    for(int i = 0; i < numReps; i++){
      float r = random(rValMin, rValMax);
      float s = random(sValMin, sValMax);
      float powVal = random(powValMin, powValMax);
      for(float ang = 0.0; ang < 2*PI; ang+=0.0001){
        float x;
        float y;
        if(multiply){
          x = (1+mod1*sin(ang))*radius*cos(mod3*ang)*sin(ang*r) * mod4*pow(sin(ang*s)*sqrt(radius), powVal) + randWiggle*sqrt(random(0, 100));
          y = (1+mod2*cos(ang))*radius*sin(mod3*ang)*cos(ang*r) * mod4*pow(cos(ang*s)*sqrt(radius), powVal) + randWiggle*sqrt(random(0, 100));
        } else {
          x = (1+mod1*sin(ang))*radius*cos(mod3*ang)*sin(ang*r) + mod4*pow(sin(ang*s)*sqrt(radius), powVal) + randWiggle*sqrt(random(0, 100));
          y = (1+mod2*cos(ang))*radius*sin(mod3*ang)*cos(ang*r) + mod4*pow(cos(ang*s)*sqrt(radius), powVal) + randWiggle*sqrt(random(0, 100));
        }
        float dist = maxDist*(sqrt(pow(x, 2.0) + pow(y, 2.0)))/halfWidth;
        if(fadeIn){
          dist = maxDist - dist;
        }
        y += yOffset;
        dist = max(dist, 1);
        pg.fill(0, dist*10);
        pg.ellipse(halfWidth+x, halfHeight+y, rad, rad);
        pg.fill(tintR, tintG, tintB, dist*10);
        pg.ellipse(halfWidth+x+1, halfHeight+y+1, rad, rad);
      }
    tintR += round(random(-50, 50));
    tintG += round(random(-50, 50));
    tintB += round(random(-50, 50));
    }
    pg.endDraw();
    return pg;
  }
      
}