import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/repositories/character/character_repository.dart';

class CharactersProvider extends ChangeNotifier {
  final List<Character> characters = [];
  int _page = 1;
  bool isLoading = false;
  bool hasMore = true;
  final Box favBox = Hive.box('favorites');
  final Box cacheBox = Hive.box('cache');

  void init() async {
    if (cacheBox.isNotEmpty) {
      final pages =
          cacheBox.keys.where((k) => k.toString().startsWith('page_')).toList()
            ..sort((a, b) {
              int extractNumber(String s) => int.parse(s.split('_')[1]);
              return extractNumber(a).compareTo(extractNumber(b));
            });
      _page = int.parse(pages.last.split('_').last) + 1;

      for (var key in pages) {
        final raw = cacheBox.get(key);
        final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
        characters.addAll(list.map((e) => Character.fromJson(e)));
      }
      notifyListeners();
    }
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();
    try {
      final newItems = await CharacterRepository().fetchCharacters(page: _page);
      if (newItems.isEmpty) hasMore = false;
      characters.addAll(newItems);
      cacheBox.put(
        'page_$_page',
        jsonEncode(newItems.map((e) => e.toJson()).toList()),
      );
      _page++;
    } catch (e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int id) => favBox.containsKey(id.toString());

  void toggleFavorite(Character c) {
    final key = c.id.toString();
    if (favBox.containsKey(key)) {
      favBox.delete(key);
    } else {
      favBox.put(key, jsonEncode(c.toJson()));
    }
    notifyListeners();
  }

  List<Character> get favorites {
    final characters = favBox.keys.map((k) {
      final raw = favBox.get(k);
      final map = jsonDecode(raw);
      return Character.fromJson(map);
    }).toList();

    characters.sort((a, b) => a.name.compareTo(b.name));

    return characters;
  }
}
