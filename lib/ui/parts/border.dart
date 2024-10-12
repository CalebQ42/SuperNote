import 'package:flutter/material.dart';

class NotePartBorder extends StatefulWidget {
  final FocusNode? passthroughFocus;
  final Widget? child;
  final void Function(bool)? onFocusChange;

  const NotePartBorder({
    super.key,
    this.child,
    this.passthroughFocus,
    this.onFocusChange,
  });

  @override
  State<StatefulWidget> createState() => _NotePartBorderState();
}

class _NotePartBorderState extends State<NotePartBorder> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
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
          border:
              Border.all(color: isFocused ? Colors.black : Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
