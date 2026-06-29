import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<Response> post(String url, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw const ServerException();
    }
  }
}
