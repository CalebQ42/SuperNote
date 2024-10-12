import 'package:flutter/material.dart';
import 'package:supernote/ui/infinite_canvas.dart';
import 'package:uuid/uuid.dart';

abstract class NotePart with UniqueZHeightWidget {
  @override
  String id = Uuid().v7();
  Offset pos;
  Size size;
  double scale;
  @override
  int zHeight;
  bool manualSize;
  @override
  bool isFocused;

  NotePart({
    String? id,
    this.pos = const Offset(0, 0),
    this.size = const Size(300.0, 300.0),
    this.scale = 1.0,
    this.zHeight = 0,
    this.manualSize = false,
    this.isFocused = false,
  }) {
    if (id != null) this.id = id;
  }
}
