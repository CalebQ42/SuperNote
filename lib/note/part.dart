import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

mixin UniquePositionedWidget {
  String id = Uuid().v7();
  Offset pos = const Offset(0, 0.0);
  Size size = const Size(50.0, 50.0);
  double scale = 1.0;
  int zHeight = 0;

  Widget widget();
}

abstract class NotePart with UniquePositionedWidget {
  NotePart({
    pos = const Offset(0, 0),
    size = const Size(300.0, 300.0),
    scale = 1.0,
    String? id,
  }) {
    if (id != null) this.id = id;
    this.pos = pos;
    this.size = size;
    this.scale = scale;
  }

  @override
  Widget widget() {
    return view();
  }

  Widget view();
}
