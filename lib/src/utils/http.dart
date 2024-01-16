import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client sslClient() {
  var ioClient = new HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  http.Client _client = IOClient(ioClient);

  return _client;
}
