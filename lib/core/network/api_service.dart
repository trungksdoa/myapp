import 'package:dio/dio.dart';
import 'package:myapp/core/network/dio_service_old.dart';

class ApiService {
  final DioClient dio;

  ApiService(this.dio);

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      final response = await dio.post(path, data: data, options: options);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      final response = await dio.put(path, data: data, options: options);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      final response = await dio.delete(path, data: data, options: options);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
