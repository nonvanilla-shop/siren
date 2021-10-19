class Version {
  final String version;

  late final int x;
  late final int y;
  late final int z;
  late final int bugfix;

  Version.from(this.version) {
    final hasBugfixNr = version.contains('+');
    bugfix = hasBugfixNr ? int.parse(version.split('+').last) : 0;
    String number = hasBugfixNr ? version.split('+').first : version;

    final versionNumbers =
        number.split('.').map((nr) => int.parse(nr)).toList();

    switch (versionNumbers.length) {
      case 1:
        x = 0;
        y = 0;
        z = versionNumbers[0];
        break;
      case 2:
        x = 0;
        y = versionNumbers[0];
        z = versionNumbers[1];
        break;
      case 3:
        x = versionNumbers[0];
        y = versionNumbers[1];
        z = versionNumbers[2];
        break;
      default:
        throw Exception('Could not parse $version into [Version] type!');
    }
  }

  bool isHigherThan(Version other) =>
      x > other.x ||
      (x == other.x && y > other.y) ||
      (x == other.x && y == other.y && z > other.z) ||
      (x == other.x && y == other.y && z == other.z && bugfix > other.bugfix);

  bool isLowerThan(Version other) => other.isHigherThan(this);

  @override
  bool operator ==(Object other) =>
      other is Version &&
      x == other.x &&
      y == other.y &&
      z == other.z &&
      bugfix == other.bugfix;

  @override
  int get hashCode => version.hashCode;

  @override
  String toString() => 'Version($version)';
}
