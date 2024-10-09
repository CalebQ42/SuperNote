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
      home: Scaffold(
        body: Center(
          child: NoteCanvas(note: testNote),
        ),
      ),
    );
  }
}
