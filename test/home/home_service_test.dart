import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/core/di/injection_container.dart';
import 'package:task_manager_app/core/exceptions/failure.dart';
import 'package:task_manager_app/core/repositories/main_repository.dart';

import 'package:task_manager_app/features/home/models/todo_model.dart';
import 'package:task_manager_app/features/home/repositories/home_repository_impl.dart';
import 'package:task_manager_app/features/home/services/home_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:task_manager_app/core/di/injection_container.dart' as di;

import 'home_service_test.mocks.dart';
class HomeServiceTest extends Mock implements HomeService{}

@GenerateMocks([HomeServiceTest])
Future<void> main() async {
  late final MockHomeServiceTest mockHomeServiceTest;


setUpAll(() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await di.configure();
  mockHomeServiceTest= MockHomeServiceTest();
});


  group("Get todo", () {
    final ListTodos todos = ListTodos(
        limit: 10,
        skip: 0,
        total: 150,
        todos: [
          Todos(todo: "Task1",completed: true)
        ]
    );
    test("Get Tasks", () async {
      when(mockHomeServiceTest.getTodos(any,any)).thenAnswer((_)async => todos);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, ListTodos> response = await homeRepositoryImpl.getTodos(10, 0, 1);
      expect(todos, response.toOption().toNullable());
    });

    test("Get Tasks With Correct fields", () async {
      when(mockHomeServiceTest.getTodos(any,any)).thenAnswer((_)async => todos);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, ListTodos> response = await homeRepositoryImpl.getTodos(10, 0, 1);
     // expect(todos, response.toOption().toNullable());
      expect(response.toOption().toNullable()?.todos?[0].todo,"Task1");
      expect(response.toOption().toNullable()?.todos?[0].completed,true);
      expect(response.toOption().toNullable()?.todos?.length,1);
      expect(response.toOption().toNullable()?.limit,10);
      expect(response.toOption().toNullable()?.skip,0);
      expect(response.toOption().toNullable()?.total,150);
    });

    test("Get Tasks return error when repo throw an message exception", () async {
      when(mockHomeServiceTest.getTodos(10,0)).thenThrow(DioException(response: Response(data: {"message" : "Error Happen"}, requestOptions: RequestOptions()), requestOptions: RequestOptions()));
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, ListTodos> response = await homeRepositoryImpl.getTodos(10, 0, 1);
      response.fold((l) => expect(l.message,"Error Happen"), (r) {
      });
    });
    test("Get Tasks return error when repo throw an 403 exception", () async {
      when(mockHomeServiceTest.getTodos(any,any)).thenThrow(DioException(response: Response(data: {"message" : "UnAuthorized"}, requestOptions: RequestOptions(),statusCode: 403), requestOptions: RequestOptions()));
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, ListTodos> response = await homeRepositoryImpl.getTodos(10, 0, 1);
      response.fold((l) => expect(l.message,"UnAuthorized"), (r) {
      });
    });
  });


  group("Add todo", () {
    Todos todoBody = Todos(todo: "Add New",completed: true);
    test("Add Tasks", () async {
      when(mockHomeServiceTest.addTodo(any)).thenAnswer((_)async => todoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.addTodo(todoBody);
      expect(todoBody, response.toOption().toNullable());
    });

    test("Add Tasks With Correct fields", () async {
      when(mockHomeServiceTest.addTodo(any)).thenAnswer((_)async => todoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.addTodo(todoBody);
       expect(todoBody, response.toOption().toNullable());
      expect(response.toOption().toNullable()?.todo,"Add New");
    });

    test("Add Tasks return error when repo throw an message exception", () async {
      when(mockHomeServiceTest.addTodo(any)).thenThrow(DioException(response: Response(data: {"message" : "Error when add item"}, requestOptions: RequestOptions()), requestOptions: RequestOptions()));
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.addTodo(todoBody);
       assert(response.isLeft());
      response.fold((l) => expect(l.message,"Error when add item"), (r) {
        assert(false);
      });
    });
  });

  group("Update todo", () {
    Todos updateTodoBody = Todos(todo: "Update Task",completed: true, id : 12);
    test("Update Tasks", () async {
      when(mockHomeServiceTest.updateTodo(any,any)).thenAnswer((_)async => updateTodoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.updateTodo('12',updateTodoBody);
      expect(updateTodoBody, response.toOption().toNullable());
    });

    test("Update Tasks With Correct fields", () async {
      when(mockHomeServiceTest.updateTodo(any,any)).thenAnswer((_)async => updateTodoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.updateTodo('12',updateTodoBody);
      expect(updateTodoBody, response.toOption().toNullable());
      expect(response.toOption().toNullable()?.id, 12 );
      expect(response.toOption().toNullable()?.todo, 'Update Task' );
    });

    test("Update Tasks return error when repo throw an message exception", () async {
      when(mockHomeServiceTest.updateTodo(any,any)).thenThrow(DioException(response: Response(data: {"message" : "Error when update item"}, requestOptions: RequestOptions()), requestOptions: RequestOptions()));
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.updateTodo('12',updateTodoBody);
      assert(response.isLeft());
      response.fold((l) => expect(l.message,"Error when update item"), (r) {
        assert(false);
      });
    });
  });

  group("Delete todo", () {
    Todos deleteTodoBody = Todos(todo: "Delete Task",completed: true,isDeleted: true);
    test("Delete Tasks", () async {
      when(mockHomeServiceTest.deleteTodo(12)).thenAnswer((_)async => deleteTodoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.deleteTodo(12);
      expect(deleteTodoBody, response.toOption().toNullable());
    });
    test("Delete Tasks With Correct fields", () async {
      when(mockHomeServiceTest.deleteTodo(12)).thenAnswer((_)async => deleteTodoBody);
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.deleteTodo(12);
      expect(deleteTodoBody, response.toOption().toNullable());
      expect(response.toOption().toNullable()?.isDeleted, true );
      expect(response.toOption().toNullable()?.todo, 'Delete Task' );
      expect(response.toOption().toNullable()?.completed, true );
    });
    test("Delete Tasks return error when repo throw an message exception", () async {
      when(mockHomeServiceTest.deleteTodo(12)).thenThrow(DioException(response: Response(data: {"message" : "Error when Delete item"}, requestOptions: RequestOptions()), requestOptions: RequestOptions()));
      final HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl(mockHomeServiceTest, getIt<MainRepository>());
      final Either<Failure, Todos> response = await homeRepositoryImpl.deleteTodo(12);
      assert(response.isLeft());
      response.fold((l) => expect(l.message,"Error when Delete item"), (r) {
        assert(false);
      });
    });
  });

}