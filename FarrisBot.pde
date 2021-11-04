class FarrisBot{
  DoodleImageMaker dim; 
  FarrisImageMaker fim; 
  DuckImageMaker dkim; 
  PImage texImg;
  PGraphics pi;
  
  FarrisBot(){
    dim = new DoodleImageMaker();
    fim = new FarrisImageMaker();
    dkim = new DuckImageMaker();
    texImg = loadImage("texture.jpg"); 
  }

  void makeImage(){
    pi = createGraphics(width, height);
    pi.beginDraw();
    pi.tint(255, 255);
    if(random(0, 1) > 0.5){
      pi.background(0);
      pi.image(texImg, 0, 0);
    } else {
      int base = 0;
      if(random(0, 1) > 0.5){
        base = 235;
      }
      pi.background(base + round(random(0, 20)), base + round(random(0, 20)), base + round(random(0, 20)));
    }
    boolean doImg = random(0, 1) > 0.05;
    if(random(0, 1) > 0.5){
      drawSky(pi);
    } else {
      doImg = true;
    }
    if(doImg){
      pi.pushMatrix();
      pi.imageMode(CENTER);
      pi.translate(width/2, height/2);
      pi.rotate(radians(45));
      PImage img;
      int c;
      boolean useFim;
      boolean useDkim = false;
      useFim =random(0, 1) > 0.5;
      do{
        if(useFim){
          img = deformIt(fim.makeImage(random(0,0.5), random(0,0.5)));
        } else {
          if(useDkim){
            img = deformIt(dkim.makeImage());
          } else {
            img = deformIt(dim.makeImage(random(0,0.5), random(0,0.5)));
          }
        }
        c = pxCount(img);
        if (c <500000 || useFim){
          if(random(0, 1) > 0.5){
            pi.tint(255, random(20, 60));
          }
          pi.image(img, 0, 0);
        }
        println("  c = " + c);
      } while (!useFim && !useDkim && (c < 50000 || c > 500000));
      pi.popMatrix();
    } else {
      drawSky(pi);
    }
    pi.save(tmpFileName);
  }
  
  void drawSky(PGraphics pi){
    int horizon = round(random(100, height));
    int tintR = round(random(0, 255));
    int tintG = round(random(0, 255));
    int tintB = round(random(0, 255));
    int alph = round(random(0, 5));
    if(random(0, 1) > 0.5){
      alph += 50;
    }
    int rad = round(random(2, 20));
    if(random(0, 1) > 0.9){
      rad *= 10;
    }
    boolean frame = random(0, 1) < 0.5;
    boolean rec = random(0, 1) < 0.2;
    pi.noStroke();
    pi.fill(tintR, tintG, tintB, alph);
    for(int y = 0; y < horizon; y++){
      for(int x = 0; x < width; x +=random(1, rad)){
        if(random(0, 1) > float(y)/float(horizon)){
          if(rec){
            pi.rect(x, y, rad, rad);
          } else {
            pi.ellipse(x, y, rad, rad);
          }
          if(frame){
            if(rec){
              pi.rect(width-x, y, rad, rad);
              pi.rect(width-x, y, rad, rad);
              pi.rect(width-x, height-y, rad, rad);
            } else {
              pi.ellipse(width-x, y, rad, rad);
              pi.ellipse(width-x, y, rad, rad);
              pi.ellipse(width-x, height-y, rad, rad);
            }
          }
        }
      }
    }
    if(random(0, 1) > 0.5){
      int var = round(random(1, 5)); 
      for(int y = 0; y < horizon; y++){
        for(int x = 0; x < width; x +=random(1, rad)){
          if(random(0, 1) > float(y)/float(horizon)){
            if(random(0, 1) > 0.8){
              pi.fill(tintR + round(random(-1*var, var)), tintG + round(random(-1*var, var)), tintB + round(random(-1*var, var)), alph+10*round(random(1, var)));
              if(rec){
                pi.rect(x, y, rad, rad);
              } else {
                pi.ellipse(x, y, rad, rad);
              }
              if(frame){
                if(rec){
                  pi.rect(x, height-y, rad, rad);
                  pi.rect(y, x, rad, rad);
                  pi.rect(width-y, x, rad, rad);
                } else {
                  pi.ellipse(x, height-y, rad, rad);
                  pi.ellipse(y, x, rad, rad);
                  pi.ellipse(width-y, x, rad, rad);
                }
              }
            }
          }
        }
      }
    }
  }
  
  PImage deformIt(PImage pold){
    return pold;
    /*
    PImage pnew = new PImage(pold.width, pold.height);
    pold.loadPixels();
    pnew.loadPixels();
    for(int x = 0; x < pnew.width; x++){
      for(int y = 0; y < pnew.height; y++){
        int yold = round(cos(PI*x/pnew.width + PI/2)*y*(float(x)/100.0));
        int iold = round(yold*pnew.width) + x;
        if(iold > pold.pixels.length || iold < 0){
          iold = 0;
        }
        pnew.pixels[y*pnew.width + x] = pold.pixels[iold];
      }
    }  
    return pnew;*/
  }
  
  int pxCount(PImage p){
    int ct = 0;
    for(int x = 0; x < p.pixels.length; x++){
      if(p.pixels[x] != p.pixels[0]){
        ct++;
      }
    }
    return ct;
  }
}