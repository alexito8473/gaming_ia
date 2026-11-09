import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({
    this.themeMode = ThemeMode.system,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String?;

    final themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == themeName,
      orElse: () => ThemeMode.system,
    );

    return ThemeState(themeMode: themeMode);
  }
}
