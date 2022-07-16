import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:github_app/common/github_config.dart';
import 'package:github_app/service/app_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginController extends GetxController {
  WebViewController? _webViewController;

  late Dio _loginDio;

  late String initialUrl;

  String? _code;

  var progress = 0.obs;

  void onWebViewCreated(WebViewController webViewController) {
    _webViewController = webViewController;
  }

  void loginSuccessWithUrl(String url) {
    _code = url.split('code=').last;
    getAccessToken();
  }

  void getAccessToken() async {
    try {
      if (_code == null) throw Exception('获取 Code 失败');
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      var response = await _loginDio.post('/login/oauth/access_token', queryParameters: {
        'client_id': GitHubConfig.clientID,
        'client_secret': GitHubConfig.clientSecret,
        'code': _code
      });
      List<String> keyValue = (response.data as String).split('&');
      String? accessToken;
      for (var item in keyValue) {
        if (item.startsWith('access_token=')) {
          accessToken = item.split('=').last;
          break;
        }
      }
      if (accessToken == null) throw Exception('获取 Token 失败');
      EasyLoading.showSuccess('登录成功');
      Get.find<AppService>().authorization = accessToken;
      Get.back(result: true);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  void onClose() {
    CookieManager().clearCookies();
    super.onClose();
  }

  @override
  void onInit() {
    _loginDio = Dio(BaseOptions(
      baseUrl: 'https://github.com',
      connectTimeout: 10000,
      sendTimeout: 1000,
      receiveTimeout: 10000,
    ));
    if (kDebugMode) {
      _loginDio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
    initialUrl =
        'https://github.com/login/oauth/authorize?client_id=${GitHubConfig.clientID}&redirect_uri=${GitHubConfig.redirectUri}';
    super.onInit();
  }
}
