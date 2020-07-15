import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  _MyHomePageState();
  String textToDisplayOnAlert = "";

  AnimationController slideController; // Crete an animation controller to show the slide animation on start
  Animation<Offset> slideOffsetAnimation;

  String lyrics = "";

  bool textState = false; // A variable to control an animation between searches of songs

  Color textBoxColor = Colors.white;

  double textBoxPaddingValue = 200;

  final String baseURL = "https://orion.apiseeds.com/api/music/lyric/"; // The API endpoint
  final String APIKey = "h4u5fEvPpoCj01LEObdL3oZSkT1m11XmdvLL3KeyXrkR0mTLIZOCvcze9HkcdSVW"; // API key

  // Text controllers for artist and song name
  final artistTextController = TextEditingController();
  final songTextController = TextEditingController();

  @override
  void initState(){
    super.initState();
    slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    slideController..forward();
    slideOffsetAnimation = Tween<Offset>(
      begin: const Offset(-6.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeInOut,
    ));
  }

  Future<bool> checkConnectivity() async {
    // Checks connectivity to the internet using 'Connectivity' package
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) { // Checks if the device is connected to the internet via either mobile data or wifi
      return true;
    }
    else {
      return false;
    }
  }


  getLyrics() async {
    // Get song and artist name from user (Text fields)
    String artist = artistTextController.text.toString();
    String song = songTextController.text.toString();

    bool isConnetedInternet = await checkConnectivity(); // Check if the device is connected to the internet
    //print("Connectivity list is: ${ConnectivityResult.values}");
    if (!isConnetedInternet) { // Check if there is no connection to the internet
      textToDisplayOnAlert = "You are not connected to the internet";
      showAlertDialog(textToDisplayOnAlert);
      return;
    }

    if(artist == '' || song == '') { // Checks if one or both of the fields are empty
      textToDisplayOnAlert = "One of the fields is empty!"; // Set the text to display on the alert dialog
      showAlertDialog(textToDisplayOnAlert); // Display the alert dialog
      return; // End the execution of the function
    }


    var request = await HttpClient().getUrl(Uri.parse(baseURL + "$artist/$song?apikey=$APIKey")); // create a request to the API
    var response = await request.close(); // send the request
    String content = ""; // A variable to store the content of the response from the API
    await for(var contents in response.transform(Utf8Decoder())) {
      content += contents;
    }
    //print(content);
    if(content == "{\"error\":\"Lyric no found, try again later.\"}") { // Checks if the lyrics for the song are not found
      //print("Error! song not found!");
      textToDisplayOnAlert = "Song not found!"; // Set the text to display on the alert dialog
      showAlertDialog(textToDisplayOnAlert);// Display the alert dialog
      return; // End the execution of the function
    }
    dynamic jsonObject = jsonDecode(content); // This is the response object
    setState(() {
      if (lyrics == "") { // If this is the first search another animation will appear (the text box will scale up)
        textBoxPaddingValue = 0.0;
        //textBoxColor = Colors.blue;
        textBoxColor = Color(0xFF000066);
      }
      lyrics = jsonObject["result"]["track"]["text"]; // Get the lyrics from the response object and store in the global variable for displaying
    });
    textAnimation(); // Start a text animation between searches
    // ---- Save Data to History -------
    var artistName = jsonObject["result"]["artist"]["name"]; // Get the name of the artist from the response object
    var songName = jsonObject["result"]["track"]["name"]; // Get the name of the song from the response object
    var songLyrics = jsonObject["result"]["track"]["text"]; // Get the lyrics of the song from the response object
    var now = new DateTime.now();
    var date = new DateTime(now.year, now.month, now.day, now.hour, now.minute); // Get the current date and time
    saveToHistory(artistName, songName, songLyrics, date); // Save to local storage the artist, song name, lyrics and date (To display on history page)
  }

  // This function saves the a search query to the local storage (using Shared Preferences), to display later on history page
  saveToHistory(String artist, String songName, String lyrics, dynamic date) async {
    final prefs = await SharedPreferences.getInstance();
    final lastHistory = prefs.getStringList('history'); // get the current search history from local storage
    if (lastHistory == null) {
      prefs.setStringList('history', [artist, songName, lyrics, date.toString()]); // if history is empty the current query will be saved solo
    }
    else {
      lastHistory.addAll([artist, songName, lyrics, date.toString()]); // Save the current query to the history
      prefs.setStringList('history', lastHistory); // save the new history
    }
  }

  textAnimation() async {
    setState(() {
      textState = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      textState = false;
    });
  }

  showAlertDialog(String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error!"),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () => {
              Navigator.pop(context)
            },
          )
        ],
        elevation: 24.0,
      ),
      barrierDismissible: true,
    );
  }

  @override
  void dispose(){
    artistTextController.dispose();
    songTextController.dispose();
    slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Songs Lyrics App"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.blueAccent,
                Colors.blue,
                Colors.lightBlue,
                Colors.lightBlueAccent,
              ]
            )
          ),
        ),
      ),
      body:
      SlideTransition(
        position: slideOffsetAnimation,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          children: <Widget>[
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Artist",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14),
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "Enter artist name",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.6,
                                      )
                                  )
                              ),
                              controller: artistTextController,
                            ),
                            SizedBox(height: 30,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Song",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 20),),
                            ),
                            SizedBox(height: 14,),
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "Enter song name",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.6
                                      )
                                  )
                              ),
                              controller: songTextController,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              child: OutlineButton(
                                child: Text("Get lyrics"),
                                onPressed: () => getLyrics(),
                                highlightedBorderColor: Colors.black,
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Container(
                              //padding: const EdgeInsets.only(top: 15, bottom: 15),
                              margin: const EdgeInsets.only(top: 2.0, bottom: 8),
                              width: MediaQuery.of(context).size.width,
                              height: 2,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        //height: 340,
                        height: MediaQuery.of(context).size.height * 0.442,
                        child: AnimatedPadding(
                          padding: EdgeInsets.all(textBoxPaddingValue),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: textBoxColor,
                                    width: 2.8
                                )
                            ),
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.8,
                              minChildSize: 0.8,
                              builder: (BuildContext context, ScrollController scrollController){
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 540),
                                    curve: Curves.easeInOut,
                                    style: textState ? TextStyle(
                                      fontSize: 22,
                                      //fontWeight: FontWeight.w900
                                    )
                                        : TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black
                                    ),
                                    child: Text(
                                      '$lyrics\n\n\n\n',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
