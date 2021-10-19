import 'dart:async';
import 'package:http/http.dart';
import 'package:siren/siren/version.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class SirenAndroid {
  static Client client = Client();

  static Future<Version?> getVersion({
    required String from,
    bool throwExceptions = false,
  }) async {
    try {
      final url = Uri.parse(
          'https://play.google.com/store/apps/details?id=$from&hl=en');
      final response = await client.get(url);
      return parse(response.body).getVersion();
    } catch (e) {
      if (throwExceptions) rethrow;
    }
  }
}

extension on Document {
  Version getVersion() {
    final additionalInfoElements = getElementsByClassName('hAyfc');
    final versionElement = additionalInfoElements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    final storeVersion = versionElement.querySelector('.htlgb')!.text;
    return Version.from(storeVersion);
  }
}
