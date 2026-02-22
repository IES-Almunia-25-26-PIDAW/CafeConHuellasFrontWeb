import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { PETS_MOCK } from '../../data/pets.mock';
import { Pet } from '../../models/pet.model';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-pets',
  standalone: true,
  imports: [CommonModule, FormsModule,RouterModule],
  templateUrl: './pets.html',
  styleUrl: './pets.css',
})
export class Pets {
  pets: Pet[] = PETS_MOCK;
  // Variable para almacenar la especie seleccionada en el filtro
  selectedSpecies = '';
  allPets = [...this.pets];
  // variable para ver si el botón de emergencia está activo o no
  isEmergencyActive = false;

  emergencyAction() {
    this.isEmergencyActive = !this.isEmergencyActive;
    this.applyFilters();
  }
  // si selectedSpecies es vacía se muestran todas las mascotas, si no se filtran por especie
  filterPets() {
   this.applyFilters();
  }
 //método para aplicar ambos filtros a la vez, el de especie y el de emergencia
  applyFilters() {
    //recorre todas las mascotas y devuelve solo las que cumplen con los filtros seleccionados
     this.pets = this.allPets.filter(pet => {
      // la amscota se guarda si no hay especies seleccionadas o coincide con la seleccionada.
      const matchesSpecies = !this.selectedSpecies || pet.species === this.selectedSpecies;
      //se queda si el filtro de emergencia está inactivo o si la mascota esta de emergencia
      const matchesEmergency = !this.isEmergencyActive || pet.emergency;
      //usamos and lógico, solo se retorna las mascotas que cumnplan las dos listas
      return matchesSpecies && matchesEmergency;
  });
  }
}