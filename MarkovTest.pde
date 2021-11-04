import rita.*;
import java.util.*;

class MarkovTest {
  RiMarkov rm;
  MarkovTest(PApplet parent){
    rm = new RiMarkov(3);
    rm.loadFrom(".\\data\\mobydick.txt", parent);
  }
  
  String getSentence(){
    println("1");
    String[] sentences = rm.generateSentences(20);
    for(int i = 0; i < sentences.length; i++){
      String sent = sentences[i].toLowerCase();
      if(sent.contains("whale") || sent.contains("duck") || sent.contains("quail") || sent.contains("pond")  || sent.contains("quack") || sent.contains("bill") || sent.contains("feather")   || random(0, 1) > 0.99){
        String str = sentences[i].replace("Whaler", "Ducker").replace("whaler", "ducker").replace("Whaling", "Ducking").replace("whaling", "ducking").replace("whale", "duck").replace("Whale", "Duck").replace("a sperm", "an Avebury").replace("A sperm", "An Avebury").replace("Sperm", "Avebury").replace("sperm", "Avebury");
        str = str.replace("\"", " ").replace("“", " ").replace("”", " ");
        str = matchParens(str);
       // while(str.indexOf("  ") != -1){
          str.replace("  ", " ");
       // }
       if(str.length() < 140){
         return str;
       }
      }
    }
    return "";
  }

  // If a string has a mismatched parenthesis, remove them all.
  String matchParens(String str){
    boolean removeParens = false;
    int openCount = 0;
    for(int i = 0; i < str.length(); i++){
      if(str.charAt(i) == '('){
        openCount++;
      } else if(str.charAt(i) == ')'){
        openCount--;
      }  
      if(openCount < 0){
        removeParens = true;
        break;
      }
    }
    if(!removeParens && openCount != 0){
      removeParens = true;
    }
    if(removeParens){
      str = str.replace("(", " ").replace(")", " ");
    }
    return str;
  }
}