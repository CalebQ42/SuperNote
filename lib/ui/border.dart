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
            Positioned(
              left: (widget.part.size.width / 2) - 25,
              top: 0,
              height: 5,
              width: 50,
              child: GestureDetector(
                onPanUpdate: (deets) {
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
