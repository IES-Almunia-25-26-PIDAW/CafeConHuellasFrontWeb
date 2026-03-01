import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';
import { HelpUs } from './pages/help-us/help-us';
import { Donations } from './pages/donations/donations';
import { ContactUs } from './pages/contact-us/contact-us';
import { PetDetail } from './pages/pet-detail/pet-detail';
import { Events } from './pages/events/events';

//rutas de mi aplicación
const routes: Routes= [
  { path: '', component: Home },
  { path: 'pets', component: Pets },
  { path: 'help-us', component: HelpUs },
  { path: 'donations', component: Donations },
  { path: 'contact-us', component: ContactUs },
  { path: 'pet/:id', component: PetDetail },
  {path: 'events', component: Events }
]
  
@NgModule({
  declarations: [],
  imports: [RouterModule.forRoot(routes)], // IMPORTANTE: inicializa el Router
  exports: [RouterModule]   
})
export class AppRoutingModule { }
