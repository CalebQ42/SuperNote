import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

import 'package:supernote/note/parts/text_part.dart';
import 'package:supernote/ui/border.dart';

class TextNoteWidget extends StatelessWidget {
  final TextNotePart note;

  late final MutableDocument doc;
  late final MutableDocumentComposer compose;
  late final Editor edit;
  final GlobalKey<State<StatefulWidget>> layoutKey = GlobalKey();
  late final _Listen _listen;

  TextNoteWidget({super.key, required this.note}) {
    compose = MutableDocumentComposer();
    doc = MutableDocument(nodes: [
      //TODO: actually initialize the state.
      ParagraphNode(id: "0", text: AttributedText(note.value)),
    ]);
    _listen = _Listen(
      layoutKey: layoutKey,
      compose: compose,
      doc: doc,
      style: style,
      maxWidth: () {
        if (note.manualWidth) {
          return note.size.width;
        }
        // TODO: default max width should be less arbitrary. Possibly based on the current device's width.
        return 790;
      },
      getTextSize: _textSize,
      sizeChange: (width, height, fontSize) {
        var sizeSet = false;
        var newWidth = note.size.width;
        var newHeight = note.size.height;
        // TODO: default max width should be less arbitrary. Possibly based on the current device's width.
        if (!note.manualWidth) {
          newWidth = min(
            800,
            width + 15 + (fontSize * 2),
          );
          if (newWidth != note.size.width) {
            sizeSet = true;
          }
        }
        newHeight = height + 20;
        if (newHeight != note.size.height) {
          sizeSet = true;
        }
        if (sizeSet) {
          note.size = Size(newWidth, newHeight);
        }
      },
    );
    edit = createDefaultDocumentEditor(
      composer: compose,
      document: doc,
      isHistoryEnabled: true,
    )..addListener(_listen);
  }

  // Largely taken from the defaultStylesheet, but with some padding and maxWidth removed.
  final Stylesheet style = defaultStylesheet.copyWith(rules: [
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
        return {Styles.padding: const CascadingPadding.symmetric(vertical: 4)};
        // return {};
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
  Widget build(BuildContext context) {
    return NotePartBorder(
      part: note,
      child: SuperEditor(
        editor: edit,
        stylesheet: style,
        documentLayoutKey: layoutKey,
        plugins: {MarkdownInlineUpstreamSyntaxPlugin()},
      ),
    );
  }

  // Thanks to: https://stackoverflow.com/a/60065737
  Size _textSize(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }
}

class _Listen extends EditListener {
  final GlobalKey<State<StatefulWidget>> layoutKey;
  final MutableDocumentComposer compose;
  final Document doc;
  final Stylesheet style;
  final void Function(double width, double height, double fontSize) sizeChange;
  final Size Function(String text, TextStyle style, double maxWidth)
      getTextSize;
  final double Function() maxWidth;

  _Listen({
    required this.layoutKey,
    required this.compose,
    required this.doc,
    required this.style,
    required this.getTextSize,
    required this.sizeChange,
    required this.maxWidth,
  });

  @override
  void onEdit(List<EditEvent> changeList) {
    if (changeList.every((element) =>
        element is SelectionChangeEvent ||
        element is ComposingRegionChangeEvent)) {
      return;
    }

    var width = 0.0;
    var height = 0.0;
    for (var d in doc) {
      if (d is TextNode) {
        if (d.text.text == "") {
          var nodeSty = getStyleForNode(d);
          if (nodeSty.$1 != null) {
            var textSize = getTextSize(
              "",
              nodeSty.$1!,
              maxWidth() - ((nodeSty.$2?.left ?? 0) + (nodeSty.$2?.right ?? 0)),
            );
            height += textSize.height +
                (nodeSty.$2?.top ?? 5) +
                (nodeSty.$2?.bottom ?? 5);
          }
        } else {
          var nodeSty = getStyleForNode(d);
          if (nodeSty.$1 == null) continue;
          var partWidth = (nodeSty.$2?.left ?? 0) + (nodeSty.$2?.right ?? 0);
          var maxHeight = 0.0;
          d.text.visitAttributionSpans((span) {
            var sty = style.inlineTextStyler(span.attributions, nodeSty.$1!);
            var textSize = getTextSize(
              d.text.text.substring(span.start, span.end + 1),
              sty,
              maxWidth() - ((nodeSty.$2?.left ?? 0) + (nodeSty.$2?.right ?? 0)),
            );
            maxHeight = max(maxHeight, textSize.height);
            partWidth += textSize.width;
          });
          height +=
              maxHeight + (nodeSty.$2?.top ?? 0) + (nodeSty.$2?.bottom ?? 0);
          width = max(width, partWidth);
        }
      }
    }
    var sty = getStyleForCurSelection().lastOrNull;
    sizeChange(width, height, sty?.$1?.fontSize ?? 25);
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
          if (curStyle != null) {
            curStyle = curStyle.merge(sty[Styles.textStyle]);
          } else {
            curStyle = sty[Styles.textStyle];
          }
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
