import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { PETS_MOCK } from '../../data/pets.mock';
import { Pet } from '../../models/pet.model';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-pet-detail',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './pet-detail.html',
  styleUrl: './pet-detail.css',
})
export class PetDetail {
// variable que representa la mascota
 pet?: Pet;

  constructor(private route: ActivatedRoute) {
    //coge de los parámetros de la ruta el id, lo convierte a número y lo guarda en la variable id
    const id = Number(this.route.snapshot.paramMap.get('id'));
    //buscamos la mascota con el id que viene en la ruta, si no se encuentra se queda undefined
    this.pet = PETS_MOCK.find(p => p.id === id);
  }
}
