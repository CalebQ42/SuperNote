import 'package:flutter/material.dart';
import 'package:supernote/note/part.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class NoteCanvas extends StatefulWidget {
  final List<NotePart> Function(int, int) getNotes;

  const NoteCanvas(this.getNotes, {super.key});

  @override
  State<NoteCanvas> createState() => _NoteCanvasState();
}

class _NoteCanvasState extends State<NoteCanvas> {
  @override
  Widget build(BuildContext context) {
    return TableView(
      delegate: TableCellBuilderDelegate(
        columnBuilder: (_) => Span(
          extent:FixedSpanExtent(100),
          backgroundDecoration: SpanDecoration(
            color: Colors.transparent,
            border: SpanBorder(
              trailing: BorderSide(color:Colors.blue, width:2)
            )
          )
        ),
        rowBuilder: (_) => Span(
          extent:FixedSpanExtent(100),
          backgroundDecoration: SpanDecoration(
            color: Colors.transparent,
            border: SpanBorder(
              trailing: BorderSide(color:Colors.blue, width:2)
            )
          )
        ),
        cellBuilder: (context, vicintity){
          var c = widget.getNotes(vicintity.column, vicintity.row);
          return TableViewCell(
            child: UnconstrainedBox(
              child: Stack(
                children: List.generate(c.length, (i) => Positioned(
                  top: c[i].pos.dy,
                  right: c[i].pos.dx,
                  child: c[i].view()
                ))
              )
            )
          );
        }
      )
    );
  }
}
