import 'dart:convert';



import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/exceptions/failure.dart';
import '../../../core/model/user_info.dart';
import '../models/login_request_model.dart';
import '../services/auth_services.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;


  AuthRepositoryImpl(
    this._authService,
  );

  @override
  Future<Either<Failure, UserInfo>> login(LoginRequestModel loginRequestModel) async {
    try {
      final res = await _authService.login(loginRequestModel);
      return Right(res);
    } catch (e) {
      return Left((Failure.handle(e)));
    }
  }
}
