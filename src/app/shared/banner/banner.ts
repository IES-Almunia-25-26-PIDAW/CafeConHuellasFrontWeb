import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-banner',
  standalone: true,
  imports: [],
  templateUrl: './banner.html',
  styleUrl: './banner.css',
})
//Componente para mostrar un banner con una imagen y si queremos un mensaje de bienvenida
export class Banner {
  @Input() imageUrl: string = '';
  @Input() title: string = '';
}
