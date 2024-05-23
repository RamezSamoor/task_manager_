
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';

@freezed
class TodoState with _$TodoState {
  const factory TodoState.initial() = Initial;

  const factory TodoState.loaded() = Loaded;

  const factory TodoState.loading() = Loading;

  const factory TodoState.error(String error) = Error;
}
