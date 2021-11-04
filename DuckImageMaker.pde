class DuckImageMaker{
  
  int imgWidth =  displayWidth;
  int imgHeight = displayHeight;
  
  PGraphics pg;
  float halfWidth;
  float halfHeight;
  int radius = 250;

  int numImages = 20;
  ArrayList<PImage> templates = new ArrayList<PImage>(); 
  HashMap<Integer, ArrayList<Integer>> contrastMaps = new HashMap<Integer, ArrayList<Integer>>(); 
  HashMap<Integer, Integer> averageContrasts = new HashMap<Integer, Integer>(); 
  int x;
  int y;
  int ct = 0;
  ArrayList<Integer> contrastMap;
  int templateIndex;
  PGraphics pgTemplate;

  DuckImageMaker(){
    pg = createGraphics(imgWidth,imgHeight);
    halfWidth = (float)imgWidth/2;
    halfHeight = (float)imgHeight/2;  
    for(int i = 1; i <= numImages; i++){
      PImage tmp = loadImage(i + ".jpg");
      PGraphics tmppg = createGraphics(width, height);
      tmppg.beginDraw();
      tmppg.image(tmp, 0, 0, width, height);
      tmppg.endDraw();
      templates.add(tmppg);
    }
    init();
  }
  

  void init(){
    background(0);
    ct = 0;
    x = floor(random(0, width));
    y = floor(random(0, height));
    templateIndex = floor(random(templates.size()));
    contrastMap = contrastMaps.containsKey(templateIndex) ? 
                                    contrastMaps.get(templateIndex) :
                                    buildContrastMap(templateIndex);
    //contrastMap = buildContrastMap(templateIndex);
    pgTemplate = createGraphics(width, height);
    pgTemplate.beginDraw();
    pgTemplate.loadPixels();
    for(int i = 0; i < pgTemplate.pixels.length; i++){
      if(contrastMap.get(i) > averageContrasts.get(templateIndex)*2){
        pgTemplate.pixels[i] = 255 - color(min(255, contrastMap.get(i)/4));
      } else {
        pgTemplate.pixels[i] = color(255);
      }
    }
    pgTemplate.updatePixels();
    pgTemplate.endDraw();
    //image(pgTemplate, 0, 0);
  }

  PGraphics makeImage(){
    init();
    pg.beginDraw();
    pg.clear();    
    pg.noStroke();
    int n = round(random(50, 150));
    int m = round(random(-30, 30));
    int l = round(random(-30, 30));
    pg.fill(n, n+m, n+l, 30);
    pg.image(pgTemplate, 0, 0);
    int minR = 5;
    int maxR = 50;
    for(int i = 0; i < 10000; i++){
      int r = round(random(0, pgTemplate.pixels.length - 1));
      if(contrastMap.get(r) > averageContrasts.get(templateIndex)*2){
//      if(random(0, 255) < pgTemplate.pixels[r]){
        int y = r/width;
        pg.ellipse(r%width, y, random(minR, maxR), random(minR, maxR));
      }
    }
    pg.endDraw();
    return pg;
  }


  ArrayList<Integer> buildContrastMap(int templateIndex){
    ArrayList<Integer> cm = new ArrayList<Integer>();
    PImage template = templates.get(templateIndex);
    
    int avg = 0;
    for(int i = 0; i < template.pixels.length; i++){
      int contrast = 0;
      if(i%template.width != 0){
        contrast += getContrast(template.pixels[i], template.pixels[i-1]);
      }
      if(i%template.width != template.width - 1){
        contrast += getContrast(template.pixels[i], template.pixels[i+1]);
      }
      if(i > template.width){
        contrast += getContrast(template.pixels[i], template.pixels[i - template.width]);
        if(i%template.width != 0){
          contrast += getContrast(template.pixels[i], template.pixels[i-1 - template.width]);
        }
        if(i%template.width != template.width - 1){
          contrast += getContrast(template.pixels[i], template.pixels[i+1 - template.width]);
        }
      }
      if(i < template.pixels.length - template.width){
        contrast += getContrast(template.pixels[i], template.pixels[i + template.width]);
        if(i%template.width != 0){
          contrast += getContrast(template.pixels[i], template.pixels[i-1 + template.width]);
        }
        if(i%template.width != template.width - 1){
          contrast += getContrast(template.pixels[i], template.pixels[i+1 + template.width]);
        }
      }
      contrast = floor(contrast / 10);
      avg += contrast;
      cm.add(contrast);
    }
    contrastMaps.put(templateIndex, cm);
    avg /= template.pixels.length;
    averageContrasts.put(templateIndex, avg);
    return cm;
  }
  
  int getContrast(color c1, color c2){
    return round(abs(red(c1)- red(c2)) + abs(green(c1)- green(c2)) + abs(blue(c1)- blue(c2)));
  }
  
  int getBrightness(color c){
    return round(red(c) + green(c) + blue(c));
  }
  
  void resetXY(){
    x =floor(random(0, width));
    y = floor(random(0, height));
  }

}