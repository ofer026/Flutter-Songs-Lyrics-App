import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  Future<List<List<String>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final fullHistory = prefs.getStringList('history');
    if (fullHistory == null) {
      return [];
    }
    List<List<String>> history= [];
    for (int i = 0; i < fullHistory.length; i += 4) {
      history.add(fullHistory.sublist(i, i + 4));
    }
    await Future.delayed(const Duration(milliseconds: 200));
    return history;
  }

  showLyrics(BuildContext context, String lyrics, String artist, String song) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
              '$artist - $song',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w400
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Text(
                  '$lyrics',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            iconSize: 30.0,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setStringList('history', null);
              setState(() {}); // refresh the page after deletion fo history
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0),
        child: FutureBuilder(
          future: getHistory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var history = snapshot.data;
              return ListView(
                children: <Widget>[for (var search in history) Container(
                margin: const EdgeInsets.only(bottom: 6.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black
                      )
                    ),
                  child: ListTile(
                    title: Text(
                        '${search[0]} - ${search[1]}',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),
                    ),
                    subtitle: Text(
                      '${search[3].replaceFirst(':00.000', '')}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      showLyrics(context, search[2], search[0], search[1]);
                    },
                  ),
                  )
                ],
              );
            }
            else {
              return Center(child: SizedBox(width: 300, height: 300,child: CircularProgressIndicator()));
            }
          }
        ),
      ),
    );
  }
}
