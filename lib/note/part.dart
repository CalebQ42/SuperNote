import 'package:flutter/material.dart';
import 'package:supernote/note/note.dart';
import 'package:uuid/uuid.dart';

abstract class NotePart {
  late final String id;
  int zHeight;
  bool isFocused;
  bool isDragging = false;

  Offset _pos = Offset(0, 0);
  Size _size = Size(100, 100);

  final Note parent;

  NotePart({
    String? id,
    required this.parent,
    Offset pos = const Offset(0, 0),
    Size size = const Size(300.0, 300.0),
    this.zHeight = 0,
    this.isFocused = false,
  }) {
    if (id == null) this.id = Uuid().v7();
    _pos = pos;
    _size = size;
  }

  Widget widget();

  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (var i = 0; i < _listeners.length; i++) {
      _listeners[i]();
    }
  }

  Offset get pos => _pos;
  Size get size => _size;

  set pos(Offset pos) {
    parent.movePart(this, pos);
    _pos = pos;
    notifyListeners();
  }

  set size(Size size) {
    _size = size;
    notifyListeners();
  }
}
