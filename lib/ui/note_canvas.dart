import 'package:flutter/material.dart';
import 'package:supernote/note/note.dart';
import 'package:supernote/ui/infinite_canvas.dart';

class NoteCanvas extends StatelessWidget {
  final Note note;

  const NoteCanvas({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return InfiniteCanvas(getWidgets: (x, y) {
      return note.parts[(x, y)];
    });
  }
}
