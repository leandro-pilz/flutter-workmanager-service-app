import 'package:workmanager_service_poc/core/http/api.dart';
import 'package:dio/dio.dart';

base class ApiImp<T> implements Api {
  final Dio dio;

  ApiImp({required this.dio});

  @override
  Future<T> get({required String url}) async {
    try {
      final result = await dio.get(url);
      return result.data;
    } on DioException {
      rethrow;
    }
  }
}
