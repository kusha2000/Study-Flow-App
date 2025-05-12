import 'package:flutter/material.dart';
import 'package:study_flow/models/course_model.dart';

class SingleCourseScreen extends StatefulWidget {
  final Course course;
  const SingleCourseScreen({
    super.key,
    required this.course,
  });

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
