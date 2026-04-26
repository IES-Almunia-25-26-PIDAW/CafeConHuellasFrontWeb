import 'package:cafeconhuellas_front/models/event.dart';
import 'package:flutter_test/flutter_test.dart';

void main (){
  //aquí se harán los test del modelo event
    group 
      ('Event', (){
        test('fromJson crea correctamente un Event', (){
            final json= {
              'id': 1,
              'name': 'Evento',
              'description': 'Desc',
              'eventdate': '2024-01-01T10:00:00Z',
              'imageUrl': 'img.jpg'
            };
            final event= Event.fromJson(json);
            expect(event.id,1);
            expect(event.name, 'Evento');
      
          }
        );
        test('toJson devuelve un mapa válido', () {
          final event = Event(
            id: 1,
            name: 'Evento',
            description: 'Desc',
            imageUrl: 'img.jpg',

          );

          final json = event.toJson();

          expect(json['id'], 1);
          expect(json['name'], 'Evento');
        });

        test('copyWith modifica solo lo necesario', () {
          final event = Event(
            id: 1,
            name: 'Evento',
            description: 'Desc',
            imageUrl: 'img.jpg',
          );
          final updated = event.copyWith(name: 'Nuevo');
          expect(updated.name, 'Nuevo');
          expect(updated.id, 1);
        });
    });
}
