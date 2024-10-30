import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';

class NotePartBorder extends StatefulWidget {
  final Widget? child;
  final void Function(bool)? onFocusChange;
  final NotePart part;

  const NotePartBorder({
    super.key,
    required this.part,
    this.child,
    this.onFocusChange,
  });

  @override
  State<StatefulWidget> createState() => _NotePartBorderState();
}

class _NotePartBorderState extends State<NotePartBorder> {
  bool isFocused = false;

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.part.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.part.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var borderColor = isFocused && !widget.part.isDragging
        ? Colors.black
        : Colors.transparent;
    return Positioned(
      left: widget.part.pos.dx,
      top: widget.part.pos.dy,
      // TODO: Add minimum size
      width: widget.part.size.width,
      height: widget.part.size.height,
      child: Focus(
        onFocusChange: (b) {
          if (b != isFocused) {
            setState(() => isFocused = b);
            if (widget.onFocusChange != null) {
              widget.onFocusChange!(b);
            }
          }
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: isFocused ? Theme.of(context).canvasColor : null,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: widget.child,
            ),
            // TL resize area
            Positioned(
              left: 0,
              top: 0,
              height: 10,
              width: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeftDownRight,
                child: GestureDetector(
                  onPanUpdate: (deets) {
                    var newPos = widget.part.pos
                        .translate(deets.delta.dx, deets.delta.dy);
                    var newSize = Size(widget.part.size.width - deets.delta.dx,
                        widget.part.size.height - deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50 ||
                        newPos.dy < 0 ||
                        newSize.width < 75 ||
                        newPos.dx < 0) {
                      return;
                    }
                    widget.part.setPosAndSize(pos: newPos, size: newSize);
                  },
                ),
              ),
            ),
            // Top resize area
            Positioned(
              left: 10,
              top: 0,
              height: 7.5,
              width: widget.part.size.width - 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onVerticalDragUpdate: (deets) {
                    var newPos = widget.part.pos
                        .translate(deets.delta.dx, deets.delta.dy);
                    var newSize = Size(widget.part.size.width,
                        widget.part.size.height - deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50 || newPos.dy < 0) {
                      return;
                    }
                    widget.part.setPosAndSize(pos: newPos, size: newSize);
                  },
                ),
              ),
            ),
            // TR resize area
            Positioned(
              left: widget.part.size.width - 10,
              top: 0,
              height: 10,
              width: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpRightDownLeft,
                child: GestureDetector(
                  onPanUpdate: (deets) {
                    var newPos = widget.part.pos.translate(0, deets.delta.dy);
                    var newSize = Size(widget.part.size.width + deets.delta.dx,
                        widget.part.size.height - deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50 ||
                        newPos.dy < 0 ||
                        newSize.width < 75 ||
                        newPos.dx < 0) {
                      return;
                    }
                    widget.part.setPosAndSize(pos: newPos, size: newSize);
                  },
                ),
              ),
            ),
            // Right resize area
            Positioned(
              left: widget.part.size.width - 7.5,
              top: 10,
              width: 7.5,
              height: widget.part.size.height - 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  onHorizontalDragUpdate: (deets) {
                    var newSize = Size(widget.part.size.width + deets.delta.dx,
                        widget.part.size.height);
                    //TODO: Logical minimum width. Possibly based on child widget??
                    if (newSize.width < 75) {
                      return;
                    }
                    widget.part.setPosAndSize(size: newSize);
                  },
                ),
              ),
            ),
            // BR resize area
            Positioned(
              left: widget.part.size.width - 10,
              top: widget.part.size.height - 10,
              height: 10,
              width: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeftDownRight,
                child: GestureDetector(
                  onPanUpdate: (deets) {
                    var newSize = Size(widget.part.size.width + deets.delta.dx,
                        widget.part.size.height + deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50 || newSize.width < 75) {
                      return;
                    }
                    widget.part.setPosAndSize(size: newSize);
                  },
                ),
              ),
            ),
            // Bottom resize area
            Positioned(
              left: 10,
              top: widget.part.size.height - 7.5,
              height: 7.5,
              width: widget.part.size.width - 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onVerticalDragUpdate: (deets) {
                    var newSize = Size(widget.part.size.width,
                        widget.part.size.height + deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50) {
                      return;
                    }
                    widget.part.size = newSize;
                  },
                ),
              ),
            ),
            // BL resize area
            Positioned(
              left: 0,
              top: widget.part.size.height - 10,
              height: 10,
              width: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpRightDownLeft,
                child: GestureDetector(
                  onPanUpdate: (deets) {
                    var newPos = widget.part.pos.translate(deets.delta.dx, 0);
                    var newSize = Size(widget.part.size.width - deets.delta.dx,
                        widget.part.size.height + deets.delta.dy);
                    //TODO: Logical minimum height. Possibly based on child widget??
                    if (newSize.height < 50 ||
                        newPos.dy < 0 ||
                        newSize.width < 75 ||
                        newPos.dx < 0) {
                      return;
                    }
                    widget.part.setPosAndSize(pos: newPos, size: newSize);
                  },
                ),
              ),
            ),
            // Left resize area
            Positioned(
              left: 0,
              top: 10,
              width: 7.5,
              height: widget.part.size.height - 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  onHorizontalDragUpdate: (deets) {
                    var newPos = widget.part.pos
                        .translate(deets.delta.dx, deets.delta.dy);
                    var newSize = Size(widget.part.size.width - deets.delta.dx,
                        widget.part.size.height);
                    //TODO: Logical minimum width. Possibly based on child widget??
                    if (newSize.width < 75 || newPos.dx < 0) {
                      return;
                    }
                    widget.part.setPosAndSize(pos: newPos, size: newSize);
                  },
                ),
              ),
            ),
            // Grab Handle
            Positioned(
              left: (widget.part.size.width / 2) - 25,
              top: 0,
              height: 7.5,
              width: 50,
              child: GestureDetector(
                onPanStart: (deets) {
                  print(deets.localPosition);
                },
                onPanUpdate: (deets) {
                  print(deets.localPosition);
                  print(deets.globalPosition);
                  var newPos =
                      widget.part.pos.translate(deets.delta.dx, deets.delta.dy);
                  if (newPos.dx < 0) {
                    newPos = Offset(0, newPos.dy);
                  }
                  if (newPos.dy < 0) {
                    newPos = Offset(newPos.dx, 0);
                  }
                  widget.part.pos = newPos;
                },
                child: _DragHandle(borderColor: borderColor, size: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  final Color? borderColor;
  final double size;

  const _DragHandle({this.borderColor, this.size = 5});

  @override
  Widget build(BuildContext context) {
    var dot = Container(
      height: size,
      width: size,
      foregroundDecoration: ShapeDecoration(
        color: borderColor,
        shape: CircleBorder(),
      ),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Row(
          children: [
            Spacer(),
            dot,
            Spacer(),
            dot,
            Spacer(),
            dot,
            Spacer(),
            dot,
            Spacer(),
            dot,
            Spacer(),
          ],
        ),
      ),
    );
  }
}
