import 'package:github_app/http/http_util/http_util.dart';
import 'package:github_app/http/model/repo_model.dart';

class RepoApi {
  static Future<HttpResponse> getRepoList() async {
    var response = await HttpUtil.get('/user/repos');
    if (response.ok) {
      try {
        List<RepoModel> repos = [];
        for (var element in response.data) {
          repos.add(RepoModel.fromJson(element));
        }
        response.data = repos;
      } catch (e) {
        response = HttpResponse.failureFromError(UnknownException(e.toString()));
      }
    }
    return response;
  }
}
