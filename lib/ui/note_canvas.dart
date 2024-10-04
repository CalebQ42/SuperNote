import 'package:flutter/material.dart';
import 'package:supernote/note/note.dart';

class NoteCanvas extends StatelessWidget {
  final Note note;

  const NoteCanvas(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(note.title);
  }
}
