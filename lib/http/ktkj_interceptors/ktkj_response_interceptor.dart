import 'package:dio/dio.dart';

/**
 * Response拦截器
 */
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    var value;
    try {
      var header = response.headers[Headers.contentTypeHeader];
      if ((header != null && header.toString().contains("text"))) {
      } else if (response.statusCode >= 200 && response.statusCode < 300) {}
    } catch (e) {
      print(e.toString() + option.path);
    }
    return value;
  }
}
