import 'package:flutter/material.dart';

class Note {
  String title = "";

  // <100px by 100px section (x, y), Notes in section>
  Map<(int, int), List<NotePart>?> parts = {};
}

mixin NotePart {
  Offset pos = const Offset(0, 0);

  Widget widget();
}
