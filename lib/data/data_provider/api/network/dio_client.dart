import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_example_project/utils/constants.dart';

import 'exceptions/network_exceptions.dart';


const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

// TODO: Write dio cache manager
class DioClient {
  static const int CACHE_IN_MINUTES = 30;

  final String baseUrl;

  Dio? _dio;

  final List<Interceptor>? interceptors;

  DioClient(
      this.baseUrl,
      Dio dio, {
        this.interceptors,
      }) {
    _dio = dio;
    _dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: _defaultConnectTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: _defaultReceiveTimeout)
      ..httpClientAdapter
      ..options.headers = {
        HttpHeaders.userAgentHeader: 'dio',
        'Content-Type': 'application/json',
        'X-Timezone': Constants.currentTimeZone,
        'x-app-ver': 500,
      };
    if (interceptors?.isNotEmpty ?? false) {
      _dio!.interceptors.addAll(interceptors!);
    }

    if (kDebugMode) {
      _dio!.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true));
    }
  }

  Future<dynamic> get(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool? forceRefresh,
        bool? isCache}) async {
    try {
      var response = await _dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const NetworkExceptions.formatExceptions();
    } catch (e) {
      /// Todo  rewrite this Expired session
      handleTokenExpired(e);
      rethrow;
    }
  }

  Future<dynamic> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      var response = await _dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on FormatException catch (_) {
      throw const NetworkExceptions.formatExceptions();
    } catch (e) {
      handleTokenExpired(e);
      rethrow;
    }
  }

  Future<dynamic> patch(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      var response = await _dio!.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const NetworkExceptions.formatExceptions();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    Response response;
    try {
      response = await _dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const NetworkExceptions.formatExceptions();
    } catch (e) {
      handleTokenExpired(e);
      rethrow;
    }
  }

  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      var response = await _dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const NetworkExceptions.formatExceptions();
    } catch (e) {
      handleTokenExpired(e);
      rethrow;
    }
  }


  void handleTokenExpired(rawError) {
    var error = NetworkExceptions.getDioException(rawError);
    error.maybeWhen(orElse: () {
    }, unauthorisedRequest: () {
      ///make and exception in root zone
      Future.delayed(Duration(milliseconds: 1), () {
        throw const NetworkExceptions.unauthorisedRequest();
      });
    });
  }
}
