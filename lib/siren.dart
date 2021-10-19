library siren;

import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:siren/siren/siren_android.dart';
import 'package:siren/siren/siren_ios.dart';
import 'package:siren/siren/version.dart';

typedef VersionCallback<T> = T Function(Version oldV, Version newV);

/// This class provides access to the current and optionally the new version of
/// your app on both Android and iOS.
class Siren {
  /// Returns current app version.
  Future<Version> getCurrentVersion() async =>
      Version.from((await PackageInfo.fromPlatform()).version);

  /// Returns current package name.
  Future<String> getPackage() async =>
      (await PackageInfo.fromPlatform()).packageName;

  /// Returns the new version if it is able to get one
  Future<Version?>? getNewVersion({
    bool throwExceptions = false,
    String country = 'US',
  }) async {
    final package = await getPackage();
    return Platform.isIOS
        ? await SirenIOS.getVersion(
            bundleId: package,
            throwExceptions: throwExceptions,
            country: country,
          )
        : Platform.isAndroid
            ? await SirenAndroid.getVersion(
                from: package,
                throwExceptions: throwExceptions,
              )
            : throw PlatformException(
                code: 'Platform is neither iOS nor Android!',
              );
  }

  /// Returns true if a newer version is available.
  Future<bool> hasNewVersion() async =>
      (await getNewVersion())?.isHigherThan(await getCurrentVersion()) ?? false;

  /// Maps each individual update case. This allows for very fine grained control
  /// over what should happen depending on what kind of update happens.
  Future<T?> mapPolicy<T>({
    required VersionCallback<T> onXChanged,
    required VersionCallback<T> onYChanged,
    required VersionCallback<T> onZChanged,
    required VersionCallback<T> onBugfixChanged,
  }) async {
    final oldV = await getCurrentVersion();
    final newV = await getNewVersion();

    if (newV == null) return Future.value(null);

    if (oldV.x < newV.x) return onXChanged(oldV, newV);
    if (oldV.y < newV.y) return onYChanged(oldV, newV);
    if (oldV.z < newV.z) return onZChanged(oldV, newV);
    if (oldV.bugfix < newV.bugfix) return onBugfixChanged(oldV, newV);
  }
}
