enum Team {
  flutterDevelopment,
  iosDevelopment,
  androidDevelopment,
  uiuxDesign,
}

extension TeamExtension on Team {
  String get displayName {
    switch (this) {
      case Team.flutterDevelopment:
        return 'Flutter Development Team';
      case Team.iosDevelopment:
        return 'iOS Development Team';
      case Team.androidDevelopment:
        return 'Android Development Team';
      case Team.uiuxDesign:
        return 'UI/UX Design Team';
    }
  }
}

