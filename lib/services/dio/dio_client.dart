import 'dart:developer';

import 'package:dio/dio.dart';

import '../../constants/variables.dart';

class DioClient {
  static late Dio instance;

  static Future init() async {
    var dio = Dio(BaseOptions(
      baseUrl: AppUrl.baseUrl,
      sendTimeout: const Duration(seconds: 5),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));
    dio = _addInterceptor(dio);
    instance = dio;
    log("DioClient init");
  }

  static _addInterceptor(Dio dio) {
    dio.interceptors.addAll(
      [ApiInterceptors(), LoggingInterceptors()],
    );
    return dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey("requiresToken")) {
      options.headers.remove("requiresToken");
      // options.headers.addAll(
      //     {"Authorization": "Bearer ${await KeycloakClientDio.getToken()}"});
    }
    if (!options.headers.containsKey('Content-type')) {
      log('Content type not found');
      options.headers.addAll({
        "Content-Type": "application/json",
      });
    }

    super.onRequest(options, handler);
    // return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final alert = DioException.fromDioError(err.type).toString();

    err = DioError(
      requestOptions: err.requestOptions,
      error: alert,
      response: err.response,
    );
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("\n\n--> ${options.method.toUpperCase()} ${(options.baseUrl) + (options.path)}");
    log("Headers:");
    options.headers.forEach((k, v) => log('$k: $v'));
    log("queryParameters:");
    options.queryParameters.forEach((k, v) => log('$k: $v'));

    if (options.data != null) {
      log("Body: ${options.data}");
    }
    log("\n\n--> END ${options.method.toUpperCase()}");

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log("\n\n<-- error message: ${err.message} URL: ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}");
    log("data: ${err.response != null ? err.response!.data : 'Unknown Error'}");
    log("DioErrorType: ${err.type}");
    log("\n\n<-- End error");
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("\n\n<-- Statuscode: ${response.statusCode} URL: ${(response.requestOptions.baseUrl + response.requestOptions.path)}");
    log("Headers:");
    response.headers.forEach((k, v) => log('$k: $v'));
    // log("Response: ${response.data}");
    log("\n\n<-- END HTTP");
    return super.onResponse(response, handler);
  }
}

class DioException implements Exception {
  late String errorMessage;

  DioException.fromDioError(DioExceptionType dioError) {
    switch (dioError) {
      case DioExceptionType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad Certificate.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = "Bad response";
        // errorMessage = _handleStatusCode();
        break;
      case DioExceptionType.unknown:
        if (dioError.name.contains('SocketException')) {
          errorMessage = "Internet bilan aloqa uzilgan, qayta urinib koring!";
          break;
        }
        errorMessage = 'Unexpected error occurred.';
        break;
      default:
        errorMessage = 'Something went wrong';
        break;
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Status code: $statusCode';
      case 401:
        return 'Authentication failed. Status code: $statusCode';
      case 403:
        return 'The authenticated user is not allowed to access the specified API endpoint. Status code: $statusCode';
      case 404:
        return 'The requested resource does not exist. Status code: $statusCode';
      case 405:
        return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 415:
        return 'Unsupported media type. The requested content type or version number is invalid.';
      case 422:
        return 'Data validation failed.';
      case 429:
        return 'Too many requests.';
      case 500:
        return "Server bilan ulanib bo'lmadi, qayta  urinib ko'ring! Status code: $statusCode";
      case 503:
        return "Connection timed out. Status code: $statusCode";
      default:
        return 'Oops something went wrong! Status code: $statusCode';
    }
  }

  @override
  String toString() => errorMessage;
}
