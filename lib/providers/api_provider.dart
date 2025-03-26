import 'package:app_sacc_licencias/utils/instance.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>?> getLicenciasWeb() async {
    try {
      final response = await _dio.get('licencia-web/list');
      if (response.data != null && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getLicenciasMobil() async {
    try {
      final response = await _dio.get('licencia/list');
      if (response.data != null && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> postLicenciaWeb(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('licencia-web/add', data: data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
