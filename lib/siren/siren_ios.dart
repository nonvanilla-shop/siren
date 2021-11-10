import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:siren/siren/version.dart';

/// This class handles getting the newest ios version!
class SirenIOS {
  static final Client _client = Client();
  static const String _baseUrl = 'https://itunes.apple.com/lookup';

  /// Returns the store link for the App Store.
  static Future<Uri> getStoreLink({
    required String bundleId,
    required String country,
  }) async {
    final url = _getUrl(bundleId: bundleId, country: country);
    final response = await _client.get(url);
    final trackId = response.getTrackId();

    final storeUrl = 'https://apps.apple.com/app/id$trackId?mt=8';
    return Uri.parse(storeUrl);
  }

  /// Returns the new version.
  static Future<Version?> getVersion({
    required String bundleId,
    required String country,
  }) async {
    final url = _getUrl(bundleId: bundleId, country: country);
    final response = await _client.get(url);
    return response.getVersion();
  }

  static Uri _getUrl({
    required String bundleId,
    required String country,
  }) {
    final params = {'bundleId': bundleId, 'country': country.toUpperCase()}
        .entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');

    return Uri.parse('$_baseUrl?$params');
  }
}

extension on Response {
  /// Parser extension to convert version number
  Version? getVersion() {
    final results = jsonDecode(body)['results'];
    if (results.isEmtpy) return null;
    final version = results[0]['version'];
    return Version.from(version);
  }

  /// Parser extension to convert version number
  String getTrackId() {
    final json = jsonDecode(body);
    final trackId = json['results'][0]['trackId'];
    return trackId.toString();
  }
}
