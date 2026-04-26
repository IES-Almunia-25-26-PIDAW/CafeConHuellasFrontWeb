import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';

class Globals {
  static final List<Pet> _fallbackPets = [
    Pet(id: 1, name: 'Fido', category: 'Perro', breed: 'Labrador', age: 3, adopted: false, imageUrl: 'assets/images/perrito.jpg', description: 'Friendly dog', urgentAdoption: false),
    Pet(id: 2, name: 'Whiskers', category: 'Gato', breed: 'Siamese', age: 2, adopted: false, imageUrl: 'assets/images/gatito.jpg', description: 'Playful cat', urgentAdoption: false),
    Pet(id: 3, name: 'Ushi', category: 'Perro', breed: 'Bulldog', age: 4, adopted: false, imageUrl: 'assets/images/perrito.jpg', description: 'Calm dog', urgentAdoption: false),
    Pet(id: 4, name: 'Elizabeth', category: 'Gato', breed: 'Persian', age: 1, adopted: false, imageUrl: 'assets/images/gatito.jpg', description: 'Gentle cat', urgentAdoption: false)
  
  ];
  static final List<Event> _fallbackFutureEvents = [
    Event(
      id: 1,
      name: 'Jornada de Paseo Solidario',
      imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
      description: 'Salida grupal para pasear perros del refugio y socializarlos.',
      date: DateTime(2026, 4, 12, 10, 0),
 
    ),
    Event(
      id: 2,
      name: 'Mercadillo Benefico',
      imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9',
      description: 'Venta solidaria para recaudar fondos para vacunas y alimento.',
      date: DateTime(2026, 5, 3, 11, 30),

    ),
    Event(
      id: 3,
      name: 'Charla de Tenencia Responsable',
      imageUrl: 'https://images.unsplash.com/photo-1450778869180-41d0601e046e',
      description: 'Taller practico sobre cuidados, adopcion y bienestar animal.',
      date: DateTime(2026, 6, 7, 18, 0),

    ),
    Event(
      id: 4,
      name: 'Feria de Adopcion de Verano',
      imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a',
      description: 'Encuentro con familias para impulsar adopciones responsables.',
      date: DateTime(2026, 7, 19, 9, 30),
 
    ),
  ];
  static final List<Event> _fallbackPastEvents = [
    Event(
      id: 5,
      name: 'Campana de Microchipado',
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9',
      description: 'Jornada gratuita de identificacion para perros y gatos.',
      date: DateTime(2025, 2, 15, 10, 0),
  
    ),
    Event(
      id: 6,
      name: 'Domingo de Puertas Abiertas',
      imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8',
      description: 'Visita al centro para conocer voluntariado y proceso de adopcion.',
      date: DateTime(2025, 4, 20, 12, 0),
 
    ),
    Event(
      id: 7,
      name: 'Ruta Canina Urbana',
      imageUrl: 'https://images.unsplash.com/photo-1507146426996-ef05306b995a',
      description: 'Recorrido por la ciudad para fomentar convivencia con mascotas.',
      date: DateTime(2025, 8, 10, 9, 0),
  
    ),
    Event(
      id: 8,
      name: 'Navidad Sin Abandono',
      imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
      description: 'Campana de sensibilizacion y recogida de donaciones.',
      date: DateTime(2025, 12, 14, 17, 0),

    ),
  ];

  static final List<Pet> pets = List<Pet>.from(_fallbackPets);
  static final List<Event> Futureevents = List<Event>.from(_fallbackFutureEvents);
  static final List<Event> PastEvents = List<Event>.from(_fallbackPastEvents);

  /*
  static Future<void> loadInitialData() async {
    try {
      final List<dynamic> results = await Future.wait<dynamic>([
        ApiConector().getPets(),
        ApiConector().getEvents(),
      ]);

      final List<Pet> apiPets = results[0] as List<Pet>;
      final List<Event> apiEvents = results[1] as List<Event>;

      if (apiPets.isNotEmpty) {
        pets
          ..clear()
          ..addAll(apiPets);
      }

      if (apiEvents.isNotEmpty) {
        Futureevents
          ..clear()
          ..addAll(apiEvents.where((event) => event.active));

        PastEvents
          ..clear()
          ..addAll(apiEvents.where((event) => !event.active));
      }
    } catch (_) {
      pets
        ..clear()
        ..addAll(_fallbackPets);

      Futureevents
        ..clear()
        ..addAll(_fallbackFutureEvents);

      PastEvents
        ..clear()
        ..addAll(_fallbackPastEvents);
    }
  }
  */
}