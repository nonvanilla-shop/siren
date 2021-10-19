# Siren

An easy way to listen for and react to Version updates for your Flutter Android and iOS apps.

## Features

A Version number typically has the format `x.y.z+b` where b is short for small bugfix updates. This version number as a String is handled by the Version class. It also overrides equality (by simply comparing the version String values) as well as methods like `isHigherThan` and `isLowerThan` to compare version instances.

```dart
Version {
  final String version;
  late final int x;
  late final int y;
  late final int z;
  late final int bugfix;

  ...
}
```


The real magic happens in the Siren class. Wherever you want to use it, simply create an instance (you should not do this in your build method - DUH!) right then and there. You can then access the fields `getCurrentVersion(...)` and `getNewVersion(...)` or by calling the `mapPolicy` function and handling every update case there. In case there is no update `mapPolicy` simply returns null.

```dart
const siren = Siren();

siren.mapPolicy(
  onXUpdate: (_, _) => showAlertDialog(...),
  onYUpdate: (_, _) => showAlertDialog(...),
  onZUpdate: (_, _) => showAlertDialog(...),
  onBugfixUpdate: (_, _) {},
);
```

## Additional information

The issue I had with similar plugins is, that I wanted to display my custom Widgets for each individual case with different functionality. The policy I was looking to implement was the following:
- `x` part changes -> depricate older version and force user to update!
- `y` part changes -> notify user of update but give them the option to update at a later point in time.
- `z` part changes -> don't even tell the user about it. If they update (or have autoupdate active) nice otherwise we just wait for a bigger update.
- `bugfix` part changes -> same as `z`.