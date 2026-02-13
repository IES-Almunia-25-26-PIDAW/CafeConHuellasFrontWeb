import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';

export const routes: Routes = [
  { path: '', redirectTo: 'inicio', pathMatch: 'full' },
  { path: 'inicio', component: Home },
  { path: 'pets', component: Pets },
  { path: '**', redirectTo: 'inicio' },
];