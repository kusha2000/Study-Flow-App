import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/models/assignment_model.dart';
import 'package:study_flow/services/database/assignment_service.dart';
import 'package:study_flow/services/database/notifications_service.dart';
import 'package:study_flow/widgets/countdown_timer.dart';

class AssignmentPage extends StatelessWidget {
  Future<Map<String, List<Assignment>>> _fetchAssignments() async {
    return await AssignmentService().getAssignmentsWithCourseName();
  }

  Future<void> _checkAndStoreOverdueAssignments() async {
    await NotificationsService().storeOverdueAssignments();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Trigger the method when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStoreOverdueAssignments();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor.withOpacity(0.1),
        elevation: 0,
        title: Text(
          'Assignments',
          style: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Stack(
        children: [
          Container(
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
          ),
          FutureBuilder<Map<String, List<Assignment>>>(
            future: _fetchAssignments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No assignments available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }

              final assignmentsMap = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: assignmentsMap.keys.length,
                itemBuilder: (context, index) {
                  final courseName = assignmentsMap.keys.elementAt(index);
                  final assignments = assignmentsMap[courseName]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ExpansionTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.school,
                          size: 24,
                          color: primaryColor,
                        ),
                      ),
                      title: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withBlue(200),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          courseName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      children: assignments.map((assignment) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
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
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.assignment,
                                            size: 24,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            assignment.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Due Date',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat.yMMMd()
                                          .format(assignment.dueDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.hourglass_empty,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Duration',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      assignment.duration.isEmpty
                                          ? 'No duration specified'
                                          : '${assignment.duration} hours',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      assignment.description.isEmpty
                                          ? 'No description provided'
                                          : assignment.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Time Remaining',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    CountdownTimer(
                                      dueDate: assignment.dueDate,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
