import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_services.dart';
import '../data/repository.dart';
import '../domain/models/task.dart';
import '../presentation/viewmodel/task_view_model.dart';

// Database Service Provider
final databaseServiceProvider =
    Provider<DatabaseService>((ref) => DatabaseService());

// Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return TaskRepository(databaseService);
});

// ViewModel Provider
final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskViewModel(repository);
});
final darkModeProvider = StateProvider<bool>((ref) => false);
// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter Options Provider
final filterOptionProvider = StateProvider<TaskFilterOption>(
  (ref) => TaskFilterOption.all, // Default to show all tasks
);

// Enum for Task Filter Options
enum TaskFilterOption { all, byPriority, byDate }

// Filtered and Sorted Tasks Provider
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final taskState = ref.watch(taskViewModelProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final filterOption = ref.watch(filterOptionProvider);

  List<Task> filteredTasks = taskState.tasks;

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filteredTasks = filteredTasks
        .where((task) =>
            task.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Apply additional filter
  switch (filterOption) {
    case TaskFilterOption.byPriority:
      filteredTasks.sort((a, b) => b.priority.compareTo(a.priority));
      break;
    case TaskFilterOption.byDate:
      filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      break;
    default:
      break;
  }

  return filteredTasks;
});
