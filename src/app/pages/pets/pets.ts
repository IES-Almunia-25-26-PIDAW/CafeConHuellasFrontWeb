import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { PETS_MOCK } from '../../data/pets.mock';
import { Pet } from '../../models/pet.model';

@Component({
  selector: 'app-pets',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './pets.html',
  styleUrl: './pets.css',
})
export class Pets {
  pets: Pet[] = PETS_MOCK;
  selectedSpecies = '';
  allPets = [...this.pets];

  emergencyAction() {
    alert('Emergencia activada! Contactando con refugios...');
  }

  filterPets() {
    if (!this.selectedSpecies) {
      this.pets = this.allPets;
      return;
    }

    this.pets = this.allPets.filter((pet) => pet.species === this.selectedSpecies);
  }
}