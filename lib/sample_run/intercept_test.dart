import 'package:dio/dio.dart';
import 'package:treeuse/helpers/trinterceptors.dart';

void main() async {
  final dio = Dio()
    ..interceptors.add(
      Trinterceptors(
        logRequest: true,
        logRequestHeader: true,
        logRequestBody: true,
        logResponseHeader: true,
        logResponseBody: true,
        logError: true,
        compact: true,
        maxWidth: 90,
        enabled: true,
        logPrint: print,
      ),
    );
  try {
    await dio.get('https://jsonplaceholder.typicode.com/posts/1');
  } catch (e) {
    print(e);
  }
}