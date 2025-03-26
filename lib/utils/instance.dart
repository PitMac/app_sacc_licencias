import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();

  factory DioClient() {
    return _singleton;
  }

  final Dio _dio = Dio();

  DioClient._internal() {
    _dio.options.baseUrl =
        'https://sacc.sistemascontrol.ec/api_control_identificaciones/public/';
    _dio.options.headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Referrer-Policy': 'no-referrer-when-downgrade',
      'Access-Control-Allow-Origin': '*',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('userToken');
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('userToken');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
