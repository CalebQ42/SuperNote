import 'package:flutter/material.dart';

abstract class NotePart {
  Offset pos = const Offset(0, 0.0);
  Size size = const Size(50.0, 50.0);
  double scale = 1.0;

  Widget view();
}
