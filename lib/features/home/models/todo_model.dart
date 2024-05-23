import 'dart:convert';

class ListTodos {
  List<Todos>? todos;
  int? total;
  int? skip;
  int? limit;
  int ? index;

  ListTodos({this.todos, this.total, this.skip, this.limit, this.index});

  ListTodos.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <Todos>[];
      json['todos'].forEach((v) {
        todos!.add(new Todos.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (todos != null) {
      data['todos'] = todos!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    data['index'] = index;
    return data;
  }

  static Map<String, dynamic> toMap(ListTodos listTodos) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (listTodos.todos != null) {
      data['todos'] = listTodos.todos!.map((v) => v.toJson()).toList();
    }
    data['total'] = listTodos.total;
    data['skip'] = listTodos.skip;
    data['limit'] = listTodos.limit;
    return data;
  }
  static String encode(ListTodos listTodos) => json.encode(
    listTodos.toJson(),
  );

  static ListTodos decode(String todos) =>
      ListTodos.fromJson(json.decode(todos));
}

class Todos {
  int? id;
  String? todo;
  bool? completed;
  int? userId;
  bool? isDeleted;

  Todos({this.id, this.todo, this.completed, this.userId, this.isDeleted});

  Todos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    completed = json['completed'];
    userId = json['userId'];
    isDeleted = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo'] = this.todo;
    data['completed'] = this.completed;
    data['userId'] = this.userId;
    data.removeWhere((key, value) => value == null);
    return data;
  }

  static Map<String, dynamic> toMap(Todos todo) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = todo.id;
    data['todo'] = todo.todo;
    data['completed'] = todo.completed;
    data['userId'] = todo.userId;
    return data;
  }

  static String encode(List<Todos> todos) => json.encode(
    todos.map<Map<String, dynamic>>((todo) => Todos.toMap(todo)).toList(),
  );

  static List<Todos> decode(String todos) =>
      (json.decode(todos) as List<dynamic>)
          .map<Todos>((item) => Todos.fromJson(item))
          .toList();
}
