import 'package:get/route_manager.dart';
import 'package:github_app/intl/intl_en_us.dart';
import 'package:github_app/intl/intl_zh_cn.dart';

class Intl extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_cn': zhCn,
        'en_us': enUs,
      };
}
