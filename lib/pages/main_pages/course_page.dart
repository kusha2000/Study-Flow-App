import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/models/assignment_model.dart';
import 'package:study_flow/models/course_model.dart';
import 'package:study_flow/models/note_model.dart';
import 'package:study_flow/services/database/assignment_service.dart';
import 'package:study_flow/services/database/course_service.dart';
import 'package:study_flow/services/database/note_service.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final courses = await CourseService().getCourses();
      final assignmentsMap =
          await AssignmentService().getAssignmentsWithCourseName();
      final notesMap = await NoteService().getNotesWithCourseName();

      return {
        'courses': courses,
        'assignments': assignmentsMap,
        'notes': notesMap,
      };
    } catch (error) {
      print('Error fetching data: $error');
      return {
        'courses': [],
        'assignments': {},
        'notes': {},
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: primaryColor.withOpacity(0.1),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/notifications');
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.notifications,
                  size: 24,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.05),
              Colors.white,
              primaryColor.withOpacity(0.03),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              );
            }

            final courses = snapshot.data!['courses'] as List<Course>? ?? [];
            final assignmentsMap = snapshot.data!['assignments']
                    as Map<String, List<Assignment>>? ??
                {};
            final notesMap =
                snapshot.data!['notes'] as Map<String, List<Note>>? ?? {};

            if (courses.isEmpty) {
              return Center(
                child: Text(
                  'No courses available.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseAssignments = assignmentsMap[course.name] ?? [];
                final courseNotes = notesMap[course.name] ?? [];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.school,
                                  size: 30,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      primaryColor,
                                      primaryColor.withBlue(200),
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Description: ${course.description}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${course.duration}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Schedule: ${course.schedule}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Instructor: ${course.instructor}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          if (courseAssignments.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Assignments',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: courseAssignments.map((assignment) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.task,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                                    title: Text(
                                      assignment.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      GoRouter.of(context).push(
                                        '/single-assignment',
                                        extra: assignment,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          if (courseNotes.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  color: primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: courseNotes.map((note) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.note_alt,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                                    title: Text(
                                      note.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Section: ${note.section}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      GoRouter.of(context).push(
                                        '/single-note',
                                        extra: note,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
