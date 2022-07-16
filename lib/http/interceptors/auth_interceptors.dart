import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:github_app/modules/home/home_controller.dart';
import '../http_util/http_util.dart';
import 'package:github_app/service/app_service.dart';

class AuthInterceptors extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      Get.find<HomeController>().logonFailure();
      handler.reject(err);
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? authorization = Get.find<AppService>().authorization;
    if (authorization != null && authorization.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'token $authorization';
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // String? authorization = response.headers.value(HttpHeaders.authorizationHeader);
    // if (authorization != null) {
    //   Get.find<AppService>().authorization = authorization;
    // }
    return handler.next(response);
  }
}
