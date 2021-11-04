/**************************************************
A simple wrapper around twitter4j for Processing.

Copy this file to your Processing project's 
folder to use it.

You will need to unzip twitter4j into your 
Processing/libraries folder, and also copy
the core jar file into Processing/your-project/code
(which you'll need to create).

Created by Fine Art Maths Centre at University
of the Arts London. Licensed to FAMC students 
for any use. Licensed to others under CC BY-NC-SA.
**************************************************/

import twitter4j.*;

static class TwitterFacade{

  static twitter4j.Twitter twitter;
  static boolean authenticated = false;
  static boolean quietMode = false;
  static boolean testMode = false;
  
  // Insert your authentication credentials here 
  static void authenticate(){
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("d24U4j7UHeKsuFnb24h0ZUkl1");
    cb.setOAuthConsumerSecret("yLUJEdRJBqnMQtuna2Yord3OjXHiqTDupjT0JRCNKJPbAaNS5b");
    cb.setOAuthAccessToken("912678625975193600-Ec3V9B8rr95UVMaIh9GSG5eWqXvyn2P");
    cb.setOAuthAccessTokenSecret("r8LIdzzLnyo5oLrPt5ndj8pRO3dYjUSd9Epqk70Dn25Pf");  
    twitter = new TwitterFactory(cb.build()).getInstance();
    authenticated = true;
    pl("TwitterFacade: Successfully authenticated on twitter");
  }
  
  static void postTextStatus(String status){
    postMediaStatus(status, null);
  }
  
  static void postMediaStatus(String status, File media){
    if(testMode){
      println("Will not post to Twitter in test mode");
      return;
    }
    if(authenticated){
      Status st = null;
      try{
        StatusUpdate statusObj = new StatusUpdate(status);
        if(media != null){
          statusObj.setMedia(media);
        }
        st = twitter.updateStatus(statusObj);
      } catch(Exception e){
        pl(e.getStackTrace().toString());
        pl(e.getMessage());
      }
      if(st == null){
        pl("Failed to update status");
      } else {
        pl("Successfully updated the status to [" + st.getText() + "].");
      }
    } else {
      pl("NOT AUTHENTICATED!");
    }
  }

  static ArrayList<Status> query(String term){
    try {
        Query query = new Query(term);
        QueryResult result;
        ArrayList<Status> tweets = new ArrayList<Status>();
        do {
            result = twitter.search(query);
            for (Status tweet : result.getTweets()) {
              tweets.add(tweet);
            }
        } while ((query = result.nextQuery()) != null);
        return tweets;
    } catch (TwitterException te) {
        te.printStackTrace();
        System.out.println("Failed to search tweets: " + te.getMessage());
        return null;
  }  
}
  
  // Use this if you don't want TwitterFacade to print messages to the console
  static void setQuietMode(boolean mode){
    quietMode = mode;
  }
  
  static void pl(String str){
    if(!quietMode){
      println(str);
    }
  }
}