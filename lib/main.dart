import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/rendering.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songs Lyrics App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Songs Lyrics App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState();
  String textToDisplayOnAlert = "";

  String lyrics = "";

  Color textBoxColor = Colors.white;

  double textBoxPaddingValue = 200;

  final String baseURL = "https://orion.apiseeds.com/api/music/lyric/";
  final String APIKey = "h4u5fEvPpoCj01LEObdL3oZSkT1m11XmdvLL3KeyXrkR0mTLIZOCvcze9HkcdSVW";

  final artistTextController = TextEditingController();
  final songTextController = TextEditingController();

  getLyrics() async {
    String artist = artistTextController.text.toString();
    String song = songTextController.text.toString();

    if(artist == '' || song == '') {
      setState(() {
        textToDisplayOnAlert = "One of the fields is empty!";
      });
      showAlertDialog(textToDisplayOnAlert);
      return;
    }

    var request = await HttpClient().getUrl(Uri.parse(baseURL + "$artist/$song?apikey=$APIKey"));
    var response = await request.close();
    String content = "";
    await for(var contents in response.transform(Utf8Decoder())) {
      content += contents;
    }
    //print(content);
    if(content == "{\"error\":\"Lyric no found, try again later.\"}") {
      //TODO: Show an error msg on screen
      print("Error! song not found!");
      setState(() {
        textToDisplayOnAlert = "Song not found!";
      });
      showAlertDialog(textToDisplayOnAlert);
      return;
    }
    dynamic jsonObject = jsonDecode(content);
    setState(() {
      if (lyrics == "") {
        textBoxPaddingValue = 0.0;
        textBoxColor = Colors.blue;
      }
      lyrics = jsonObject["result"]["track"]["text"];
      lyrics += "\n\n\n";
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Songs Lyrics App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      decoration: InputDecoration(hintText: "Enter artist name"),
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
                      decoration: InputDecoration(hintText: "Enter song name"),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 410,
                      child: AnimatedPadding(
                        padding: EdgeInsets.all(textBoxPaddingValue),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: textBoxColor,
                              width: 1.0
                            )
                          ),
                          child: DraggableScrollableSheet(
                            initialChildSize: 0.8,
                            minChildSize: 0.8,
                              builder: (BuildContext context, ScrollController scrollController){
                                return SizedBox(
                                  //height: double.infinity,
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Text(
                                      '$lyrics',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),
                      ),
                    ),
                    /*
                    isDisplayAlert ? showAlertDialog(textToDisplayOnAlert) : Container(
                      color: Colors.white,
                    )*/
                  ],
                ),
            ),
            )
          ],
        ),
      ),

    );
  }
}
/*
class Alert extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

  }

}


class alert extends StatefulWidget{
  bool isDisplay;
  String textToDisplay;

  alert(bool isDisplay, String textToDisplay){
    this.isDisplay = isDisplay;
    this.textToDisplay = textToDisplay;
  }

  @override
  State<StatefulWidget> createState() {
    _alertState(this.isDisplay, this.textToDisplay);
  }}

  class _alertState extends State<alert>{
    bool isDisplay;
    String textToDisplay;

    _alertState(bool isToDisplay, String textToDisplay) {
      this.isDisplay = isToDisplay;
      this.textToDisplay = textToDisplay;
    }

    close(){
      setState(() {
        this.isDisplay = false;
      });
    }

    @override
    Widget build(BuildContext context) {
      return isDisplay ? AlertDialog(content: Text(this.textToDisplay),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close, color: Colors.black,),
            onPressed: () => close(),
          )
        ],)
        : SizedBox(
        height: 1,
        width: 1,
      );
    }
  }

 */

  /*
  class Alert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(content: Text(this.),)
  }

  }
   */
