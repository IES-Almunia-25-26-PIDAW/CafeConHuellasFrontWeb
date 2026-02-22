import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Pets } from './pages/pets/pets';
import { HelpUs } from './pages/help-us/help-us';

//rutas de mi aplicación
const routes: Routes= [
  { path: '', component: Home },
  { path: 'pets', component: Pets },
  { path: 'help-us', component: HelpUs }
]

@NgModule({
  declarations: [],
  imports: [RouterModule.forRoot(routes)], // IMPORTANTE: inicializa el Router
  exports: [RouterModule]   
})
export class AppRoutingModule { }
