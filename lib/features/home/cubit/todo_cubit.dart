import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager_app/features/home/cubit/todo_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_manager_app/features/home/models/todo_model.dart';
import '../../../core/repositories/main_repository.dart';
import '../../../core/utils/utitlities.dart';
import '../repositories/home_repository.dart';


@lazySingleton
class TodoCubit extends Cubit<TodoState> {
  final HomeRepository _homeRepository;
  TodoCubit(this._homeRepository) : super(const TodoState.initial());
  PagingController<int, Todos>? todoController;
  int index = 1;
  int limit = 10;

  void initController() {
    todoController = PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
    todoController?.addPageRequestListener((index) {
      this.index = index;
      getTodos(limit, (index - 1) * limit);
    });
  }

  Future<void> getTodos(int limit, int skip) async {

    if (index == 1) {
      emit(const TodoState.loading());
    }

    final result = await _homeRepository.getTodos(limit, skip,index);

    result.fold((l) {

      todoController?.error = l;
      emit(TodoState.error(l.message));

    }, (result) async {

      int lastPage = 1;
      try {
          lastPage = ((result.total ?? 0) / (result.limit ?? 1)).ceil();
        } catch (e) {}

        bool isLastPage = lastPage == index || (result.todos?.isEmpty ?? true);
        index = index + 1;
        if (isLastPage) {
          todoController?.appendLastPage(result.todos ?? []);
        } else {
          todoController?.appendPage(result.todos
              ?? [], index);
        }
        emit(const TodoState.loaded());
    });
  }

  Future<void> deleteTodo(int todoId, VoidCallback  ? onDone) async {
    emit(const TodoState.loading());
    final result = await _homeRepository.deleteTodo(todoId);
    result.fold((l) {
      emit(TodoState.error(l.message));
      showErrorMessage(l.message);
    }, (r) {
      if(onDone != null){
        onDone();
      }
      emit(const TodoState.loaded());
    });
  }

  Future<void> updateTodo(String todoId, Todos todoBody, VoidCallback? onDone) async {
    emit(const TodoState.loading());
    final result = await _homeRepository.updateTodo(todoId, todoBody);
    result.fold((l) {
      emit(TodoState.error(l.message));
      showErrorMessage(l.message);
    }, (r) {
      if(onDone != null){
        onDone();
      }
      emit(const TodoState.loaded());
    });
  }

  Future<void> addTodo(Todos todoBody) async {
    emit(const TodoState.loading());
    final result = await _homeRepository.addTodo(todoBody);
    result.fold((l) {
      emit(TodoState.error(l.message));
      showErrorMessage(l.message);
    }, (r) {
      todoController?.itemList?.insert(0,r);
      todoController?.appendPage(todoController?.itemList??[], 1);
      emit(const TodoState.loaded());
    }
    );
  }

  void refreshPage(){
    emit(const TodoState.initial());
    emit(const TodoState.loaded());
  }
}
