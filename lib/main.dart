import 'package:flutter/material.dart';

import 'package:supernote/note/note.dart';
import 'package:supernote/note/parts/text.dart';
import 'package:supernote/ui/note_canvas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var testNote = Note(
      title: "This&space;is&space;a&space;test",
      parts: {
        (0, 0): [TextNotePart(value: "This&space;is&space;a&space;test")]
      }
    );
    return MaterialApp(
      home: Scaffold(
        body: Center(child: NoteCanvas(testNote)),
      ),
    );
  }
}
