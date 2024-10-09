import 'dart:math';

import 'package:flutter/material.dart';
import 'package:single_child_two_dimensional_scroll_view/single_child_two_dimensional_scroll_view.dart';

mixin UniqueZHeightWidget {
  String get id;
  int get zHeight;

  Widget widget();
}

class InfiniteCanvas extends StatefulWidget {
  final List<UniqueZHeightWidget>? Function(int, int) getWidgets;

  const InfiniteCanvas({super.key, required this.getWidgets});

  @override
  State<StatefulWidget> createState() => InfiniteCanvasState();
}

class InfiniteCanvasState extends State<InfiniteCanvas> {
  late int toLoad;
  late (int, int) xLoaded;
  late (int, int) yLoaded;

  ScrollController? horizontal;
  ScrollController? vertical;

  GlobalKey<InfiniteStackState> stack = GlobalKey();

  void updateXLoaded((int, int) newValues) {}

  void updateYLoaded((int, int) newValues) {}

  void updateXAndYLoaded((int, int) newX, (int, int) newY) async {
    if (newX == xLoaded && newY == yLoaded) return;
    List<String> toRem = [];
    List<UniqueZHeightWidget> toAdd = [];
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    var newToLoad = (max(sz.width, sz.height) / 100).ceil() * 5;
    if (horizontal == null) {
      toLoad = newToLoad;
      xLoaded = (0, toLoad);
      yLoaded = (0, toLoad);
    } else {
      //TODO: figure out how many we need to load, and do so.
    }
    if (horizontal == null) {
      horizontal = ScrollController();
      horizontal!.addListener(() async {
        var curSec = (vertical!.offset / 100).floor();
        var newLoadedLow = curSec - toLoad;
        var newLoadedHigh = curSec + toLoad;
        if (newLoadedLow < 0) newLoadedLow = 0;
        if (newLoadedLow == xLoaded.$1 && newLoadedHigh == xLoaded.$2) return;
        List<String> toRem = [];
        List<UniqueZHeightWidget> toAdd = [];
        if (newLoadedLow > xLoaded.$1) {
          for (var x = xLoaded.$1; x < newLoadedLow; x++) {
            for (var y = yLoaded.$1; y <= yLoaded.$2; y++) {
              var r = widget.getWidgets(y, x);
              if (r != null) {
                for (var w in r) {
                  toRem.add(w.id);
                }
              }
            }
          }
        } else if (newLoadedLow < xLoaded.$1) {
          for (var x = newLoadedLow; x < xLoaded.$1; x++) {
            for (var y = yLoaded.$1; y <= yLoaded.$2; y++) {
              var r = widget.getWidgets(y, x);
              if (r != null) {
                toAdd.addAll(r);
              }
            }
          }
        }
        if (newLoadedHigh > xLoaded.$2) {
          for (var x = xLoaded.$2 + 1; x <= newLoadedHigh; x++) {
            for (var y = yLoaded.$1; y <= yLoaded.$2; y++) {
              var r = widget.getWidgets(y, x);
              if (r != null) {
                toAdd.addAll(r);
              }
            }
          }
        } else if (newLoadedHigh < xLoaded.$2) {
          for (var x = newLoadedHigh; x <= xLoaded.$2; x++) {
            for (var y = yLoaded.$1; y <= yLoaded.$2; y++) {
              var r = widget.getWidgets(y, x);
              if (r != null) {
                for (var w in r) {
                  toRem.add(w.id);
                }
              }
            }
          }
        }
        xLoaded = (newLoadedLow, newLoadedHigh);
        stack.currentState?.addAndRemove(toAdd, toRem);
      });
    }
    if (vertical == null) {
      vertical = ScrollController();
      vertical!.addListener(() async {
        var curSec = (vertical!.offset / 100).floor();
        var newLoadedLow = curSec - toLoad;
        var newLoadedHigh = curSec + toLoad;
        if (newLoadedLow < 0) newLoadedLow = 0;
        List<String> toRem = [];
        List<UniqueZHeightWidget> toAdd = [];
        if (newLoadedLow == yLoaded.$1 && newLoadedHigh == yLoaded.$2) return;
        if (newLoadedLow > yLoaded.$1) {
          for (var y = yLoaded.$1; y < newLoadedLow; y++) {
            for (var x = xLoaded.$1; x <= xLoaded.$2; x++) {
              var r = widget.getWidgets(x, y);
              if (r != null) {
                for (var w in r) {
                  toRem.add(w.id);
                }
              }
            }
          }
        } else if (newLoadedLow < yLoaded.$1) {
          for (var y = newLoadedLow; y < yLoaded.$1; y++) {
            for (var x = xLoaded.$1; x <= xLoaded.$2; x++) {
              var r = widget.getWidgets(x, y);
              if (r != null) {
                toAdd.addAll(r);
              }
            }
          }
        }
        if (newLoadedHigh > yLoaded.$2) {
          for (var y = yLoaded.$2 + 1; y <= newLoadedHigh; y++) {
            for (var x = xLoaded.$1; x <= xLoaded.$2; x++) {
              var r = widget.getWidgets(x, y);
              if (r != null) {
                toAdd.addAll(r);
              }
            }
          }
        } else if (newLoadedHigh < yLoaded.$2) {
          for (var y = yLoaded.$2; y > newLoadedHigh; y--) {
            for (var x = xLoaded.$1; x <= xLoaded.$2; x++) {
              var r = widget.getWidgets(x, y);
              if (r != null) {
                for (var w in r) {
                  toRem.add(w.id);
                }
              }
            }
          }
        }
        yLoaded = (newLoadedLow, newLoadedHigh);
        if (toAdd.isNotEmpty || toRem.isNotEmpty) {
          stack.currentState?.addAndRemove(toAdd, toRem);
        }
      });
    }
    List<UniqueZHeightWidget> init = [];
    for (var x = xLoaded.$1; x < xLoaded.$2; x++) {
      for (var y = yLoaded.$1; y < yLoaded.$2; y++) {
        var wids = widget.getWidgets(x, y);
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
        dimension: 100000000000000000,
        child: InfiniteStack(key: stack, initChildren: init),
      ),
    );
  }
}

