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
}
