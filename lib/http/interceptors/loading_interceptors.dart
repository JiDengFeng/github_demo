import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../http_util/http_util.dart';

const String httpLoadingStatus = 'loadingStatus';
const String httpShowLoading = 'showLoading';

class LoadingInterceptors extends InterceptorsWrapper {
  static Options getOptionsWithShowLoading({Options? options, String? status}) {
    Options temp = options ?? Options();
    temp.extra ??= {};
    temp.extra![httpShowLoading] = true;
    if (status != null) temp.extra![httpLoadingStatus] = status;
    return temp;
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra[httpShowLoading] == true) {
      EasyLoading.dismiss();
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[httpShowLoading] == true) {
      EasyLoading.show(
          status: options.extra[httpLoadingStatus], maskType: EasyLoadingMaskType.black);
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra[httpShowLoading] == true) {
      EasyLoading.dismiss();
    }
    return handler.next(response);
  }
}
