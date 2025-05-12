import 'package:flutter/material.dart';
import 'package:study_flow/widgets/sample_button.dart';
import 'package:study_flow/widgets/sample_input.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _courseDurationController =
      TextEditingController();
  final TextEditingController _courseScheduleController =
      TextEditingController();
  final TextEditingController _courseInstructorController =
      TextEditingController();

  // Add icon mappings for each field
  final Map<String, IconData> _fieldIcons = {
    'Course Name': Icons.book,
    'Course Description': Icons.description,
    'Course Duration': Icons.timer,
    'Course Schedule': Icons.calendar_today,
    'Course Instructor': Icons.person,
  };

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading state
      setState(() => _isLoading = true);

      try {
        // Create a new course
        await Future.delayed(const Duration(seconds: 1));

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Course added successfully!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );

        // Navigate back or clear form
        Navigator.of(context).pop();
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 10),
                Text('Failed to add course!'),
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

  bool _isLoading = false;

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
                    // Back button on the left
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
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: purpleTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Icon(
                        Icons.school,
                        size: 70,
                        color: purpleTheme,
                      ),
                    ),
                    const Spacer(), // Balances the layout
                  ],
                ),
                const SizedBox(height: 24),

                // Title with gradient
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        purpleTheme,
                        purpleTheme.withBlue(200),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Create New Course',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                //description
                Center(
                  child: Text(
                    'Enter the course details below to enhance your study planner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Form fields with animations
                ..._buildFormFields(),

                const SizedBox(height: 32),

                // Custom button with loading state
                CustomElevatedButton(
                  text: 'Add Course',
                  onPressed: () => _submitForm(context),
                  icon: Icons.add_circle,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 40),
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
        controller: _courseNameController,
        labelText: 'Course Name',
        prefixIcon: _fieldIcons['Course Name'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter a course name';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _courseDescriptionController,
        labelText: 'Course Description',
        prefixIcon: _fieldIcons['Course Description'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter a course description';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _courseDurationController,
        labelText: 'Course Duration',
        prefixIcon: _fieldIcons['Course Duration'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter the course duration';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _courseScheduleController,
        labelText: 'Course Schedule',
        prefixIcon: _fieldIcons['Course Schedule'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter the course schedule';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _courseInstructorController,
        labelText: 'Course Instructor',
        prefixIcon: _fieldIcons['Course Instructor'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter the course instructor';
          }
          return null;
        },
      ),
    ];
  }
}
