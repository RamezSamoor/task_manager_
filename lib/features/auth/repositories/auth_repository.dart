import 'package:dartz/dartz.dart';


import '../../../core/exceptions/failure.dart';
import '../../../core/model/user_info.dart';
import '../models/login_request_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserInfo>> login(LoginRequestModel loginRequestModel);
}
