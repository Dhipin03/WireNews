import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:wirenews/model/home_screen_model.dart';

class ApiService {
  static const String _apiKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: '48264279477343ca81a8cbb122807810',
  );

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org/v2',
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Api-Key'] = _apiKey;
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('API Response [${response.statusCode}]: ${response.requestOptions.path}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('API Error [${error.response?.statusCode}]: ${error.message}');
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<NewsCategoryresModel> getnews(String categoryname) async {
    try {
      final response = await dio.get('/top-headlines', queryParameters: {
        'category': categoryname,
        'country': 'us',
      });
      return NewsCategoryresModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<NewsCategoryresModel> searchnews(String searchitem) async {
    try {
      final response = await dio.get('/everything', queryParameters: {
        'q': searchitem,
      });
      return NewsCategoryresModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Network connection timed out. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error (${error.response?.statusCode}).';
      default:
        return 'Failed to load news: ${error.message}';
    }
  }
}
