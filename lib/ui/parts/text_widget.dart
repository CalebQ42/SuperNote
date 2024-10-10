import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

import 'package:supernote/note/parts/text_part.dart';
import 'package:supernote/ui/parts/border.dart';

class TextNoteWidget extends StatefulWidget {
  final TextNotePart note;

  const TextNoteWidget({super.key, required this.note});

  @override
  State<TextNoteWidget> createState() => _TextNoteWidgetState();
}

class _TextNoteWidgetState extends State<TextNoteWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.note.pos.dy,
      left: widget.note.pos.dx,
      height: widget.note.size.height,
      width: widget.note.size.width,
      child: NotePartBorder(
        child: ,
      ),
    );
  }
}
