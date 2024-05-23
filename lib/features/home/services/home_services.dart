import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/todo_model.dart';

part 'home_services.g.dart';

@RestApi()
@LazySingleton()
abstract class HomeService {
  @factoryMethod
  factory HomeService(Dio dio) = _HomeService;


  @GET('todos')
  Future<ListTodos> getTodos(
      @Query('limit')  int limit,
      @Query('skip') int skip
      );
  @DELETE('todos/{todoId}')
  Future<Todos> deleteTodo(
      @Path('todoId') int todoId
      );
  @PUT('todos/{todoId}')
  Future<Todos> updateTodo(
      @Path('todoId') String todoId,
      @Body() Todos todoBody,
      );
  @POST('todos/add')
  Future<Todos> addTodo(
      @Body() Todos todoBody,
      );
}