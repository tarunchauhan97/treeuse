import 'dart:math' as math;

import 'package:dio/dio.dart';

const _timeStampKey = '_pdl_timeStamp_';

class Trinterceptors extends Interceptor {
  final bool logRequest;
  final bool logRequestHeader;
  final bool logRequestBody;
  final bool logResponseHeader;
  final bool logResponseBody;
  final bool logError;
  final bool compact;
  final int maxWidth;
  final bool enabled;
  final void Function(Object object) logPrint;
  final bool Function(RequestOptions options, FilterArgs args)? filter;

  Trinterceptors({
    this.logRequest = true,
    this.logRequestHeader = false,
    this.logRequestBody = false,
    this.logResponseHeader = false,
    this.logResponseBody = true,
    this.logError = true,
    this.compact = true,
    this.maxWidth = 90,
    this.enabled = true,
    this.logPrint = print,
    this.filter,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled || !_shouldLog(options, FilterArgs(false, options.data))) {
      handler.next(options);
      return;
    }

    options.extra[_timeStampKey] = DateTime.now().millisecondsSinceEpoch;

    if (logRequest) _logRequestHeader(options);
    if (logRequestHeader) _logHeadersAndExtras(options);
    if (logRequestBody && options.method != 'GET') _logRequestBody(options);

    _logCurlCommand(options); // Log the cURL command
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled || !_shouldLog(response.requestOptions, FilterArgs(true, response.data))) {
      handler.next(response);
      return;
    }

    final responseTime = _calculateElapsedTime(response.requestOptions);

    _logResponseHeader(response, responseTime);
    if (logResponseHeader) _logHeaders(response.headers.map, header: 'Response Headers');
    if (logResponseBody) _logResponseBody(response);

    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (!enabled || !_shouldLog(error.requestOptions, FilterArgs(true, error.response?.data))) {
      handler.next(error);
      return;
    }

    final responseTime = _calculateElapsedTime(error.requestOptions);

    if (logError) {
      _logErrorDetails(error, responseTime);
    }

    handler.next(error);
  }

  void _logCurlCommand(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.write('curl -X ${options.method} ');

    // Add headers
    options.headers.forEach((key, value) {
      buffer.write('-H "$key: $value" ');
    });

    // Add data
    if (options.data != null) {
      if (options.data is Map) {
        final data = options.data as Map;
        buffer.write('-d \'${Uri(queryParameters: data.cast<String, String>()).query}\' ');
      } else if (options.data is FormData) {
        final formData = options.data as FormData;
        for (var field in formData.fields) {
          buffer.write('--form "${field.key}=${field.value}" ');
        }
        for (var file in formData.files) {
          buffer.write('--form "${file.key}=@${file.value.filename}" ');
        }
      } else {
        buffer.write('-d \'${options.data}\' ');
      }
    }

    // Add URL
    buffer.write('"${options.uri}"');

    logPrint('══ cURL Command');
    logPrint(buffer.toString());
    logPrint('╚══════════════════════════════════════════════════════════════════════════════════════');
  }

  void _logRequestHeader(RequestOptions options) {
    _logBoxed('Request', '${options.method} ${options.uri}');
  }

  void _logHeadersAndExtras(RequestOptions options) {
    _logHeaders(options.headers, header: 'Request Headers');
    _logHeaders(options.queryParameters, header: 'Query Parameters');
    _logHeaders(options.extra, header: 'Extras');
  }

  void _logRequestBody(RequestOptions options) {
    final data = options.data;
    if (data is Map) {
      _logPrettyMap(data, header: 'Request Body');
    } else if (data is FormData) {
      final formDataMap = {
        for (var field in data.fields) field.key: field.value,
        for (var file in data.files) file.key: file.value,
      };
      _logPrettyMap(formDataMap, header: 'FormData');
    } else {
      _logBlock(data.toString());
    }
  }

  void _logResponseHeader(Response response, int responseTime) {
    _logBoxed(
      'Response',
      '${response.requestOptions.method} ${response.requestOptions.uri} - ${response.statusCode} (${response.statusMessage}) in $responseTime ms',
    );
  }

  void _logResponseBody(Response response) {
    if (response.data is Map) {
      _logPrettyMap(response.data as Map, header: 'Response Body');
    } else if (response.data is List) {
      _logList(response.data as List, header: 'Response List');
    } else {
      _logBlock(response.data.toString());
    }
  }

  void _logErrorDetails(DioException error, int responseTime) {
    if (error.response != null) {
      _logBoxed(
        'Error Response',
        '${error.response?.statusCode} ${error.response?.statusMessage} in $responseTime ms',
      );
      _logResponseBody(error.response!);
    } else {
      _logBoxed('Error', error.message ?? 'Unknown Error');
    }
  }

  void _logHeaders(Map? headers, {String? header}) {
    if (headers == null || headers.isEmpty) return;
    logPrint('══ $header');
    headers.forEach((key, value) {
      _logKeyValue(key, value);
    });
    _logDivider('══');
  }

  void _logPrettyMap(Map data, {String? header}) {
    logPrint('══ $header');
    data.forEach((key, value) {
      if (value is Map) {
        logPrint('$key: {');
        _logPrettyMap(value);
        logPrint('}');
      } else if (value is List) {
        logPrint('$key:');
        _logList(value);
        logPrint(']');
      } else {
        _logKeyValue(key, value);
      }
    });
    _logDivider('══');
  }

  void _logList(List list, {String? header}) {
    if (header != null) logPrint('══ $header');
    for (final element in list) {
      logPrint('$element');
    }
    _logDivider('══');
  }

  void _logBoxed(String title, String message) {
    logPrint('');
    logPrint('══ $title');
    logPrint(message);
    _logDivider('══');
  }

  void _logKeyValue(String key, Object? value) {
    final line = '$key: $value';
    if (line.length > maxWidth) {
      logPrint(line.substring(0, maxWidth));
      logPrint(line.substring(maxWidth));
    } else {
      logPrint(line);
    }
  }

  void _logBlock(String message) {
    final lines = (message.length / maxWidth).ceil();
    for (var i = 0; i < lines; i++) {
      logPrint(
        message.substring(i * maxWidth, math.min((i + 1) * maxWidth, message.length)),
      );
    }
  }

  void _logDivider(String suffix) => logPrint('╚${'═' * maxWidth}$suffix');

  bool _shouldLog(RequestOptions options, FilterArgs args) {
    return filter == null || filter!(options, args);
  }

  int _calculateElapsedTime(RequestOptions options) {
    final startTime = options.extra[_timeStampKey] as int?;
    if (startTime == null) return 0;
    return DateTime.now().millisecondsSinceEpoch - startTime;
  }
}

/// Helper class for filtering logs
class FilterArgs {
  final bool isResponse;
  final dynamic data;

  const FilterArgs(this.isResponse, this.data);
}
