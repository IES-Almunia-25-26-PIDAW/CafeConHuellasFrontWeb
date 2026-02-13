import { Component, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './header.html',
  styleUrl: './header.css',
})
export class Header {
  // Los desplegables por defecto están en false
  openProtectora = false;
  openActividades = false;

  // Foto por defecto del usuario, luego se cambiaría al de la BD? supongo
  userImageUrl = 'assets/user.png';

  // Alterna el menú Protectora y cierra el otro menú si está abierto
  toggleProtectora(event: MouseEvent) {
    event.stopPropagation(); // Evita que el click se propague al document
    this.openProtectora = !this.openProtectora;
    this.openActividades = false;
  }

  // Alterna el menú Actividades y cierra el otro menú si está abierto
  toggleActividades(event: MouseEvent) {
    event.stopPropagation();
    this.openActividades = !this.openActividades;
    this.openProtectora = false;
  }

  // Cierra todos los menús
  closeAll() {
    this.openProtectora = false;
    this.openActividades = false;
  }

  // Escucha cualquier click en el documento y cierra todos los men
  @HostListener('document:click')
  onDocumentClick() {
    this.closeAll();
  }
}
