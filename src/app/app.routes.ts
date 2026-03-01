import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';
import { HelpUs } from './pages/help-us/help-us';
import { Donations } from './pages/donations/donations';
import { ContactUs } from './pages/contact-us/contact-us';
import { PetDetail } from './pages/pet-detail/pet-detail';
import { Information } from './pages/information/information';
import { Events } from './pages/events/events';

export const routes: Routes = [
  { path: '', redirectTo: 'inicio', pathMatch: 'full' },
  { path: 'inicio', component: Home },
  { path: 'pets', component: Pets },
  { path: 'pet/:id', component: PetDetail },
  { path: 'help-us', component: HelpUs },
  { path: 'donations', component: Donations },
  { path: 'contact-us', component: ContactUs },
  { path: 'information', component: Information},
  { path: 'events', component: Events },
  { path: '**', redirectTo: 'inicio' },


];