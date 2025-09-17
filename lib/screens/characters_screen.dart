import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/providers/characters_provider.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final provider = Provider.of<CharactersProvider>(
          context,
          listen: false,
        );
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !provider.isLoading) {
          provider.fetchNextPage();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharactersProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.characters.length,
          itemBuilder: (context, index) {
            final character = provider.characters[index];
            return CharacterCard(
              character: character,
              isFavorite: provider.isFavorite(character.id),
              onPressFavorite: () => provider.toggleFavorite(character),
            );
          },
        );
      },
    );
  }
}
