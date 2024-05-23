import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/user_info.dart';
part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = Initial;

  const factory LoginState.loaded(
    UserInfo? userInfo,
  ) = Loaded;

  const factory LoginState.loading() = Loading;

  const factory LoginState.error(String error) = Error;
}
