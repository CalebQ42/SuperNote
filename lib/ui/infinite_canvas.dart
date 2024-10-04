import 'package:flutter/material.dart';

class InfiniteCanvas extends StatefulWidget {
  final List<Widget> Function((int, int)) getWidgets;

  const InfiniteCanvas({super.key, required this.getWidgets});

  @override
  State<StatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends State<InfiniteCanvas> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
