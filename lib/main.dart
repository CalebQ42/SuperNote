import 'package:flutter/material.dart';

import 'package:supernote/note/note.dart';
import 'package:supernote/note/parts/text_part.dart';
import 'package:supernote/ui/note_canvas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var testNote = Note(title: "This is a test", parts: {
      (0, 0): [
        TextNotePart(
          value: "Hello world",
          zHeight: 1,
        )
      ],
      (1, 2): [
        TextNotePart(
          value:
              "Hello world, this is a message that is long enough it extends past section boundries. Hopefully this works.",
          pos: Offset(100, 200),
          zHeight: 0,
        ),
      ]
    });
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NoteCanvas(note: testNote),
        ),
      ),
    );
  }
}
