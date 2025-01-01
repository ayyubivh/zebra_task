import '../domain/models/task.dart';

import 'database_services.dart';

class TaskRepository {
  final DatabaseService databaseService;

  TaskRepository(this.databaseService);

  Future<List<Task>> fetchTasks() => databaseService.getTasks();
  Future<void> addTask(Task task) => databaseService.insertTask(task);
  Future<void> updateTask(Task task) => databaseService.updateTask(task);
  Future<void> deleteTask(int id) => databaseService.deleteTask(id);
}
