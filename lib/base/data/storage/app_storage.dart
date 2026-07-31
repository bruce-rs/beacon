import 'dart:convert';

import 'package:beacon/base/enums/app_locales.dart';
import 'package:flutter/material.dart';
import 'package:sdk_helpers/sdk_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_storage_ext.dart';
part 'app_storage_keys.dart';

class AppStorage {
  AppStorage._(this._storage);

  static late final AppStorage to;

  final SharedPreferencesWithCache _storage;

  static Future<void> init() async {
    final storage = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: AppKey.values.map((e) => e.name).toSet()),
    );

    to = AppStorage._(storage);

    DartLogger.log('Initialized', name: 'AppStorage');
  }

  Future<void> write(AppKey key, String value) async {
    await _storage.setString(key.name, value);
  }

  String? read(AppKey key) => _storage.getString(key.name);

  Future<void> writeDate(AppKey key, DateTime value) async {
    await _storage.setInt(key.name, value.millisecondsSinceEpoch);
  }

  DateTime? readDate(AppKey key) {
    final timestamp = _storage.getInt(key.name);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> writeJson(AppKey key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await write(key, jsonString);
  }

  Map<String, dynamic>? readJson(AppKey key) {
    final jsonString = read(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> remove(AppKey key) async {
    await _storage.remove(key.name);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
