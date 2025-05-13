import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_thems.dart';

@injectable
class ThemeCubit extends Cubit<ThemeData> {
  static const String _themeKey = 'selected_theme';
  final SharedPreferences _prefs;

  ThemeCubit(@Named('prefs') this._prefs)
    : super(AppTheme.themes[AppThemeColor.purple]!) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeIndex = _prefs.getInt(_themeKey);
    if (themeIndex != null) {
      final themeColor = AppThemeColor.values[themeIndex];
      emit(AppTheme.themes[themeColor]!);
    }
  }

  Future<void> changeTheme(AppThemeColor themeColor) async {
    await _prefs.setInt(_themeKey, themeColor.index);
    emit(AppTheme.themes[themeColor]!);
  }
}
