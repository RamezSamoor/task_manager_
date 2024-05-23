import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/core/exceptions/failure.dart';
import 'package:task_manager_app/core/model/user_info.dart';
import 'package:task_manager_app/features/auth/models/login_request_model.dart';
import 'package:task_manager_app/features/auth/repositories/auth_repository_impl.dart';
import 'package:task_manager_app/features/auth/services/auth_services.dart';
import 'package:task_manager_app/core/di/injection_container.dart' as di;

import 'auth_service_test.mocks.dart';

class AuthServiceTest extends Mock implements AuthService{}

@GenerateMocks([AuthServiceTest])
Future<void> main() async {
  late final MockAuthServiceTest mockAuthServiceTest ;
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.configure();
    mockAuthServiceTest= MockAuthServiceTest();
  });
  group('login ', () {

    test('Check login is correct', () async {
      LoginRequestModel loginRequestModel = LoginRequestModel(password: "12345" , username: "testLogin");
      UserInfo userInfo = UserInfo(username: "testLogin" , gender:"male");
      when(mockAuthServiceTest.login(loginRequestModel)).thenAnswer((_) async => userInfo );
      final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl(mockAuthServiceTest);
      final Either<Failure, UserInfo> response = await authRepositoryImpl.login(loginRequestModel);
      expect(userInfo, response.toOption().toNullable());
      expect(response.toOption().toNullable()?.username, "testLogin");
      expect(response.toOption().toNullable()?.gender, "male");
    });

    test('Return an exception when fields are Not correct', () async {
      LoginRequestModel unCorrectLoginRequestModel = LoginRequestModel(password: "12345rr" , username: "testLogin");
      when(mockAuthServiceTest.login(unCorrectLoginRequestModel)).thenThrow(DioException(response: Response(data: {"message" : "Data is Not correct"}, requestOptions: RequestOptions()), requestOptions: RequestOptions()) );
      final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl(mockAuthServiceTest);
      final Either<Failure, UserInfo> response = await authRepositoryImpl.login(unCorrectLoginRequestModel);
      assert(response.isLeft());
      response.fold((l) {
        expect(l.message, "Data is Not correct");
      }, (r) {
        assert(false);
      });

    });
  });
}
