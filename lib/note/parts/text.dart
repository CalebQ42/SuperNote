import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';

class TextNotePart extends NotePart {
  String value;

  FocusNode fn = FocusNode();

  TextNotePart({
    this.value = "",
    super.pos,
    super.size,
  });
}

class TextNoteWidget extends StatelessWidget {
  final TextNotePart note;

  const TextNoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        border: UnderlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
