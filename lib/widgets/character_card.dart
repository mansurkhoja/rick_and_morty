import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onPressFavorite;
  final bool isFavorite;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onPressFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(height: 300, color: Colors.grey[300]);
                  },
                ),
              ),
              Positioned(
                top: 9,
                right: 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      size: 32,
                    ),
                    onPressed: onPressFavorite,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 12, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      '${character.status} - ${character.species}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Gender:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(character.gender, style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  'Location:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(character.locationName, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
