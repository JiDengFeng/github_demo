import 'http_exceptions.dart';

class HttpResponse<T> {
  late bool ok;
  T? data;
  HttpException? error;

  HttpResponse.success(this.data) {
    ok = true;
  }

  HttpResponse.failure({String? errorMsg, int? errorCode}) {
    error = BadRequestException(message: errorMsg, code: errorCode);
    ok = false;
  }

  HttpResponse.failureFormResponse({dynamic data}) {
    error = BadResponseException(data);
    ok = false;
  }

  HttpResponse.failureFromError([HttpException? error]) {
    this.error = error ?? UnknownException();
    ok = false;
  }
}
