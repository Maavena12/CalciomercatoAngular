import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { PlayerComponent } from './player/player.component';
import { HeaderComponent } from './header/header.component';
import { HomeComponent } from './home/home.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms'
import { TeamComponent } from './team/team.component';
import { PlayerInfoComponent } from './player-info/player-info.component';
import { TeamInfoComponent } from './team-info/team-info.component';
import { MatPaginatorModule } from '@angular/material/paginator';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, PlayerComponent, HeaderComponent, HomeComponent, ReactiveFormsModule, TeamComponent, PlayerInfoComponent, TeamInfoComponent, FormsModule, MatPaginatorModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'calciomercato';
}
