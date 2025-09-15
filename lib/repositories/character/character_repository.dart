import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/models/character.dart';

class CharacterRepository {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> fetchCharacters({int page = 1}) async {
    final url = Uri.parse('$_baseUrl/character?page=$page');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List).cast<Map<String, dynamic>>();
      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load characters');
    }
  }
}
