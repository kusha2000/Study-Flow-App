import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_flow/models/assignment_model.dart';
import 'package:study_flow/services/database/assignment_service.dart';
import 'package:study_flow/widgets/sample_button.dart';
import 'package:study_flow/widgets/sample_input.dart';

class AddAssignmentScreen extends StatefulWidget {
  final String courseId;

  const AddAssignmentScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _assignmentDescriptionController =
      TextEditingController();
  final TextEditingController _assignmentDurationController =
      TextEditingController();

  // Using DateTime instead of ValueNotifier for simpler state management
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  // Add icon mappings for each field
  final Map<String, IconData> _fieldIcons = {
    'Assignment Name': Icons.assignment,
    'Assignment Description': Icons.description,
    'Assignment Duration': Icons.timer,
    'Due Date': Icons.calendar_today,
    'Due Time': Icons.access_time,
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading state
      setState(() => _isLoading = true);

      try {
        // create a new assignment
        final Assignment assignment = Assignment(
          id: "",
          name: _assignmentNameController.text,
          description: _assignmentDescriptionController.text,
          duration: _assignmentDurationController.text,
          dueDate: _selectedDate,
          dueTime: _selectedTime,
        );

        // Add the assignment to the database
        AssignmentService().createAssignment(widget.courseId, assignment);

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Assignment added successfully!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );

        // Delay navigation to ensure SnackBar is displayed
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to the home page
        GoRouter.of(context).go('/');
      } catch (error) {
        print('Error adding assignment: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 10),
                Text('Failed to add assignment!'),
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
                        Icons.assignment,
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
                      'Create New Assignment',
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
                    'Enter the assignment details below to track your course work',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Form fields with icons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Basic assignment info fields
                        ..._buildFormFields(),

                        SizedBox(height: 20),

                        // Due date section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: purpleTheme.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: purpleTheme.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date & Time',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: purpleTheme,
                                ),
                              ),
                              SizedBox(height: 16),

                              // Date picker row
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: purpleTheme),
                                  SizedBox(width: 15),
                                  Text(
                                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () => _selectDate(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          purpleTheme.withOpacity(0.1),
                                      foregroundColor: purpleTheme,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text('Select'),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),

                              // Time picker row
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: purpleTheme),
                                  SizedBox(width: 15),
                                  Text(
                                    'Time: ${_selectedTime.format(context)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () => _selectTime(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          purpleTheme.withOpacity(0.1),
                                      foregroundColor: purpleTheme,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text('Select'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit button at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomElevatedButton(
                    text: 'Add Assignment',
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
        controller: _assignmentNameController,
        labelText: 'Assignment Name',
        prefixIcon: _fieldIcons['Assignment Name'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter an assignment name';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _assignmentDescriptionController,
        labelText: 'Assignment Description',
        prefixIcon: _fieldIcons['Assignment Description'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter an assignment description';
          }
          return null;
        },
      ),
      CourseInputField(
        controller: _assignmentDurationController,
        labelText: 'Assignment Duration',
        prefixIcon: _fieldIcons['Assignment Duration'],
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter the assignment duration';
          }
          return null;
        },
      ),
    ];
  }
}
