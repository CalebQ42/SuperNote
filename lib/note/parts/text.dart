import 'package:flutter/material.dart';
import 'package:styled_text/widgets/styled_text.dart';

import 'package:supernote/note/note.dart';

class TextNotePart extends NotePart {
  String value;

  TextNotePart({this.value = "", Offset pos = const Offset(0, 0)}) {
    super.pos = pos;
  }

  @override
  Widget widget() =>
    StyledText(
      text: value,
    );
}
