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
}

class NotePartBorder extends StatefulWidget {
  final NotePart note;

  const NotePartBorder({super.key, required this.note});

  @override
  State<StatefulWidget> createState() => _NotePartBorderState();
}

class _NotePartBorderState extends State<NotePartBorder> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    Decoration? deco;
    if (isFocused) {
      deco = BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      );
    }
    return Focus(
      onFocusChange: (b) {
        if (b != isFocused) {
          setState(() => isFocused = b);
          if (b) {
            widget.note.onFocus();
          }
        }
      },
      skipTraversal: false,
      descendantsAreFocusable: true,
      descendantsAreTraversable: true,
      child: Container(
        padding: isFocused ? EdgeInsets.all(4) : EdgeInsets.all(5),
        decoration: deco,
        child: widget.note.view(),
      ),
    );
  }
}
