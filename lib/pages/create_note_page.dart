import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_flow/models/note_model.dart';
import 'package:study_flow/services/database/note_service.dart';
import 'package:study_flow/widgets/sample_button.dart';
import 'package:study_flow/widgets/sample_input.dart';

class CreateNotePage extends StatefulWidget {
  final String courseId;
  const CreateNotePage({super.key, required this.courseId});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteNameController = TextEditingController();
  final TextEditingController _noteDescriptionController =
      TextEditingController();
  final TextEditingController _noteSectionController = TextEditingController();
  final TextEditingController _noteReferencesController =
      TextEditingController();

  bool _isLoading = false;

  // Updated icon mappings for each field
  final Map<String, IconData> _fieldIcons = {
    'Note Title': Icons.title,
    'Note Section': Icons.bookmark,
    'Note References': Icons.link,
    'Note Description': Icons.description,
  };

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final Note note = Note(
          id: "",
          title: _noteNameController.text,
          description: _noteDescriptionController.text,
          section: _noteSectionController.text,
          references: _noteReferencesController.text,
        );

        NoteService().createNote(widget.courseId, note);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Note added successfully!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        GoRouter.of(context).go('/');
      } catch (error) {
        print('Error adding note: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 10),
                Text('Failed to add note!'),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final purpleTheme = Theme.of(context).colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              purpleTheme.withOpacity(0.05),
              Colors.white,
              purpleTheme.withOpacity(0.03),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: purpleTheme.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: purpleTheme,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: purpleTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Icon(
                        Icons.note_add,
                        size: 70,
                        color: purpleTheme,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        purpleTheme,
                        purpleTheme.withBlue(200),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Create New Note',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Enter the note details below to track your course work',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ..._buildFormFields(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomElevatedButton(
                    text: 'Add Note',
                    onPressed: () => _submitForm(context),
                    icon: Icons.add_circle,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      CourseInputField(
        controller: _noteNameController,
        labelText: 'Note Title',
        prefixIcon: _fieldIcons['Note Title'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter a Note Title';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _noteSectionController,
        labelText: 'Note Section',
        prefixIcon: _fieldIcons['Note Section'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter a note section';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _noteReferencesController,
        labelText: 'Note References',
        prefixIcon: _fieldIcons['Note References'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter the references';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _noteDescriptionController,
        labelText: 'Note Description',
        prefixIcon: _fieldIcons['Note Description'],
        maxLines: 6,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter a note description';
          }
          return null;
        },
      ),
    ];
  }
}
