import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/repositories/character/character_repository.dart';
import 'package:rick_and_morty/repositories/character/local_storage.dart';

/// Provider now receives its external dependencies via constructor injection:
/// - [repository] handles network requests
/// - [localStorage] handles caching and favorites (Hive)
class CharactersProvider extends ChangeNotifier {
  final CharacterRepository repository;
  final LocalStorage localStorage;

  CharactersProvider({required this.repository, required this.localStorage});

  final List<Character> characters = [];
  int _page = 1;
  bool isLoading = false;
  bool hasMore = true;

  void init() async {
    if (localStorage.hasCache) {
      characters.addAll(localStorage.loadAllCachedCharacters());
      final last = localStorage.lastCachedPage();
      _page = last + 1;
      notifyListeners();
    }
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();
    try {
      final newItems = await repository.fetchCharacters(page: _page);
      if (newItems.isEmpty) hasMore = false;
      characters.addAll(newItems);
      // persist cache via localStorage
      localStorage.cachePage(_page, newItems);
      _page++;
    } catch (e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int id) => localStorage.isFavorite(id);

  void toggleFavorite(Character c) {
    localStorage.toggleFavorite(c);
    notifyListeners();
  }

  List<Character> get favorites => localStorage.getFavorites();
}
