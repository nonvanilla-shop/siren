library siren;

import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:siren/siren/siren_android.dart';
import 'package:siren/siren/siren_ios.dart';
import 'package:siren/siren/version.dart';
import 'package:url_launcher/url_launcher.dart';

typedef VersionCallback<T> = T Function(Future<void> Function() openStore);

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
            country: country,
          )
        : Platform.isAndroid
            ? await SirenAndroid.getVersion(from: package)
            : throw PlatformException(
                code: 'Platform is neither iOS nor Android!',
              );
  }

  /// Returns the new version if it is able to get one
  Future<void> openAppStore({
    String country = 'US',
  }) async {
    final package = await getPackage();
    final link = Platform.isIOS
        ? await SirenIOS.getStoreLink(bundleId: package, country: country)
        : Platform.isAndroid
            ? SirenAndroid.getStoreLink(bundleId: package, country: country)
            : throw PlatformException(
                code: 'Platform is neither iOS nor Android!',
              );

    await launch(link.toString());
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
    String country = 'US',
  }) async {
    final oldV = await getCurrentVersion();
    final newV = await getNewVersion();

    if (newV == null) return Future.value(null);

    Future<void> openStore() async => openAppStore(country: country);

    if (oldV.x < newV.x) return onXChanged(openStore);
    if (oldV.y < newV.y) return onYChanged(openStore);
    if (oldV.z < newV.z) return onZChanged(openStore);
    if (oldV.bugfix < newV.bugfix) return onBugfixChanged(openStore);
  }
}
