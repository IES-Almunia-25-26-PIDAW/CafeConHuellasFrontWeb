import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Banner } from '../../shared/banner/banner';

@Component({
  selector: 'app-donations',
  standalone: true,
  imports: [CommonModule, RouterModule, Banner],
  templateUrl: './donations.html',
  styleUrl: './donations.css',
})
export class Donations {

}
