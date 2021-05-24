import 'dart:io';

Future<int> checkInternetConnection() async {
  int maxRetries = 5;
  for (int i = 0; i < maxRetries; i++) {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return 0;
      }
    } on SocketException catch (_) {}
  }
  return 1;
}
