import java.io.FileWriter;
String tmpFileName = "C:\\Users\\Rich Cochrane\\Documents\\Processing\\_CSMPillars\\MobyDuck\\images\\tmp.png";
String usedFileName = "C:\\Users\\Rich Cochrane\\Documents\\Processing\\_CSMPillars\\MobyDuck\\data\\used.txt";
FarrisBot fb;
MarkovTest mt;
ArrayList<String> doNotUseUsers = new ArrayList<String>();
FileWriter fDoNotUse;

void setup(){
  size(800, 800);
  fb = new FarrisBot();
  mt = new MarkovTest(this);
  TwitterFacade.authenticate();
  for(String line : loadStrings("used.txt")){
    doNotUseUsers.add(line);
  }
  TwitterFacade.testMode = false;
  frameRate(TwitterFacade.testMode ? 1 : 0.002);  // important! If you make too many queries, Twitter will lock you out.
}

void draw(){
  // Create the text
  boolean rt = false;
  String msg = getMessage(rt);
  println("Finished creating message");
  if(msg == ""){
    println("Ended up with an empty sentence, skipping the rest");
  } else {
    println("Trying to post... " + msg);
    if(!rt){
      // Create an image
      fb.makeImage();
      println("Finished creating image");
      File f = new File(tmpFileName);
      TwitterFacade.postMediaStatus(msg, f);
    } else {
      TwitterFacade.postTextStatus(msg);
    }
    image(fb.pi, 0, 0);
    println("DONE");
  }
}


String getMessage(boolean rt){
  if(!rt){
    return mt.getSentence();
  } else {
    ArrayList<Status> tweets = TwitterFacade.query("duck");
    println("Found " + tweets.size() + " tweets");
    for(Status tweet : tweets){
      String str = tweet.getText().toLowerCase();
      String name = tweet.getUser().getScreenName();
      if(!doNotUseUsers.contains(name) &&
         str.indexOf("duckbills") == -1 && 
         str.indexOf("duckboard") == -1 && 
         str.indexOf("ducklings") == -1 && 
         str.indexOf("ducktails") == -1 && 
         str.indexOf("duckwalks") == -1 && 
         str.indexOf("duckweeds") == -1 && 
         str.indexOf("shelducks") == -1 && 
         str.indexOf("duckbill") == -1 && 
         str.indexOf("duckiest") == -1 && 
         str.indexOf("duckling") == -1 && 
         str.indexOf("duckpins") == -1 && 
         str.indexOf("ducktail") == -1 && 
         str.indexOf("duckwalk") == -1 && 
         str.indexOf("duckweed") == -1 && 
         str.indexOf("geoducks") == -1 && 
         str.indexOf("gweducks") == -1 && 
         str.indexOf("shelduck") == -1 && 
         str.indexOf("duckers") == -1 && 
         str.indexOf("duckier") == -1 && 
         str.indexOf("duckies") == -1 && 
         str.indexOf("ducking") == -1 && 
         str.indexOf("duckpin") == -1 && 
         str.indexOf("geoduck") == -1 && 
         str.indexOf("gweduck") == -1 && 
         str.indexOf("ducked") == -1 && 
         str.indexOf("ducker") == -1 && 
         str.indexOf("duckie") == -1 && 
         str.indexOf("@") == -1 && 
         //str.indexOf("#") == -1 && 
         str.indexOf("ducky") == -1){
            try{
              fDoNotUse = new FileWriter(usedFileName, true);
              fDoNotUse.write(name + "\n");
              fDoNotUse.flush();
              fDoNotUse.close();
            } catch (Exception e){
              e.printStackTrace();
              exit();
            }
           doNotUseUsers.add(name);
           return "RT " + name + ": " + tweet.getText().replace("duck", "whale").replace("Duck", "Whale").replace("DUCK", "WHALE");
         }
    }  
  }
  return "";
}