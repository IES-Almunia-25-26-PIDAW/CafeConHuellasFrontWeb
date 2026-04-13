import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final double? fixedWidth;

  const PetCard(this.pet, {super.key, this.fixedWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fixedWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/pets/${pet.id}', extra: pet),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 1.5),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 220;
              final nameStyle = TextStyle(
                fontSize: compact ? 17 : 20,
                fontFamily: "MilkyVintage",
              );
              final bodyStyle = TextStyle(fontSize: compact ? 12 : 14);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: pet.imageUrl.startsWith('http')
                          ? Image.network(
                              pet.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.pets, size: 48, color: Colors.grey),
                                );
                              },
                            )
                          : Image.asset(
                              pet.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.name,
                    style: nameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Raza: ${pet.breed}',
                    style: bodyStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Edad: ${pet.age} años',
                    style: bodyStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pet.emergency ? 'Estado: Emergencia' : 'Estado: Normal',
                    style: bodyStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}