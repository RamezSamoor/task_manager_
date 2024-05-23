import 'dart:convert';


import 'package:injectable/injectable.dart';

import '../../features/home/models/todo_model.dart';
import '../model/user_info.dart';
import '../utils/cache_helper.dart';
import '../utils/constant.dart';
import 'main_repository.dart';

@LazySingleton(as: MainRepository)
class MainRepositoryImp implements MainRepository {
  final CacheHelper _cacheHelper;
  UserInfo userInfo = UserInfo();

  MainRepositoryImp(this._cacheHelper);

  @override
  UserInfo? getUserCredentials() {
    return _cacheHelper.getUserCredentials();
  }

  @override
  Future<bool> saveUserCredentials(UserInfo? userInfo) async {
    if (userInfo == null) return false;
    return await _cacheHelper.put(
        key: Constant.userInfo, value: jsonEncode(userInfo));
  }
  @override
  Future<bool> saveTodos(ListTodos ?listOfTodo, String key) async {
    if( listOfTodo == null) return false;
    return await _cacheHelper.put(key: key, value: ListTodos.encode(listOfTodo));
  }
  @override
  ListTodos ? getTodos(key) {
    final value =_cacheHelper.getString(key:key);
    if(value != null ){
       return ListTodos.decode(value);
    }
    else{
      return null;
    }
  }


  @override
  Future<void> clearLocalData() async {
   await _cacheHelper.clear(key: Constant.userInfo);
  }

  @override
  String? getString(String key)   {
    return _cacheHelper.getString(key: key);
  }

  }
