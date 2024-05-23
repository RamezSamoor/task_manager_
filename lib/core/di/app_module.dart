import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constant.dart';
import 'app_interceptor.dart';

@module
abstract class AppModule {
  @preResolve // if you need to  pre resolve the value
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio {
    final aDio = Dio(
      BaseOptions(
        baseUrl: Constant.baseUrl,
        connectTimeout:  kDebugMode?Constant.connectTimeout:Constant.prodConnectTimeout,
        receiveTimeout:  kDebugMode?Constant.receiveTimeout:Constant.prodReceiveTimeout,
        sendTimeout: kDebugMode? Constant.sendTimeout:Constant.prodSendTimeout,
      ),
    );

    aDio.interceptors.add(AppInterceptor(aDio));
    return aDio;
  }
}
