import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: InteractiveImage(),
    );
  }
}

class InteractiveImage extends StatefulWidget {
  @override
  _InteractiveImageState createState() => _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> {
  bool leafIsCorrect = false;
  bool rootIsCorrect = false;
  final leafOffset = ValueNotifier<Offset>(Offset(20, 50));
  final rootOffset = ValueNotifier<Offset>(Offset(20, 100));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('assets/tree.png'),
          DraggableOption(
            text: 'Leaf',
            initialOffset: leafOffset.value,
            isCorrect: leafIsCorrect,
          ),
          DraggableOption(
            text: 'Root',
            initialOffset: rootOffset.value,
            isCorrect: rootIsCorrect,
          ),



          DropArea(
            targetOffset: Offset(150, 150),
            onAccept: (String data) {
              if (data == 'Leaf') {
                leafOffset.value = Offset(150, 150);
                setState(() {
                  leafIsCorrect = true;
                });
              }
            },
          ),
          DropArea(
            targetOffset: Offset(250, 250),
            onAccept: (String data) {
              if (data == 'Root') {
                rootOffset.value = Offset(250, 250);
                setState(() {
                  rootIsCorrect = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}


class DraggableOption extends StatefulWidget {
  final String text;
  final ValueNotifier<Offset> currentOffset;
  final bool isCorrect;

  DraggableOption({
    Key? key,
    required this.text,
    required Offset initialOffset,
    required this.isCorrect,
  })  : currentOffset = ValueNotifier<Offset>(initialOffset),
        super(key: key);

  @override
  _DraggableOptionState createState() => _DraggableOptionState();
}

class _DraggableOptionState extends State<DraggableOption> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentOffset,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Positioned(
          left: value.dx,
          top: value.dy,
          child: Draggable<String>(
            data: widget.text,
            feedback: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(widget.text),
            ),
            childWhenDragging: Container(),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isCorrect ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(widget.text),
            ),
          ),
        );
      },
    );
  }
}


class DropArea extends StatelessWidget {
  final Offset targetOffset;
  final Function(String) onAccept;

  const DropArea({Key? key, required this.targetOffset, required this.onAccept}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: targetOffset.dx,
      top: targetOffset.dy,
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 100,
            height: 100,
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: onAccept,
      ),
    );
  }
}

