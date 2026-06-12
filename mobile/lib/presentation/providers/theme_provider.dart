import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/data/datasources/local_storage.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(LocalStorage.instance);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorage _storage;
  static const _key = 'theme_mode';

  ThemeNotifier(this._storage) : super(ThemeMode.light) {
    _load();
  }

  void _load() {
    final saved = _storage.getString(_key);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  void toggle() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      _storage.saveString(_key, 'light');
    } else {
      state = ThemeMode.dark;
      _storage.saveString(_key, 'dark');
    }
  }
}
