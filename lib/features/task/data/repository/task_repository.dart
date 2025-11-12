import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskRepository {
  TaskRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<String, List<TaskModel>>> getTasks(
    String date,
    String userId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('tasks')
              .where('date', isEqualTo: date)
              .get();

      final tasks =
          snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();

      // sort task theo time
      tasks.sort((a, b) => a.time!.compareTo(b.time!));

      return Right(tasks);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Stream<List<TaskModel>> getTasksStream(String date, String userId) {
  return _firestore
      .collection('users')
      .doc(userId)
      .collection('tasks')
      .where('date', isEqualTo: date)
      .snapshots()
      .map((snapshot) => 
          snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList());
}

  Future<Either<String, bool>> addTask(TaskModel task, String uid) async {
    try {
      final docRef =
          _firestore.collection('users').doc(uid).collection('tasks').doc();

      final taskWithId = TaskModel(
        id: docRef.id,
        title: task.title,
        note: task.note,
        date: task.date,
        time: task.time,
        reminder: task.reminder,
        colorIndex: task.colorIndex,
      );

      await docRef.set(taskWithId.toMap());
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> updateTask(TaskModel task, String uid) async {
    try {
      if (task.id == null) {
        return const Left('Task ID is required for update');
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteTask(String id, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, List<TaskModel>>>> getWeeklyTasks(
  DateTime weekStart,
  String userId,
) async {
  try {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final startDate = DateFormat('yyyy-MM-dd').format(weekStart);
    final endDate = DateFormat('yyyy-MM-dd').format(weekEnd);
    
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    final Map<String, List<TaskModel>> weeklyTasks = {};
    
    for (var doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data());
      final date = task.date;
      if (weeklyTasks[date] == null) {
        weeklyTasks[date!] = [];
      }
      weeklyTasks[date]!.add(task);
    }
    
    // Sort tasks by time for each day
    weeklyTasks.forEach((date, tasks) {
      tasks.sort((a, b) => a.time!.compareTo(b.time!));
    });

    return Right(weeklyTasks);
  } catch (e) {
    return Left(e.toString());
  }
}
}
