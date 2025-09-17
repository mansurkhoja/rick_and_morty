import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/providers/characters_provider.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharactersProvider>(
      builder: (context, provider, _) {
        final favorites = provider.favorites;
        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet.'));
        } else {
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(
                character: character,
                isFavorite: provider.isFavorite(character.id),
                onPressFavorite: () => provider.toggleFavorite(character),
              );
            },
          );
        }
      },
    );
  }
}
