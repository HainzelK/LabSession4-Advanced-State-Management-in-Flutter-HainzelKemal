import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:dotted_border/dotted_border.dart';
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
  List<int> dragIndexes = [];  // To track the drag item indexes

  @override
  void initState() {
    super.initState();
    globalState = GlobalState(); // Initialize GlobalState
  }

  // Method to cycle through colors for a counter
  Color getNextColor(Color currentColor) {
    List<Color> colors = Colors.primaries;
    int currentIndex = colors.indexOf(currentColor);
    return colors[(currentIndex + 1) % colors.length];
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
              // Display the list of counters dynamically with drag-and-drop
              for (int i = 0; i < globalState.counters.length; i++) ...[
                DragItemWidget(
                  dragItemProvider: (request) async {
                    final item = DragItem(localData: {'index': i});
                    item.add(Formats.plainText('Counter $i'));
                    return item;
                  },
                  allowedOperations: () => [DropOperation.copy],
                  child: DraggableWidget(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: globalState.counters[i].color,
                      child: Column(
                        children: [
                          Text(
                            'Counter ${i + 1}: ${globalState.counters[i].counter}',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 10,  // Space between buttons
                            runSpacing: 10,  // Space between rows
                            alignment: WrapAlignment.center,  // Align buttons in the center
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    globalState.incrementCounter(globalState.counters[i]);
                                  });
                                },
                                child: Text('Increment'),
                              ),
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
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    globalState.changeCounterColor(
                                      globalState.counters[i],
                                      getNextColor(globalState.counters[i].color),
                                    );
                                  });
                                },
                                child: Text('Change Color'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    globalState.removeCounter(globalState.counters[i]);
                                  });
                                },
                                child: Text('Remove Counter'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Drop region for counters with DottedBorder
              DropRegion(
                formats: Formats.standardFormats,
                hitTestBehavior: HitTestBehavior.opaque,
                onDropOver: (event) {
                  final item = event.session.items.first;
                  final localData = item.localData;  // Retrieve local data safely

                  if (localData is Map) {
                    final index = localData['index'] as int?;

                    if (index != null) {
                      // Handle drop over event logic
                      return DropOperation.copy;
                    }
                  }
                  return DropOperation.none;
                },

                onPerformDrop: (event) async {
                  final item = event.session.items.first;
                  final reader = item.dataReader!;

                  if (reader.canProvide(Formats.plainText)) {
                    reader.getValue<String>(Formats.plainText, (value) {
                      if (value != null) {
                        // Get the dropped item data
                        final droppedLocalData = event.session.items.first.localData;
                        if (droppedLocalData is Map) {
                          final droppedIndex = droppedLocalData['index'] as int?;

                          if (droppedIndex != null) {
                            // Reordering based on drop position
                            final dropIndex = _getDropIndex();
                            if (dropIndex != null) {
                              setState(() {
                                final movedCounter = globalState.counters.removeAt(droppedIndex);
                                globalState.counters.insert(dropIndex, movedCounter);
                              });
                              print('Counters reordered');
                            }
                          }
                        }
                      }
                    }, onError: (error) {
                      print('Error reading value $error');
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(6),
                    color: Colors.blue,
                    strokeWidth: 2,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Center(child: Text('Drop items here to reorder')),
                    ),
                  ),
                ),
              ),

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

  // Helper function to get the drop index based on visual position
  int? _getDropIndex() {
    final lastCounter = globalState.counters.last;
    // Get the current index of the last counter. Can be updated to handle complex layouts.
    final lastIndex = globalState.counters.indexOf(lastCounter);
    return lastIndex;
  }
}
