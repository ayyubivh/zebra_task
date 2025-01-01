import 'package:flutter/material.dart';

import '../../domain/models/task.dart';

class TaskDetail extends StatelessWidget {
  final Task? task;

  const TaskDetail({
    super.key,
    this.task,
  });

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return const Center(
        child: Text(
          'Select a task to view details',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(task!.priority);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Text(
                task!.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Due Date
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Due: ${task!.dueDate.toString().split(' ')[0]}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              const Divider(height: 24),

              // Description
              Text(
                'Description',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                task!.description,
                style: theme.textTheme.bodyLarge,
              ),
              const Divider(height: 24),

              // Priority and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Priority
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Priority: ',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task!.priority.toString(),
                          style: TextStyle(
                              color: priorityColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Status
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: Text(
                          task!.isCompleted ? 'Completed' : 'Pending',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor:
                            task!.isCompleted ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determines the color for the priority level.
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
