import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../widgets/add_task_dialogue.dart';
import '../widgets/task_detail.dart';
import '../widgets/task_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(taskViewModelProvider.notifier).refreshTasks();
      },
    );

    final taskState = ref.watch(taskViewModelProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(darkModeProvider.notifier).state = !isDarkMode;
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, ref);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: taskState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : taskState.errorMessage != null
                    ? Center(child: Text(taskState.errorMessage!))
                    : filteredTasks.isEmpty
                        ? const Center(child: Text('No tasks available'))
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth >= 600) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: TaskList(tasks: filteredTasks),
                                    ),
                                    const VerticalDivider(width: 1),
                                    const Expanded(
                                      child: TaskDetail(),
                                    ),
                                  ],
                                );
                              }
                              return TaskList(tasks: filteredTasks);
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTaskDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter & Sort Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('All Tasks'),
                onTap: () {
                  ref.read(filterOptionProvider.notifier).state =
                      TaskFilterOption.all;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text('Sort by Priority'),
                onTap: () {
                  ref.read(filterOptionProvider.notifier).state =
                      TaskFilterOption.byPriority;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Sort by Date'),
                onTap: () {
                  ref.read(filterOptionProvider.notifier).state =
                      TaskFilterOption.byDate;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
