import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_flow/models/course_model.dart';

class CourseService {
  //create the firstore collection reference
  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  Future<void> createCourse(Course course) async {
    try {
      // Convert the course object to a map
      final Map<String, dynamic> data = course.toJson();

      // Add the course to the collection
      final docRef = await courseCollection.add(data);

      // Update the course document with the generated ID
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print('Error creating course: $error');
    }
  }

  //get all courses as a stream List of Course
  Stream<List<Course>> get courses {
    try {
      return courseCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  //delete a course
  Future<void> deleteCourse(String id) async {
    try {
      await courseCollection.doc(id).delete();
    } catch (error) {
      print(error);
    }
  }

  //get cousers as list
  Future<List<Course>> getCourses() async {
    try {
      final QuerySnapshot snapshot = await courseCollection.get();
      return snapshot.docs.map((doc) {
        return Course.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      print('Error fetching courses: $error');
      return [];
    }
  }
}
