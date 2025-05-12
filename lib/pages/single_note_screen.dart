import 'package:flutter/material.dart';
import 'package:study_flow/models/note_model.dart';

class SingleNoteScreen extends StatefulWidget {
  final Note note;
  const SingleNoteScreen({
    super.key,
    required this.note,
  });

  @override
  State<SingleNoteScreen> createState() => _SingleNoteScreenState();
}

class _SingleNoteScreenState extends State<SingleNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
