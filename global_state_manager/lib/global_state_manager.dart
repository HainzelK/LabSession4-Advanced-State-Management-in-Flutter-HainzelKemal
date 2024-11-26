library global_state_manager;

import 'package:flutter/material.dart';

/// A class to manage a list of counters using ChangeNotifier.
class GlobalState extends ChangeNotifier {
  // List to hold all the counters
  final List<CounterItem> _counters = [];

  /// Get the list of all counters.
  List<CounterItem> get counters => _counters;

  /// Add a new counter with an initial value.
  void addCounter(String label) {
    _counters.add(CounterItem(label: label)); // Add a new counter with a given label
    notifyListeners(); // Notify listeners to rebuild the UI
  }
  void removeCounter(CounterItem counterItem) {
    _counters.remove(counterItem);  // Removes the counter from the list
    notifyListeners();  // Notify listeners to rebuild the UI
  }

  /// Increment a specific counter.
  void incrementCounter(CounterItem counterItem) {
    counterItem.increment();
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  /// Decrement a specific counter.
  void decrementCounter(CounterItem counterItem) {
    counterItem.decrement();
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}

/// A class representing an individual counter item.
class CounterItem {
  final String label;
  int counter;

  CounterItem({required this.label, this.counter = 0});

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
}
