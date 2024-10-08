import 'package:flutter/material.dart';

import 'package:supernote/note/note.dart';
import 'package:supernote/note/parts/text.dart';
import 'package:supernote/ui/infinite_canvas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var testNote = Note(title: "This&space;is&space;a&space;test", parts: {
      (0, 0): [
        TextNotePart(
          value:
              "Hello world, this is a message that is long enough it extends past section boundries. Hopefully this works.",
        )
      ],
      (0, 10): [
        TextNotePart(
            value:
                "Hello world, this is a message that is long enough it extends past section boundries. Hopefully this works.",
            pos: Offset(0, 1000))
      ]
    });
    return MaterialApp(
      home: Scaffold(body: Center(
        child: InfiniteCanvas(
          getWidgets: (x, y) {
            return testNote.parts[(x, y)];
          },
        ),
      )),
    );
  }
}
