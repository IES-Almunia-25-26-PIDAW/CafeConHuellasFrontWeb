import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-help-us',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './help-us.html',
  styleUrl: './help-us.css'
})

export class HelpUs {}