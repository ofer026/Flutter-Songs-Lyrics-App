import 'package:flutter/material.dart';
import 'package:songslyricsapp/pages/history.dart';

class AppDrawer extends StatelessWidget {
  
  route(BuildContext context) {
    var route = MaterialPageRoute(
        builder: (context) => HistoryPage()
    );
    Navigator.push(context, route);
  }
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      Colors.lightBlueAccent,
                      Colors.blue
                    ]
                )
            ),
            child: Container(
              child: Text("Songs Lyrics App",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0
                ),),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0,
                    color: Colors.black
                )
            ),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.search, color: Colors.black,),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text('Lyrics Search', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 14.0),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0,
                    color: Colors.black
                )
            ),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.history, color: Colors.black,),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text('History', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),),
                  )
                ],
              ),
              onTap: () => {
                route(context)
              },
            ),
          )
        ],
      ),
    );
  }
}