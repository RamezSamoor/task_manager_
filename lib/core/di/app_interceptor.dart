import 'dart:developer';


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import '../../main.dart';
import '../model/user_info.dart';
import '../repositories/main_repository.dart';
import '../utils/cache_helper.dart';
import '../utils/constant.dart';
import '../utils/routing/routes.dart';
import 'injection_container.dart';

class AppInterceptor extends QueuedInterceptor {
  final Dio dio;

  AppInterceptor(this.dio);

  UserInfo? userInfo;
  Map <String, String> headers = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('body: ${options.data}');
    log('uri: ${options.uri}');
    userInfo = getIt<CacheHelper>().getUserCredentials();

    if (userInfo != null && userInfo!.token != null) {
      headers.addAll({"Authorization": "Bearer ${userInfo?.token}"});
      options.headers.addAll(headers);
      super.onRequest(options, handler);

    } else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log('onError2: $err');
    if (err.response?.statusCode == 401) {
      final RequestOptions options = err.response!.requestOptions;
      final dioRequestOptions = Options(
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          followRedirects: options.followRedirects,
          maxRedirects: options.maxRedirects,
          requestEncoder: options.requestEncoder,
          listFormat: options.listFormat,
          validateStatus: options.validateStatus,
          responseDecoder: options.responseDecoder,
          method: options.method,
          sendTimeout: options.sendTimeout,
          receiveTimeout: options.receiveTimeout,
          extra: options.extra,
          headers: options.headers,
          contentType: options.contentType);
      final tokenDio = Dio(
        BaseOptions(
            baseUrl: Constant.baseUrl,
            connectTimeout: kDebugMode ? Constant.connectTimeout : Constant
                .prodConnectTimeout,
            receiveTimeout: kDebugMode ? Constant.receiveTimeout : Constant
                .prodReceiveTimeout,
            sendTimeout: kDebugMode ? Constant.sendTimeout : Constant
                .prodSendTimeout,
            followRedirects: false),
      );

      await forceRefreshToken(tokenDio, options, dioRequestOptions, handler);
    } else {
      super.onError(err, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('onResponse: ${response.data}');
    handler.next(response);
  }

  Future<void> forceRefreshToken(Dio tokenDio, RequestOptions options,
      Options dioRequestOptions, ErrorInterceptorHandler handler) async {
    tokenDio.post(
        options: Options(headers: headers),
        '${Constant.baseUrl}auth/refresh',).whenComplete(() {}).then((value) async {
      final response = UserInfo.fromJson(value.data);
      await getIt<MainRepository>().saveUserCredentials(response);
      final res = await dio.request(options.path,
          queryParameters: options.queryParameters,
          data: options.data,
          options: dioRequestOptions);

      return handler.resolve(Response(
          requestOptions: options,
          data: res.data,
          statusCode: res.statusCode,
          headers: res.headers));

    }).catchError((e) async {
      if(navigator.currentContext!=null){
        await getIt<MainRepository>().clearLocalData();
        Navigator.pushNamedAndRemoveUntil(
            navigator.currentContext!, AppRoutes.loginRoute, (route) => false);
        return e;
      }
      return e;
    });
  }

}

