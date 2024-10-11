import 'package:flutter/material.dart';
import 'package:measured_size/measured_size.dart';
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

  // Largely taken from the defaultStylesheet, but with some padding removed.
  Stylesheet style = defaultStylesheet.copyWith(rules: [
    StyleRule(
      BlockSelector.all,
      (doc, docNode) {
        return {
          Styles.maxWidth: 640.0,
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
    doc = MutableDocument(nodes: [
      ParagraphNode(id: "0", text: AttributedText(widget.note.value))
    ]);
    compose = MutableDocumentComposer();
    edit = createDefaultDocumentEditor(
      composer: compose,
      document: doc,
      isHistoryEnabled: true,
    );
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
        child: MeasuredSize(
          onChange: (i) {
            print(i);
          },
          child: SizedBox.shrink(
            child: SuperEditor(
              editor: edit,
              stylesheet: style,
              plugins: {MarkdownInlineUpstreamSyntaxPlugin()},
            ),
          ),
        ),
      ),
    );
  }
}
