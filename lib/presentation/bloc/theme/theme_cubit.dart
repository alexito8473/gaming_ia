import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void setThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void setSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  void setLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  void setDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }
}