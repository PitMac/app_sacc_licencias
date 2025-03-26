import 'dart:convert';

const urlServer =
    'https://portal-lasersa.controlsistemasjl.com/apilasersa/public/';

Map<String, dynamic> decodeJwtPayload(String? token) {
  if (token == null) {
    throw FormatException('Token no puede ser nulo');
  }

  final parts = token.split('.');
  if (parts.length != 3) {
    throw FormatException('Token JWT inválido');
  }

  // Decodificar la segunda parte del JWT (payload)
  String payload = parts[1];

  // Agregar el relleno necesario si la longitud no es un múltiplo de 4
  while (payload.length % 4 != 0) {
    payload += '=';
  }

  // Decodificar la cadena en base64 URL
  final decoded = utf8.decode(base64Url.decode(payload));
  return json.decode(decoded);
}

bool isTokenExpired(String token) {
  try {
    final payload = decodeJwtPayload(token);
    final exp = payload['exp'];

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return exp < now;
  } catch (e) {
    return true;
  }
}
