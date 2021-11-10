import 'dart:async';
import 'package:http/http.dart';
import 'package:siren/siren/version.dart';
import 'package:html/parser.dart' show parse;

/// This class handles getting the newest android version!
class SirenAndroid {
  static Client client = Client();

  /// Returns the new version.
  static Future<Version?> getVersion({
    required String from,
  }) async {
    final url =
        Uri.parse('https://play.google.com/store/apps/details?id=$from&hl=en');
    final response = await client.get(url);
    return response.body.getVersion();
  }

  /// Returns the store link for the Play Store.
  static Uri getStoreLink({
    required String bundleId,
    required String country,
  }) {
    final storeUrl = 'https://play.google.com/store/apps/details?id=$bundleId';
    return Uri.parse(storeUrl);
  }
}

extension on String {
  /// Parser extension to convert version number
  Version? getVersion() {
    try {
      final doc = parse(this);
      final additionalInfoElements = doc.getElementsByClassName('hAyfc');
      final versionElement = additionalInfoElements.firstWhere(
        (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
      );
      final storeVersion = versionElement.querySelector('.htlgb')!.text;
      return Version.from(storeVersion);
    } catch (_) {
      return null;
    }
  }
}
