
import 'dart:io';




import '../../features/auth/models/login_request_model.dart';
import '../../features/home/models/todo_model.dart';
import '../model/user_info.dart';


abstract class MainRepository {
  UserInfo? getUserCredentials();
  Future<bool> saveUserCredentials(UserInfo ?userInfo);
  String? getString( String key);
  Future<void> clearLocalData();
  Future<bool> saveTodos(ListTodos ? listOfTodo , String key);
  ListTodos ? getTodos( String key);
}
