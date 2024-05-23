import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/repositories/main_repository.dart';
import '../models/login_request_model.dart';
import '../repositories/auth_repository.dart';
import 'login_state.dart';

@lazySingleton
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final MainRepository _mainRepository;

  LoginCubit(this._authRepository, this._mainRepository)
      : super(const LoginState.initial());


  Future<String?> login(LoginRequestModel loginRequestModel) async {
    String? res;
    try {
      emit(const LoginState.loading());

      (await _authRepository.login(loginRequestModel))
          .fold((l) {
        emit(LoginState.error(l.message));
      }, (r) async {
        _mainRepository.saveUserCredentials(r);
        emit(LoginState.loaded(r));
      });
    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
    return res;
  }


}
