import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../widgets/task_detail.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: TaskDetail(
        task: task,
      ),
    );
  }
}
