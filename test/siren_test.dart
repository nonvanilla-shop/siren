import 'package:flutter_test/flutter_test.dart';
import 'package:siren/siren/siren_android.dart';

import 'package:siren/siren/siren_ios.dart';

void main() {
  test('gets new version for ios', () async {
    final version = await SirenIOS.getVersion(
      bundleId: 'com.google.Maps',
      throwExceptions: true,
      country: 'US',
    );
    expect(version, isNotNull);
  });

  test('gets new version for android', () async {
    final version = await SirenAndroid.getVersion(
      from: 'net.wooga.switchcraft.googleplay',
      throwExceptions: true,
    );
    expect(version, isNotNull);
  });
}
