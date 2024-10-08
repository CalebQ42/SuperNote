import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';

class TextNotePart extends NotePart {
  String value;

  TextNotePart({
    this.value = "",
    super.pos,
    super.size,
  });

  @override
  Widget view() {
    print(value);
    return Text(
      value,
    );
  }
}
