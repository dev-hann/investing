import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'package:investing/const/color.dart';

/// App-wide Forui (shadcn-style) themes with the investing brand orange.
///
/// - [light]/[dark] feed [FTheme] for Forui widgets.
/// - [materialLight]/[materialDark] map the same [FColors] palette onto
///   flutter/material's [ThemeData], so screens that still use Material
///   widgets (Scaffold, AppBar, ListTile, ...) stay visually consistent with
///   the Forui widgets.
/// - Market semantic colors (up/down green/red) remain in [IVColor]; they are
///   financial conventions, not chrome, and must never be themed.
abstract final class IVTheme {
  static FThemeData light() => FThemeData(
    touch: true,
    debugLabel: 'Investing Brand Light Touch',
    colors: FColors.neutralLight.copyWith(primary: IVColor.orange),
  );

  static FThemeData dark() => FThemeData(
    touch: true,
    debugLabel: 'Investing Brand Dark Touch',
    colors: FColors.neutralDark.copyWith(primary: IVColor.orange),
  );

  /// flutter/material theme derived from the Forui light palette.
  static ThemeData materialLight() =>
      _chrome(_material(Brightness.light, light()));

  /// flutter/material theme derived from the Forui dark palette.
  static ThemeData materialDark() =>
      _chrome(_material(Brightness.dark, dark()));

  static ThemeData _material(Brightness brightness, FThemeData forui) {
    final colors = forui.colors;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.primaryForeground,
      secondary: colors.secondary,
      onSecondary: colors.secondaryForeground,
      error: colors.error,
      onError: colors.errorForeground,
      surface: colors.background,
      onSurface: colors.foreground,
      surfaceContainerHighest: colors.muted,
      onSurfaceVariant: colors.mutedForeground,
      outline: colors.border,
      outlineVariant: colors.border,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.border,
      hintColor: colors.mutedForeground,
      cardTheme: CardThemeData(color: colors.card),
    );
  }

  static ThemeData _chrome(ThemeData base) => base.copyWith(
    primaryColor: IVColor.orange,
    appBarTheme: const AppBarTheme(centerTitle: true),
    tabBarTheme: const TabBarThemeData(
      labelColor: IVColor.white,
      unselectedLabelColor: IVColor.darkWhite,
    ),
    cardTheme: CardThemeData(
      color: base.cardTheme.color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),
  );
}
