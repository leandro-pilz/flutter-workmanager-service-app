import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ConfigureDio {
  late Dio _dio;

  ConfigureDio() {
    _dio = Dio();

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    _dio.options.connectTimeout = const Duration(seconds: 45);
    _dio.options.receiveTimeout = const Duration(seconds: 45);
  }

  Dio get dio => _dio;
}
