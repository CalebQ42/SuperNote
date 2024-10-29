import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';
import 'package:uuid/uuid.dart';

class Note {
  late String id;
  String title;
  // <100px by 100px section (x, y), Notes in section>
  Map<(int, int), List<NotePart>> parts = {};
  Set<int> zHeights = {};

  Note({this.title = "", List<NotePart>? parts, String? id}) {
    if (id == null) {
      this.id = Uuid().v7();
    }
    if (parts != null) {
      for (var p in parts) {
        add(p);
      }
    }
  }

  void add(NotePart part) {
    var x = (part.pos.dx / 100).floor();
    var y = (part.pos.dy / 100).floor();
    while (zHeights.contains(part.zHeight)) {
      part.zHeight++;
    }
    zHeights.add(part.zHeight);
    if (parts[(x, y)] == null) {
      parts[(x, y)] = [part];
    } else {
      parts[(x, y)]!.add(part);
    }
  }

  void movePart(NotePart part, Offset newPos) {
    var ogX = (part.pos.dx / 100).floor();
    var ogY = (part.pos.dy / 100).floor();
    var newX = (newPos.dx / 100).floor();
    var newY = (newPos.dy / 100).floor();
    if (ogX == newX && ogY == newY) {
      return;
    }
    if (parts[(ogX, ogY)] != null) {
      parts[(ogX, ogY)]!.remove(part);
      if (parts[(ogX, ogY)]!.isEmpty) parts.remove((ogX, ogY));
    }
    if (parts[(newX, newY)] == null) {
      parts[(newX, newY)] = [part];
    } else {
      parts[(newX, newY)]!.add(part);
    }
  }

  void save(/* TODO */) {
    //TODO
  }
}
