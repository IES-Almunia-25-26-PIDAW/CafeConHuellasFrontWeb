import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { PETS_MOCK } from '../../data/pets.mock';
import { Pet } from '../../models/pet.model';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './home.html',
  styleUrl: './home.css',
})
export class Home implements OnInit {

  randomPets: Pet[] = [];

  ngOnInit() {
    this.loadRandomPets();
  }

  loadRandomPets() {
    const shuffled = [...PETS_MOCK].sort(() => 0.5 - Math.random());
    this.randomPets = shuffled.slice(0, 4);
  }
}