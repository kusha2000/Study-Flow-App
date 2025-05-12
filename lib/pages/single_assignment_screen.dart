import 'package:flutter/material.dart';
import 'package:study_flow/models/assignment_model.dart';

class SingleAssignmentScreen extends StatefulWidget {
  final Assignment assignment;
  const SingleAssignmentScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<SingleAssignmentScreen> createState() => _SingleAssignmentScreenState();
}

class _SingleAssignmentScreenState extends State<SingleAssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
