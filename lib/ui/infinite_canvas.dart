import 'dart:math';

import 'package:flutter/material.dart';
import 'package:single_child_two_dimensional_scroll_view/single_child_two_dimensional_scroll_view.dart';
import 'package:supernote/note/part.dart';

class InfiniteCanvas extends StatefulWidget {
  final List<NotePart>? Function(int, int) getWidgets;

  const InfiniteCanvas({super.key, required this.getWidgets});

  @override
  State<StatefulWidget> createState() => InfiniteCanvasState();
}

class InfiniteCanvasState extends State<InfiniteCanvas> {
  final int cellsMax = 1000000000000000;

  int toLoad = 50;
  int x = 0;
  int y = 0;

  late ScrollController horizontal;
  late ScrollController vertical;

  GlobalKey<InfiniteStackState> stack = GlobalKey();

  void updateLoaded({int? newLoaded}) async {
    var newY = (vertical.offset / 100).floor();
    var newX = (horizontal.offset / 100).floor();
    if (newX == x && newY == y) {
      if (newLoaded == null) {
        return;
      } else if (newLoaded == toLoad) {
        return;
      }
    }
    newLoaded ??= toLoad;
    Set<NotePart> newSet = {};
    // Check for complete removal.
    for (var xVal = max(0, newX - newLoaded);
        xVal <= min(cellsMax, newX + newLoaded);
        xVal++) {
      for (var yVal = max(0, newY - newLoaded);
          yVal <= min(cellsMax, newY + newLoaded);
          yVal++) {
        var wids = widget.getWidgets(xVal, yVal);
        if (wids != null) {
          newSet.addAll(wids);
        }
      }
    }
    stack.currentState?.newSet(newSet);
  }

  @override
  void initState() {
    super.initState();
    horizontal = ScrollController();
    horizontal.addListener(updateLoaded);
    vertical = ScrollController();
    vertical.addListener(updateLoaded);
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    toLoad = (max(sz.width, sz.height) / 100).ceil() * 5;
    Set<NotePart> init = {};
    for (var xLoad = x; xLoad <= x + toLoad; xLoad++) {
      for (var yLoad = y; yLoad < y + toLoad; yLoad++) {
        var wids = widget.getWidgets(xLoad, yLoad);
        if (wids != null) {
          init.addAll(wids);
        }
      }
    }
    return SingleChildTwoDimensionalScrollView(
      horizontalController: horizontal,
      verticalController: vertical,
      padding: EdgeInsets.all(10),
      child: SizedBox.square(
        dimension: cellsMax * 100,
        child: InfiniteStack(key: stack, initChildren: init),
      ),
    );
  }
}

class InfiniteStack extends StatefulWidget {
  final Set<NotePart>? initChildren;

  const InfiniteStack({super.key, this.initChildren});

  @override
  State<StatefulWidget> createState() => InfiniteStackState();
}

class InfiniteStackState extends State<InfiniteStack> {
  Set<NotePart> children = {};

  @override
  void initState() {
    super.initState();
    children = widget.initChildren ?? {};
  }

  void newSet(Set<NotePart> newParts) {
    var toRem = children.difference(newParts);
    var toAdd = newParts.difference(children);
    if (toRem.isEmpty && toAdd.isEmpty) return;
    setState(() {
      children.removeAll(toRem);
      children.addAll(toAdd);
    });
  }

  @override
  Widget build(BuildContext context) {
    var chilList = children.toList();
    chilList.sort((a, b) => a.zHeight.compareTo(b.zHeight));
    return Stack(
      children: chilList.map((e) => e.widget()).toList(),
    );
  }
}
