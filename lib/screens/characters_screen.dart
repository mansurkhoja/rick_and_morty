import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/repositories/character/character_repository.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> _characters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _characters.length,
      itemBuilder: (context, index) =>
          CharacterCard(character: _characters[index]),
    );
  }

  Future<void> _fetchCharacters() async {
    final fetched = await CharacterRepository().fetchCharacters();
    setState(() {
      _characters = fetched;
    });
  }
}
