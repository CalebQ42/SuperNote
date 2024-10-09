import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

import 'package:supernote/note/parts/text_part.dart';
import 'package:supernote/ui/parts/border.dart';

class TextNoteWidget extends StatefulWidget {
  final TextNotePart note;

  const TextNoteWidget({super.key, required this.note});

  @override
  State<TextNoteWidget> createState() => _TextNoteWidgetState();
}

class _TextNoteWidgetState extends State<TextNoteWidget> {
  late RichTextEditorController myController;

  @override
  void initState() {
    super.initState();
    myController = RichTextEditorController(text: widget.note.value);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      myController.toggleBold();
      print("yoggle");
    });
    return Positioned(
      top: widget.note.pos.dy,
      left: widget.note.pos.dx,
      height: widget.note.size.height,
      width: widget.note.size.width,
      child: NotePartBorder(
        child: RichTextField(
          maxLines: null,
          controller: myController,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            border: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
