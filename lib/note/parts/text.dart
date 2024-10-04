import 'package:flutter/material.dart';

import 'package:supernote/note/note.dart';

class TextNotePart with NotePart{
  String value = "";

  @override
  Widget widget() => Text(value);
}
