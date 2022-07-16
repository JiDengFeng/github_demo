import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_app/modules/home/home_bindings.dart';
import 'package:github_app/modules/home/home_page.dart';
import 'package:github_app/modules/login/login_bindings.dart';
import 'package:github_app/modules/login/login_page.dart';
import 'package:github_app/service/app_service.dart';

abstract class Routes {
  Routes._();
  static const home = '/login';
  static const login = '/home';
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final service = Get.find<AppService>();
    return service.isLogin ? null : const RouteSettings(name: Routes.login);
  }
}

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(name: Routes.login, page: () => const LoginPage(), binding: LoginBindings()),
    GetPage(name: Routes.home, page: () => const HomePage(), binding: HomeBindings())
  ];
}
