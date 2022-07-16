import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../interceptors/loading_interceptors.dart';
import 'http_response.dart';
import 'http_parse.dart';
import 'http_transformer.dart';

class HttpUtil {
  HttpUtil._();

  static late Dio _dio;

  static CancelToken? _token;

  static CancelToken get _cancelToken => _token ??= CancelToken();

  static initDio(
      {BaseOptions? baseOptions,
      String? baseUrl,
      String? cookiesPath,
      List<Interceptor>? interceptors,
      String? proxy}) {
    assert(baseOptions != null || baseUrl != null);

    BaseOptions options = baseOptions ??
        BaseOptions(
          baseUrl: baseUrl!,
          contentType: 'application/json',
          connectTimeout: 30000,
          sendTimeout: 3000,
          receiveTimeout: 30000,
        );
    _dio = Dio(options);
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
  }

  void lock() => _dio.lock();

  void unlock() => _dio.unlock();

  /// 添加拦截器
  void addInterceptor(Interceptor interceptor) {
    for (var item in _dio.interceptors) {
      if (item.runtimeType == interceptor.runtimeType) {
        return;
      }
    }
    _dio.interceptors.add(interceptor);
  }

  /// 移除拦截器
  void removeIntercept(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  /// 设置headers
  void setHeaders(Map<String, dynamic> map) {
    _dio.options.headers.addAll(map);
  }

  /// 移除header
  void removeHeader(String? key) {
    _dio.options.headers.remove(key);
  }

  static void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  static Future<HttpResponse> get(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      bool showLoading = false,
      String? loadingString,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: showLoading
            ? LoadingInterceptors.getOptionsWithShowLoading(options: options, status: loadingString)
            : options,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  static Future<HttpResponse> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      bool showLoading = false,
      String? loadingString,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: showLoading
            ? LoadingInterceptors.getOptionsWithShowLoading(options: options, status: loadingString)
            : options,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  static Future<HttpResponse> patch(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  static Future<HttpResponse> delete(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  static Future<HttpResponse> put(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  static Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? _cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
