import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Banner } from '../../shared/banner/banner';

@Component({
  selector: 'app-contact-us',
  standalone: true,
  imports: [CommonModule, FormsModule, Banner],
  templateUrl: './contact-us.html',
  styleUrl: './contact-us.css',
})
export class ContactUs {
  name = '';
  email = '';
  message = '';

  sendForm() {
    alert('Mensaje enviado correctamente 🐾');
    
    this.name = '';
    this.email = '';
    this.message = '';
  }

}
