import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/providers/characters_provider.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharactersProvider>(
      builder: (context, provider, _) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              final metrics = scrollNotification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 2000 &&
                  !provider.isLoading) {
                provider.fetchNextPage();
                debugPrint('Fetching next page...');
              }
            }
            return false;
          },
          child: ListView.builder(
            primary: true,
            itemCount: provider.characters.length,
            itemBuilder: (context, index) {
              final character = provider.characters[index];
              return CharacterCard(
                character: character,
                isFavorite: provider.isFavorite(character.id),
                onPressFavorite: () => provider.toggleFavorite(character),
              );
            },
          ),
        );
      },
    );
  }
}
