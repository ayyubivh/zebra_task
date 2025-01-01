import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository.dart';
import '../../domain/models/task.dart';

class TaskState {
  final List<Task> tasks;
  final bool isLoading;
  final String? errorMessage;

  TaskState({
    required this.tasks,
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TaskViewModel extends StateNotifier<TaskState> {
  final TaskRepository repository;

  TaskViewModel(this.repository) : super(TaskState(tasks: []));

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await repository.fetchTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> addTask(Task task) async {
    await repository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await repository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await repository.deleteTask(id);
    await loadTasks();
  }

  Future<void> refreshTasks() => loadTasks();
}
