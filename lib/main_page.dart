import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songslyricsapp/pages/history.dart';
import 'package:songslyricsapp/blocs/pages_bloc.dart';
import 'package:songslyricsapp/pages/search_page(home).dart';

class MainScaffold extends StatelessWidget {

  final scrollController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final DisplayManagment displayManagment = Provider.of<DisplayManagment>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageView(
          onPageChanged: (index) => {
            displayManagment.changeIndex(index)
          },
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          children: [
            MyHomePage(title: 'Songs Lyrics App'),
            HistoryPage()
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: displayManagment.pageIndex,
        //fixedColor: Colors.green,
        //backgroundColor: displayManagment.backgroundColors[displayManagment.pageIndex],
        //backgroundColor: ,
        elevation: 200,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.blueAccent
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('History'),
              backgroundColor: Colors.indigoAccent,
          )
        ],
        onTap: (index) => {
          displayManagment.changeIndex(index),
          scrollController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)
        },
      ),
    );
  }

}