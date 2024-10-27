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
    //TODO:
    return Positioned(
      left: widget.part.pos.dx,
      top: widget.part.pos.dy,
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
        canRequestFocus: true,
        skipTraversal: true,
        descendantsAreFocusable: true,
        descendantsAreTraversable: true,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isFocused ? Theme.of(context).canvasColor : null,
            border: Border.all(
                color: isFocused ? Colors.black : Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
