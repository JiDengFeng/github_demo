import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:github_app/http/api/repo_api.dart';
import 'package:github_app/http/api/user_api.dart';
import 'package:github_app/http/model/repo_model.dart';
import 'package:github_app/http/model/user_model.dart';
import 'package:github_app/routes/app_pages.dart';
import 'package:github_app/service/app_service.dart';
import 'package:github_app/widget/dialog_widget/sure_dialog_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  late AppService _appService;

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  UserModel? user;

  List<RepoModel> repoList = [];

  bool get isLogin => _appService.isLogin;

  void loadUserInfo() async {
    var response = await UserApi.getUserInfo();
    if (response.ok) {
      user = response.data;
      update();
    }
  }

  void refreshData() async {
    var response = await RepoApi.getRepoList();
    if (isClosed) return;
    refreshController.refreshCompleted();
    if (response.ok) {
      repoList.clear();
      repoList.addAll(response.data);
      update();
    } else {
      EasyLoading.showToast(response.error?.message ?? '',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  void login() async {
    var success = await Get.toNamed(Routes.login);
    if (success == true) {
      refreshData();
      update();
    }
  }

  void logout() async {
    var r = await Get.dialog(const SureDialogWidget(
      title: '退出登录',
      content: '确定退出登录吗？',
      showCancel: true,
    ));
    if (r != true) return;
    _appService.logout();
    update();
  }

  void logonFailure() async {
    if (_appService.authorization != null) {
      await Get.dialog(const SureDialogWidget(
        title: '登录失效',
        content: '登录失效，请重新登录',
        showCancel: false,
      ));
      logout();
    }
  }

  @override
  void onReady() {
    if (isLogin) {
      refreshController.requestRefresh();
    }
    super.onReady();
  }

  @override
  void onInit() {
    _appService = Get.find<AppService>();
    super.onInit();
  }
}
