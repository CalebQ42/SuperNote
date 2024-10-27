import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';
import 'package:supernote/ui/parts/text_widget.dart';

class TextNotePart extends NotePart {
  //TODO: change value to an advanced formatting format.
  String value;

  bool manualWidth;

  FocusNode fn = FocusNode();

  TextNotePart({
    required super.parent,
    this.value = "",
    super.pos,
    super.size,
    super.zHeight,
    this.manualWidth = false,
  });

  @override
  Widget widget() => TextNoteWidget(key: ValueKey(id), note: this);
}