class InfiniteStack extends StatefulWidget {
  final List<UniqueZHeightWidget> initChildren;

  const InfiniteStack({super.key, this.initChildren = const []});

  @override
  State<StatefulWidget> createState() => InfiniteStackState();
}

class InfiniteStackState extends State<InfiniteStack> {
  List<UniqueZHeightWidget> children = [];
  Set<String> childrenIds = {};

  @override
  void initState() {
    super.initState();
    children = widget.initChildren;
    sort();
    for (var i = 0; i < widget.initChildren.length; i++) {
      childrenIds.add(widget.initChildren[i].id);
    }
  }

  void addAndRemove(List<UniqueZHeightWidget>? toAdd, List<String> toRemove) {
    var wasChanged = false;
    for (var id in toRemove) {
      if (childrenIds.contains(id)) {
        children.removeWhere((element) => element.id == id);
        wasChanged = true;
      }
    }
    if (toAdd != null) {
      wasChanged = true;
      children.addAll(toAdd);
      for (var a in toAdd) {
        childrenIds.add(a.id);
      }
      sort();
    }
    if (wasChanged) {
      setState(() {});
    }
  }

  void removeIds(List<String> ids) {
    var wasChanged = false;
    for (var id in ids) {
      if (childrenIds.contains(id)) {
        children.removeWhere((element) => element.id == id);
        wasChanged = true;
      }
    }
    if (wasChanged) {
      setState(() {});
    }
  }

  void add(List<UniqueZHeightWidget>? toAdd) {
    if (toAdd == null) {
      return;
    }
    children.addAll(toAdd);
    for (var a in toAdd) {
      childrenIds.add(a.id);
    }
    sort();
  }

  void sort() => children.sort((a, b) => a.zHeight.compareTo(b.zHeight));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (i) => children[i].widget()),
    );
  }
}
