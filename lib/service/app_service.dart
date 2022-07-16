import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_app/http/http_util/http_util.dart';
import 'package:github_app/http/interceptors/auth_interceptors.dart';
import 'package:github_app/http/interceptors/loading_interceptors.dart';
import 'package:github_app/widget/dialog_widget/sure_dialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _saveAuthorizationKey = "SaveUserConfigKey";

const String _saveThemeModeKey = "SaveThemeModeKey";

class AppService extends GetxService {
  late SharedPreferences _preferences;

  Future<AppService> init() async {
    _preferences = await SharedPreferences.getInstance();

    HttpUtil.initDio(
        baseOptions: BaseOptions(baseUrl: 'https://api.github.com/', headers: {
          HttpHeaders.acceptHeader: "application/vnd.github+json",
          HttpHeaders.userAgentHeader: 'github_app'
        }),
        interceptors: [LoadingInterceptors(), AuthInterceptors()]);

    _authorization = getSaveString(_saveAuthorizationKey);

    String? modeString = getSaveString(_saveThemeModeKey);
    if (modeString == ThemeMode.light.toString()) {
      _themeMode = ThemeMode.light;
    } else if (modeString == ThemeMode.dark.toString()) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    return this;
  }

  String? _authorization;

  String? get authorization => _authorization;

  bool get isLogin => authorization != null && authorization!.isNotEmpty;

  set authorization(String? value) {
    if (authorization != value) {
      _authorization = value;
      saveString(_saveAuthorizationKey, _authorization);
    }
  }

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    saveString(_saveThemeModeKey, mode.toString());
  }

  Locale? _locale;

  void logout() {
    authorization = null;
  }

  Future<bool> saveString(String key, dynamic value) {
    if (value == null || value.isEmpty) {
      return _preferences.remove(key);
    } else {
      return _preferences.setString(key, value);
    }
  }

  String? getSaveString(String key) => _preferences.getString(key);
}
