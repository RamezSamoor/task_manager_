
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager_app/core/exceptions/failure.dart';
import 'package:task_manager_app/features/home/models/todo_model.dart';
import 'package:task_manager_app/features/home/repositories/home_repository.dart';
import '../../../core/repositories/main_repository.dart';
import '../services/home_services.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository{
  final HomeService _homeService;
  final MainRepository _mainRepository;
  HomeRepositoryImpl(this._homeService, this._mainRepository);

  @override
  Future<Either<Failure, ListTodos>> getTodos(int limit, int skip, int index) async {
try{
  final ListTodos? cachedTodos = _mainRepository.getTodos(index.toString());
    if(cachedTodos != null ){
    return Right(cachedTodos);
  }
  else{
     final res = await _homeService.getTodos(limit, skip);
      await _mainRepository.saveTodos(res, index.toString());
      return Right(res);
  }
}
on DioException catch(e){
  if(e.response != null){
    return Left(Failure.handle(e));
  }
  else{
    return Left(Failure( "Please check your internet"));
  }

}
  }

  @override
  Future<Either<Failure, Todos>> deleteTodo(int todoId) async {
    try{
      final res = await _homeService.deleteTodo(todoId);
      return Right(res);
    }
    catch(e){
      return Left(Failure.handle(e));
    }
  }

  @override
  Future<Either<Failure, Todos>> updateTodo(String todoId, Todos todoBody) async {
    try{
      final res = await _homeService.updateTodo(todoId, todoBody);
      return Right(res);
    }
    catch(e){
      return Left(Failure.handle(e));
    }
  }

  @override
  Future<Either<Failure, Todos>> addTodo(Todos todoBody) async {
    try{
      final res = await _homeService.addTodo(todoBody);
      return Right(res);
    }
    catch(e){
      return Left(Failure.handle(e));
    }
  }

}