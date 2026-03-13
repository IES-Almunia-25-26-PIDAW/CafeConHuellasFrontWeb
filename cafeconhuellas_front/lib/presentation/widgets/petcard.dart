import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard(this.pet);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/pets/${pet.id}'),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: pet.imageUrl.startsWith('http')
                    ? Image.network(
                        pet.imageUrl,
                        width: 220,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 220,
                            height: 180,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.pets, size: 48, color: Colors.grey),
                          );
                        },
                      )
                    : Image.asset(
                        pet.imageUrl,
                        width: 220,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: "MilkyVintage",
                ),
              ),
              const SizedBox(height: 6),
              Text('Raza: ${pet.breed}'),
              Text('Edad: ${pet.age} años'),
              Text('Ubicación: ${pet.location}'),
              Text(pet.emergency ? 'Estado: Emergencia' : 'Estado: Normal'),
            ],
          ),
        ),
      ),
    );
  }
}