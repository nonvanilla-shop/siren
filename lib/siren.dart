library siren;

import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:siren/siren/siren_android.dart';
import 'package:siren/siren/siren_ios.dart';
import 'package:siren/siren/version.dart';

typedef VersionCallback<T> = T Function(Version oldV, Version newV);

class Siren {
  String? _package;
  Version? _currentVersion;
  Version? _newVersion;

  Future<Version> get currentVersion async =>
      _currentVersion ??
      (_currentVersion =
          Version.from((await PackageInfo.fromPlatform()).version));

  Future<String> get package async =>
      _package ?? (_package = (await PackageInfo.fromPlatform()).packageName);

  Future<Version?>? get newVersion async =>
      _newVersion ??
      (Platform.isIOS
          ? _newVersion = await SirenIOS.getVersion(bundleId: await package)
          : Platform.isAndroid
              ? _newVersion = await SirenAndroid.getVersion(from: await package)
              : throw PlatformException(
                  code: 'Platform is neither iOS nor Android!',
                ));

  Future<bool> hasNewVersion() async =>
      (await newVersion)?.isHigherThan(await currentVersion) ?? false;

  Future<T?> map<T>({
    required VersionCallback<T> onXChanged,
    required VersionCallback<T> onYChanged,
    required VersionCallback<T> onZChanged,
    required VersionCallback<T> onBugfixChanged,
  }) async {
    final oldV = await currentVersion;
    final newV = await newVersion;

    if (newV == null) return Future.value(null);

    if (oldV.x < newV.x) return onXChanged(oldV, newV);
    if (oldV.y < newV.y) return onYChanged(oldV, newV);
    if (oldV.z < newV.z) return onZChanged(oldV, newV);
    if (oldV.bugfix < newV.bugfix) return onBugfixChanged(oldV, newV);
  }
}
