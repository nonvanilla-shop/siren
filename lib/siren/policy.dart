import 'package:siren/siren/version.dart';

typedef VersionCallback<T> = T Function(Version oldV, Version newV);

class Policy {
  final Version oldV;
  final Version newV;

  Policy({required this.oldV, required this.newV});

  T? map<T>({
    required VersionCallback<T> onXChanged,
    required VersionCallback<T> onYChanged,
    required VersionCallback<T> onZChanged,
    required VersionCallback<T> onBugfixChanged,
  }) {
    if (oldV.x < newV.x) return onXChanged(oldV, newV);
    if (oldV.y < newV.y) return onYChanged(oldV, newV);
    if (oldV.z < newV.z) return onZChanged(oldV, newV);
    if (oldV.bugfix < newV.bugfix) return onBugfixChanged(oldV, newV);
  }
}
