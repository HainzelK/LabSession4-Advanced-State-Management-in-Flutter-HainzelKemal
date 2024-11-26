import 'package:flutter/material.dart';
import 'package:global_state_manager/global_state_manager.dart';  // Import your global state manager package

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GlobalState globalState; // Declare the GlobalState object

  @override
  void initState() {
    super.initState();
    globalState = GlobalState(); // Initialize GlobalState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Global State Counter App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the list of counters dynamically
              for (int i = 0; i < globalState.counters.length; i++) ...[
                Text(
                  'Counter ${i + 1}: ${globalState.counters[i].counter}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          globalState.incrementCounter(globalState.counters[i]);
                        });
                      },
                      child: Text('Increment'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: globalState.counters[i].counter == 0
                          ? null
                          : () {
                              setState(() {
                                globalState.decrementCounter(globalState.counters[i]);
                              });
                            },
                      child: Text('Decrement'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Remove the counter at the given index
                          globalState.removeCounter(globalState.counters[i]);
                        });
                      },
                      child: Text('Remove Counter'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
              
              // Button to add a new counter with a label
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    globalState.addCounter('Counter ${globalState.counters.length + 1}');
                  });
                },
                child: Text('Add New Counter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
