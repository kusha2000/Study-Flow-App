import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_flow/pages/add_assignment_page.dart';
import 'package:study_flow/pages/add_course_page.dart';
import 'package:study_flow/pages/create_note_page.dart';
import 'package:study_flow/pages/home_page.dart';
import 'package:study_flow/pages/notifications_screen.dart';


class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return const MaterialPage<dynamic>(
        child: Scaffold(
          body: Center(
            child: Text("this page is not found!!"),
          ),
        ),
      );
    },
    routes: [
      // Home Page
      GoRoute(
        name: "home",
        path: "/",
        builder: (context, state) {
          return HomePage();
        },
      ),

      //add course
      GoRoute(
        name: "add Course",
        path: "/add-course",
        builder: (context, state) {
          return AddCourseScreen();
        },
      ),

      //add assignment
      GoRoute(
        name: "add Assignment",
        path: "/add-assignment",
        builder: (context, state) {
          final Course course = state.extra as Course;

          return AddAssignmentScreen(
            courseId: course.id,
          );
        },
      ),

      //add Note
      GoRoute(
        name: "add Note",
        path: "/add-notes",
        builder: (context, state) {
          final Course course = state.extra as Course;

          return CreateNotePage(
            courseId: course.id,
          );
        },
      ),

      //Single Course
      GoRoute(
        path: '/single-course',
        builder: (context, state) {
          final Course course = state.extra as Course;
          return SingleCourseScreen(course: course);
        },
      ),

      //single assignment
      GoRoute(
        path: '/single-assignment',
        builder: (context, state) {
          final Assignment assignment = state.extra as Assignment;
          return SingleAssignmentScreen(assignment: assignment);
        },
      ),

      //single note
      GoRoute(
        path: '/single-note',
        builder: (context, state) {
          final Note note = state.extra as Note;
          return SingleNoteScreen(
            note: note,
          );
        },
      ),

      //notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) {
          return const NotificationsScreen();
        },
      ),
    ],
  );
}
