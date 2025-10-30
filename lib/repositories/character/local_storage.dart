import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty/models/character.dart';

/// Simple wrapper around Hive boxes used for caching pages and storing favorites.
/// This centralizes all Hive usage so UI/providers don't access Hive directly.
class LocalStorage {
  final Box _favBox = Hive.box('favorites');
  final Box _cacheBox = Hive.box('cache');

  bool get hasCache => _cacheBox.isNotEmpty;

  /// Returns the last cached page number (1-based). Returns 0 if none.
  int lastCachedPage() {
    if (_cacheBox.isEmpty) return 0;
    final pages =
        _cacheBox.keys.where((k) => k.toString().startsWith('page_')).toList()
          ..sort((a, b) {
            int extractNumber(String s) => int.parse(s.split('_')[1]);
            return extractNumber(a).compareTo(extractNumber(b));
          });
    return int.parse(pages.last.split('_').last);
  }

  /// Loads all cached pages and returns list of Characters in insertion order.
  List<Character> loadAllCachedCharacters() {
    final pages =
        _cacheBox.keys.where((k) => k.toString().startsWith('page_')).toList()
          ..sort((a, b) {
            int extractNumber(String s) => int.parse(s.split('_')[1]);
            return extractNumber(a).compareTo(extractNumber(b));
          });

    final List<Character> result = [];
    for (var key in pages) {
      final raw = _cacheBox.get(key);
      if (raw == null) continue;
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      result.addAll(list.map((e) => Character.fromJson(e)));
    }
    return result;
  }

  /// Cache a page of characters (stores JSON string under 'page_{n}').
  void cachePage(int page, List<Character> items) {
    _cacheBox.put(
      'page_$page',
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  // Favorites operations
  bool isFavorite(int id) => _favBox.containsKey(id.toString());

  void toggleFavorite(Character c) {
    final key = c.id.toString();
    if (_favBox.containsKey(key)) {
      _favBox.delete(key);
    } else {
      _favBox.put(key, jsonEncode(c.toJson()));
    }
  }

  List<Character> getFavorites() {
    final characters = _favBox.keys.map((k) {
      final raw = _favBox.get(k);
      final map = jsonDecode(raw);
      return Character.fromJson(map);
    }).toList();

    characters.sort((a, b) => a.name.compareTo(b.name));
    return characters;
  }
}
