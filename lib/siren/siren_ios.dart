import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:siren/siren/version.dart';

/// This class handles getting the newest ios version!
class SirenIOS {
  static Client client = Client();
  static const String baseUrl = 'https://itunes.apple.com/lookup';

  /// Returns the new version.
  static Future<Version?> getVersion({
    required String bundleId,
    required String country,
    required bool throwExceptions,
  }) async {
    try {
      final params = {'bundleId': bundleId, 'country': country.toUpperCase()}
          .entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');

      final url = Uri.parse('$baseUrl?$params');

      final response = await client.get(url);

      return response.getVersion();
    } catch (e) {
      if (throwExceptions) rethrow;
    }
  }
}

extension on Response {
  /// Parser extension to convert version number
  Version getVersion() {
    final json = jsonDecode(body);
    final version = json['results'][0]['version'];
    return Version.from(version);
  }
}
