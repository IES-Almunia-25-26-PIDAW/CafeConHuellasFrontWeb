import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Banner } from '../../shared/banner/banner';
import type { Event as EventModel } from '../../models/event.model';

@Component({
  selector: 'app-events',
  standalone: true,
  imports: [CommonModule, Banner],
  templateUrl: './events.html',
  styleUrl: './events.css',
})
export class Events {
  activeEvents: EventModel[] = [
    {
      id: 1,
      name: 'Nombre Evento 1',
      description: 'Descripción breve del evento activo 1...',
      imageUrl: 'assets/events/activo1.jpg',
      date: '2024-06-01'
    },
    {
      id: 2,
      name: 'Nombre Evento 2',
      description: 'Descripción breve del evento activo 2...',
      imageUrl: 'assets/events/activo2.jpg',
      date: '2024-06-15'
    },
    {
      id: 3,
      name: 'Nombre Evento 3',
      description: 'Descripción breve del evento activo 3...',
      imageUrl: 'assets/events/activo3.jpg',
      date: '2024-06-30'
    }
  ];

  pastEvents: EventModel[] = [
    {
      id: 4,
      name: 'Evento pasado 1',
      description: 'Descripción del evento pasado 1...',
      imageUrl: 'assets/events/pasado1.jpg',
      date: '2024-03-20'
    },
    {
      id: 5,
      name: 'Evento pasado 2',
      description: 'Descripción del evento pasado 2...',
      imageUrl: 'assets/events/pasado2.jpg',
      date: '2024-02-12'
    }
  ];
}
