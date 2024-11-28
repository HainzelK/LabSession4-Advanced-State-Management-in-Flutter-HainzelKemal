library global_state_manager;

import 'package:flutter/material.dart';


/// A class representing an individual counter item with a customizable color.
class CounterItem {
  final String label;
  int counter;
  Color color;

  CounterItem({required this.label, this.counter = 0, this.color = Colors.black});

  /// Increment the counter by 1.
  void increment() {
    counter++;
  }

  /// Decrement the counter by 1, ensuring it doesn't go below 0.
  void decrement() {
    if (counter > 0) {
      counter--;
    }
  }

  /// Change the color of the counter.
  void changeColor(Color newColor) {
    color = newColor;
  }
}

class GlobalState extends ChangeNotifier {
  final List<CounterItem> _counters = [];

  List<CounterItem> get counters => _counters;

  void addCounter(String label) {
    _counters.add(CounterItem(label: label)); 
    notifyListeners(); 
  }

  void removeCounter(CounterItem counterItem) {
    _counters.remove(counterItem);
    notifyListeners();
  }

  void incrementCounter(CounterItem counterItem) {
    counterItem.increment();
    notifyListeners();
  }

  void decrementCounter(CounterItem counterItem) {
    counterItem.decrement();
    notifyListeners();
  }

  void changeCounterColor(CounterItem counterItem, Color color) {
    counterItem.changeColor(color);
    notifyListeners();
  }
}
