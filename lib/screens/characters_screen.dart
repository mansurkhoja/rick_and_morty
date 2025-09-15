import 'package:flutter/material.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) => CharacterCard(),
    );
  }
}
