import 'package:flutter/material.dart';


const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFDC300C),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer:
      Color(0xFFFF7366), // A slightly lighter shade for containers
  onPrimaryContainer: Color(0xFF002022),
  secondary: Color(0xFF215FA6), // A contrasting secondary color
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer:
      Color(0xFF97B4FF), // A lighter shade for secondary containers
  onSecondaryContainer: Color(0xFF001C3B),
  tertiary: Color(0xFF006874), // Another contrasting tertiary color
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer:
      Color(0xFF57C1C8), // A lighter shade for tertiary containers
  onTertiaryContainer: Color(0xFF001F24),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFAFDFC),
  onBackground: Color(0xFF191C1C),
  surface: Color(0xFFFAFDFC),
  onSurface: Color(0xFF191C1C),
  surfaceVariant: Color(0xFFDAE4E5),
  onSurfaceVariant: Color(0xFF3F4949),
  outline: Color(0xFF6F7979),
  onInverseSurface: Color(0xFFEFF1F1),
  inverseSurface: Color(0xFF2D3131),
  inversePrimary: Color(0xFF4CD9E2),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF00696E),
  outlineVariant: Color(0xFFBEC8C9),
  scrim: Color(0xFF000000),
);


const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFDC300C),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFA61E0A), // A slightly darker shade for containers
  onPrimaryContainer:
      Color(0xFFE0E0E0), // Light text color for primary container
  secondary: Color(0xFF1E88E5), // A contrasting secondary color for dark theme
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer:
      Color(0xFF3D5A80), // A darker shade for secondary containers
  onSecondaryContainer:
      Color(0xFFE0E0E0), // Light text color for secondary container
  tertiary:
      Color(0xFF00ACC1), // Another contrasting tertiary color for dark theme
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer:
      Color(0xFF5C6F85), // A darker shade for tertiary containers
  onTertiaryContainer:
      Color(0xFFE0E0E0), // Light text color for tertiary container
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1C),
  onBackground: Color(0xFFE0E3E3),
  surface: Color(0xFF191C1C),
  onSurface: Color(0xFFE0E3E3),
  surfaceVariant: Color(0xFF3F4949),
  onSurfaceVariant: Color(0xFFBEC8C9),
  outline: Color(0xFF899393),
  onInverseSurface: Color(0xFF191C1C),
  inverseSurface: Color(0xFFE0E3E3),
  inversePrimary: Color(0xFF00696E),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF4CD9E2),
  outlineVariant: Color(0xFF3F4949),
  scrim: Color(0xFF000000),
);
