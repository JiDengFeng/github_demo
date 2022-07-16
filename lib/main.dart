import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:github_app/intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_app/routes/app_pages.dart';
import 'package:github_app/service/app_service.dart';
import 'package:github_app/widget/indicator_widget/custom_refresh_footer.dart';
import 'package:github_app/widget/indicator_widget/custom_refresh_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.putAsync(() => AppService().init()).whenComplete(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return refreshConfigWidget(
      child: GetMaterialApp(
        title: 'Github',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.native,
        translations: Intl(),
        locale: const Locale('zh'),
        fallbackLocale: const Locale("zh"),
        localeListResolutionCallback: (List<Locale>? locales, Iterable<Locale> supportedLocales) =>
            const Locale('zh'),
        localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) =>
            const Locale('zh'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          RefreshLocalizations.delegate,
        ],
        getPages: AppPages.routes,
        initialRoute: AppPages.initial,
        builder: EasyLoading.init(),
      ),
    );
  }

  Widget refreshConfigWidget({required Widget child}) {
    return RefreshConfiguration(
      headerBuilder: () => const CustomRefreshHeader(),
      footerBuilder: () => const CustomRefreshFooter(),
      child: child,
    );
  }
}
