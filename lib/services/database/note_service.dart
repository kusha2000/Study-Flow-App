import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_flow/models/note_model.dart';

class NoteService {
  //create the firstore collection reference
  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  //create a new assignment in to a course
  Future<void> createNote(String courseId, Note note) async {
    try {
      final Map<String, dynamic> data = note.toJson();
      final CollectionReference noteCollection =
          courseCollection.doc(courseId).collection('notes');
      DocumentReference docRef = await noteCollection.add(data);

      //update the note id with the document id
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print(error);
    }
  }

  Stream<List<Note>> getNotes(String courseId) {
    try {
      final CollectionReference notesCollection =
          courseCollection.doc(courseId).collection('notes');
      return notesCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  Future<Map<String, List<Note>>> getNotesWithCourseName() async {
    try {
      final QuerySnapshot snapshot = await courseCollection.get();
      final Map<String, List<Note>> notesMap = {};

      for (final doc in snapshot.docs) {
        final String courseId = doc.id;
        final List<Note> notes = await getNotes(courseId).first;
        notesMap[doc['name']] = notes;
      }

      return notesMap;
    } catch (error) {
      print(error);
      return {};
    }
  }
}
