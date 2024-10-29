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
    Note testNote = Note();
    testNote.add(TextNotePart(
      parent: testNote,
      value: "Hello world",
    ));
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NoteCanvas(note: testNote),
        ),
      ),
    );
  }
}
