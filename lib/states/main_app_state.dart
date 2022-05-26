import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainAppState extends ChangeNotifier
{
  int buttomPageIndex = 0;

  void setButtomPageIndex(int index) {
    this.buttomPageIndex = index;

    notifyListeners();
  }

  int get getButtomPageIndex => buttomPageIndex;
}