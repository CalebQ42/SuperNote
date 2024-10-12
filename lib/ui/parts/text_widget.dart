import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

import 'package:supernote/note/parts/text_part.dart';
import 'package:supernote/ui/parts/border.dart';

class TextNoteWidget extends StatefulWidget {
  final TextNotePart note;

  const TextNoteWidget({super.key, required this.note});

  @override
  State<TextNoteWidget> createState() => _TextNoteWidgetState();
}

class _TextNoteWidgetState extends State<TextNoteWidget> {
  late MutableDocument doc;
  late MutableDocumentComposer compose;
  late Editor edit;
  GlobalKey<State<StatefulWidget>> layoutKey = GlobalKey();
  late _Listen listen;

  // Largely taken from the defaultStylesheet, but with some padding and maxWidth removed.
  Stylesheet style = defaultStylesheet.copyWith(rules: [
    StyleRule(
      BlockSelector.all,
      (doc, docNode) {
        return {
          Styles.textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            height: 1.4,
          ),
        };
      },
    ),
    StyleRule(
      BlockSelector("paragraph"),
      (doc, docNode) {
        if (doc.getNodeIndexById(docNode.id) != 0) {
          return {Styles.padding: const CascadingPadding.only(top: 8)};
        }
        return {};
      },
    ),
    StyleRule(
      const BlockSelector("header1"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 12),
          Styles.textStyle: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        };
      },
    ),
    StyleRule(
      const BlockSelector("header2"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 12),
          Styles.textStyle: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        };
      },
    ),
    StyleRule(
      const BlockSelector("header3"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 12),
          Styles.textStyle: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        };
      },
    ),
    StyleRule(
      const BlockSelector("paragraph").after("header1"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 0),
        };
      },
    ),
    StyleRule(
      const BlockSelector("paragraph").after("header2"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 0),
        };
      },
    ),
    StyleRule(
      const BlockSelector("paragraph").after("header3"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 0),
        };
      },
    ),
    StyleRule(
      const BlockSelector("listItem"),
      (doc, docNode) {
        return {
          Styles.padding: const CascadingPadding.only(top: 10),
        };
      },
    ),
    StyleRule(
      const BlockSelector("blockquote"),
      (doc, docNode) {
        return {
          Styles.textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        };
      },
    ),
  ]);

  @override
  void initState() {
    super.initState();
    compose = MutableDocumentComposer();
    doc = MutableDocument(nodes: [
      ParagraphNode(id: "0", text: AttributedText(widget.note.value)),
    ]);
    listen = _Listen(layoutKey, compose, doc, style,
        (width, height, fontSize, padding) {
      fontSize ??= 25;
      padding ??= CascadingPadding.all(10);
      var sizeSet = false;
      var newWidth = widget.note.size.width;
      var newHeight = widget.note.size.height;
      if (!widget.note.manualSize && widget.note.size.width < 800) {
        newWidth = min(
          800,
          width + (fontSize * 2) + (padding.left ?? 0) + (padding.right ?? 0),
        );
        if (newWidth != widget.note.size.width) {
          sizeSet = true;
        }
      }
      newHeight = height + 10 + (padding.top ?? 0) + (padding.bottom ?? 0);
      if (newHeight != widget.note.size.height) {
        sizeSet = true;
      }
      if (sizeSet) {
        setState(() => widget.note.size = Size(newWidth, newHeight));
      }
    });
    edit = createDefaultDocumentEditor(
      composer: compose,
      document: doc,
      isHistoryEnabled: true,
    )..addListener(listen);
  }

  @override
  void dispose() {
    edit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.note.pos.dy,
      left: widget.note.pos.dx,
      height: widget.note.size.height,
      width: widget.note.size.width,
      child: NotePartBorder(
        child: SuperEditor(
          editor: edit,
          stylesheet: style,
          documentLayoutKey: layoutKey,
          plugins: {MarkdownInlineUpstreamSyntaxPlugin()},
        ),
      ),
    );
  }
}

class _Listen extends EditListener {
  GlobalKey<State<StatefulWidget>> layoutKey = GlobalKey();
  MutableDocumentComposer compose;
  Document doc;
  Stylesheet style;
  void Function(double width, double height, double? fontSize,
      CascadingPadding? padding) sizeChange;

  _Listen(this.layoutKey, this.compose, this.doc, this.style, this.sizeChange);

  @override
  void onEdit(List<EditEvent> changeList) {
    bool paragraphAdded = false;
    for (var c in changeList) {
      if (c is SubmitParagraphIntention ||
          c is SplitParagraphIntention ||
          c is SplitListItemIntention) {
        paragraphAdded = true;
      }
    }
    var heightOffset = 0.0;
    if (paragraphAdded) {
      var found = false;
      var nodes = currentlySelectedNodes();
      for (var n in nodes) {
        if (n is TextNode && n.text.text == "") {
          found = true;
          var sty = getStyleForNode(n);
          heightOffset = (sty.$1?.fontSize ?? 0);
          heightOffset += (sty.$2?.top ?? 0) + (sty.$2?.bottom ?? 0) + 8;
          break;
        }
      }
      if (!found && nodes.isNotEmpty) {
        var firstIndex = doc.getNodeIndexById(nodes[0].id);
        if (firstIndex > 0) {
          var newParaNode = doc.getNodeAt(firstIndex - 1);
          if (newParaNode is TextNode) {
            var sty = getStyleForNode(newParaNode);
            heightOffset = (sty.$1?.fontSize ?? 0);
            heightOffset += (sty.$2?.top ?? 0) + (sty.$2?.bottom ?? 0) + 8;
          }
        }
      }
    }
    var lay = (layoutKey.currentState as DocumentLayout?);
    if (lay == null) {
      print("no lay");
      return;
    }
    var high = lay.findLastSelectablePosition();
    if (high == null) {
      print("no high");
      return;
    }
    var low = lay.getDocumentPositionAtOffset(Offset(0, 0));
    if (low == null) {
      print("no low");
      return;
    }
    var rect = lay.getRectForSelection(low, high);
    if (rect == null) {
      print("no rect");
      return;
    }
    print(rect);
    var sty = getStyleForCurSelection().firstOrNull;
    sizeChange(
      rect.width,
      rect.height + heightOffset,
      sty?.$1?.fontSize,
      sty?.$2,
    );
  }

  List<(TextStyle?, CascadingPadding?)> getStyleForCurSelection() {
    List<(TextStyle?, CascadingPadding?)> out = [];
    for (var n in currentlySelectedNodes()) {
      out.add(getStyleForNode(n));
    }
    return out;
  }

  (TextStyle?, CascadingPadding?) getStyleForNode(DocumentNode n) {
    TextStyle? curStyle;
    CascadingPadding? curPadding;
    for (var r in style.rules) {
      if (r.selector.matches(doc, n)) {
        var sty = r.styler(doc, n);
        if (sty.containsKey(Styles.textStyle)) {
          curStyle = sty[Styles.textStyle];
        }
        if (sty.containsKey(Styles.padding)) {
          if (curPadding != null) {
            curPadding = (sty[Styles.padding] as CascadingPadding)
                .applyOnTopOf(curPadding);
          } else {
            curPadding = sty[Styles.padding];
          }
        }
      }
    }
    return (curStyle, curPadding);
  }

  List<DocumentNode> currentlySelectedNodes() {
    var select = compose.selection;
    if (select == null) return [];
    return doc.getNodesInside(select.start, select.end);
  }
}
