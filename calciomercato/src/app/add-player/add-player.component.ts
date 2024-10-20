import { Component, OnInit } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { FormGroup, FormBuilder, Validators, FormControl, ReactiveFormsModule } from '@angular/forms';
import { ClientHttpService } from '../repository/client-http.service';
import { newPlayer } from '../interface/player';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-player',
  standalone: true,
  imports: [HeaderComponent, ReactiveFormsModule],
  templateUrl: './add-player.component.html',
  styleUrl: './add-player.component.css'
})
export class AddPlayerComponent {

  constructor(private service: ClientHttpService, private router: Router) { }

  profileForm = new FormGroup({
    firstName: new FormControl('', Validators.required),
    lastName: new FormControl('', Validators.required),
    position: new FormControl('', Validators.required),
    birth_date: new FormControl('', Validators.required),
    playerImage: new FormControl('', Validators.required),
    cost: new FormControl('', Validators.required),
    name: new FormControl('', Validators.required),
    country: new FormControl('', Validators.required),
    fundation: new FormControl('', Validators.required),
    teamImage: new FormControl('', Validators.required),
    games: new FormControl('', Validators.required),
    goals: new FormControl('', Validators.required),
    assits: new FormControl('', Validators.required),
    salary: new FormControl('', Validators.required),
    beginDate: new FormControl('', Validators.required),
    endDate: new FormControl('')
  });

  onSubmit() {    
    this.service.addPlayer({
      firstName: this.profileForm.value.firstName,
      lastName: this.profileForm.value.lastName,
      position: this.profileForm.value.position,
      birth_date: this.profileForm.value.birth_date,
      playerImage: this.profileForm.value.playerImage,
      cost: this.profileForm.value.cost,
      name: this.profileForm.value.name,
      country: this.profileForm.value.country,
      fundation: this.profileForm.value.fundation,
      teamImage: this.profileForm.value.teamImage,
      games: this.profileForm.value.games,
      goals: this.profileForm.value.goals,
      assits: this.profileForm.value.assits,
      salary: this.profileForm.value.salary,
      beginDate: this.profileForm.value.beginDate,
      endDate: this.profileForm.value.endDate
    }).subscribe(response => {
      alert(response)
      this.profileForm.reset()
      this.router.navigate(['/']);
    }
    )
  }

  goToHome(){
    this.router.navigate(['/']);
  }

}