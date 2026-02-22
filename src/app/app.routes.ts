import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';
import { HelpUs } from './pages/help-us/help-us';

export const routes: Routes = [
  { path: '', redirectTo: 'inicio', pathMatch: 'full' },
  { path: 'inicio', component: Home },
  { path: 'pets', component: Pets },
  { path: 'help-us', component: HelpUs },
  { path: '**', redirectTo: 'inicio' },
];