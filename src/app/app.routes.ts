import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';
import { HelpUs } from './pages/help-us/help-us';
import { PetDetail } from './pages/pet-detail/pet-detail';

export const routes: Routes = [
  { path: '', redirectTo: 'inicio', pathMatch: 'full' },
  { path: 'inicio', component: Home },
  { path: 'pets', component: Pets },
  { path: 'pet/:id', component: PetDetail },
  { path: 'help-us', component: HelpUs },
  { path: '**', redirectTo: 'inicio' },
];