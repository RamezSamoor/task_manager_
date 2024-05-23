
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/model/user_info.dart';
import '../models/login_request_model.dart';



part 'auth_services.g.dart';

@RestApi()
@LazySingleton()
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;


  @POST('auth/login')
  Future<UserInfo> login(
      @Body()LoginRequestModel loginRequestModel
      );
}
