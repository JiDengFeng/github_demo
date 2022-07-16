import 'package:github_app/http/http_util/http_util.dart';
import 'package:github_app/http/model/user_model.dart';

class UserApi {
  static Future<HttpResponse> getUserInfo() async {
    var response = await HttpUtil.get('/user');
    if (response.ok) {
      try {
        response.data = UserModel.fromJson(response.data);
      } catch (e) {
        response = HttpResponse.failureFromError(UnknownException(e.toString()));
      }
    }
    return response;
  }

  // static Future<HttpResponse> deleteToken() async {
  //   var response = await HttpUtil.delete('uri')
  // }
}
