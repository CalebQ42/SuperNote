import 'package:supernote/note/part.dart';
import 'package:uuid/uuid.dart';

class Note {
  late String id;
  String title;
  // <100px by 100px section (x, y), Notes in section>
  Map<(int, int), List<NotePart>?> parts;

  Note({this.title = "", this.parts = const {}, String? id}) {
    if (id == null) {
      this.id = Uuid().v7();
    }
  }

  void save(/* TODO */) {
    //TODO
  }
}
