import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songslyricsapp/blocs/pages_bloc.dart';
import 'package:songslyricsapp/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DisplayManagment>.value(
            value: DisplayManagment()
        )
      ],
      child: MaterialApp(
        title: 'Songs Lyrics App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScaffold(),
      ),
    );
  }
}

