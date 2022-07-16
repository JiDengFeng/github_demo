import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:github_app/common/github_config.dart';
import './login_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('login')),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Obx(() => LinearProgressIndicator(
                    minHeight: 4,
                    value: controller.progress / 100,
                  )),
              Expanded(
                child: WebView(
                  initialUrl: controller.initialUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: controller.onWebViewCreated,
                  navigationDelegate: (NavigationRequest navigation) {
                    if (navigation.url.startsWith(GitHubConfig.redirectUri)) {
                      controller.loginSuccessWithUrl(navigation.url);
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  onProgress: (value) => controller.progress.value = value,
                ),
              ),
            ],
          )),
    );
  }
}
