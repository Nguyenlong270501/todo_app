import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/task_model.dart';
import '../../data/repository/task_repository.dart';

part 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final _taskRepository = TaskRepository();

  Future<void> getTasks(String date, String uid) async {
    emit(TaskLoading());
    final result = await _taskRepository.getTasks(date, uid);
    result.fold(
      (failure) => emit(TaskError(failure)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> addTask(TaskModel task, String uid) async {
    emit(TaskLoading());
    final result = await _taskRepository.addTask(task, uid);
    result.fold(
      (failure) => emit(TaskError(failure)),
      (_) => emit(const TaskAdded()),
    );
  }

  Future<void> updateTask(TaskModel task, String uid) async {
    emit(TaskLoading());
    final result = await _taskRepository.updateTask(task, uid);
    result.fold(
      (failure) => emit(TaskError(failure)),
      (updatedTask) => emit(const TaskUpdated()),
    );
  }

  Future<void> deleteTask(String id, String uid) async {
    final result = await _taskRepository.deleteTask(id, uid);
    result.fold(
      (failure) => emit(TaskError(failure)),
      (_) => emit(TaskDeleted(id)),
    );
  }
}
