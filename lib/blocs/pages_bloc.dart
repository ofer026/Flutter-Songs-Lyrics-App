import 'package:flutter/material.dart';

class DisplayManagment extends ChangeNotifier {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  Map<int, Color> _backgroundColors = {0: Colors.blueAccent, 1: Colors.indigoAccent};
  Map<int, Color> get backgroundColors => _backgroundColors;

  changeIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

}