import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';
import 'package:supernote/ui/parts/text_widget.dart';

class TextNotePart extends NotePart {
  String value;

  FocusNode fn = FocusNode();

  TextNotePart({this.value = "", super.pos, super.size, super.zHeight});

  @override
  Widget widget() => TextNoteWidget(key: ValueKey(id), note: this);
}
