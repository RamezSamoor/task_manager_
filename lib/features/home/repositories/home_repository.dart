import 'package:dartz/dartz.dart';

import '../../../core/exceptions/failure.dart';
import '../models/todo_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, ListTodos>> getTodos(int limit, int skip, int index );
  Future<Either<Failure, Todos>> deleteTodo(int todoId);
  Future<Either<Failure,Todos>> updateTodo(String todoId, Todos todoBody);
  Future<Either<Failure,Todos>> addTodo(Todos todoBody);
}