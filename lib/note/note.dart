import 'package:supernote/note/part.dart';

class Note {
  String title;
  // <100px by 100px section (x, y), Notes in section>
  Map<(int, int), List<NotePart>?> parts;

  Note({this.title = "", this.parts = const {}});

  void save(/* TODO */) {
    //TODO
  }
}
