import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:github_app/http/model/repo_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (HomeController controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: controller.isLogin ? controller.logout : null,
                child: Text(controller.isLogin ? '注销' : '未登录',
                    style: const TextStyle(color: Colors.white)))
          ],
        ),
        body: controller.isLogin ? listView() : loginView(),
      );
    });
  }

  Widget listView() {
    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: () => controller.refreshData(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: controller.repoList.length,
        itemBuilder: repoItemBuilder,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
      ),
    );
  }

  Widget loginView() {
    return Center(
      child: ElevatedButton(onPressed: controller.login, child: const Text('登录')),
    );
  }

  Widget repoItemBuilder(BuildContext context, int index) {
    RepoModel repo = controller.repoList[index];
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Expanded(
                    child: Text(repo.name, style: Get.textTheme.titleMedium),
                  ),
                  Text(repo.language, style: Get.textTheme.bodySmall)
                ])),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(repo.description, style: Get.textTheme.bodyText2)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  countItemBuilder(Icons.star, repo.stargazers_count),
                  countItemBuilder(Icons.fork_left, repo.forks_count)
                      .paddingSymmetric(horizontal: 16),
                  countItemBuilder(Icons.favorite, repo.subscribers_count),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget countItemBuilder(IconData iconData, int coount) {
    TextStyle style = Get.textTheme.bodySmall!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 20,
          color: style.color,
        ),
        const SizedBox(width: 6),
        Text(coount.toString(), style: style)
      ],
    );
  }
}
