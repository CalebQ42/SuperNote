import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class InfiniteCanvas extends StatefulWidget {
  final List<NotePart> Function(int, int) getParts;

  const InfiniteCanvas({super.key, required this.getParts});

  @override
  State<StatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends State<InfiniteCanvas> {
  // Which 100x100px sections are currently loaded.
  // TODO: Determine how many sections to load at once based on screen size
  (int, int) loadedX = (0, 10);
  (int, int) loadedY = (0, 10);

  Offset curPos = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return TableView(
      delegate: TableCellBuilderDelegate(
        columnBuilder: (_) => Span(extent:FixedSpanExtent(100)),
        rowBuilder: (_) => Span(extent:FixedSpanExtent(100)),
        cellBuilder: (context, vicintity){
          var c = widget.getParts(vicintity.column, vicintity.row);
          return TableViewCell(
            child: Stack(
              children: List.generate(c.length, (i) => Positioned(
                top: c[i].pos.dy,
                right: c[i].pos.dx,
                height: c[i].size.height,
                width: c[i].size.width,
                child: c[i].view(),
              ))
            )
          );
        }
      )
    );
  }
}
