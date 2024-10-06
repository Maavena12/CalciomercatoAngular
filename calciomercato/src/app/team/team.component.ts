import { Component } from '@angular/core';
import { ClientHttpService } from '../repository/client-http.service';
import { HeaderComponent } from '../header/header.component';
import { Team } from '../interface/team';

@Component({
  selector: 'app-team',
  standalone: true,
  imports: [HeaderComponent],
  templateUrl: './team.component.html',
  styleUrl: './team.component.css'
})
export class TeamComponent {
  teams: Array<Team>= []
  filteredTeams: Array<Team>= []
  searchTerm = ''

  constructor(private service: ClientHttpService) { }

  ngOnInit(): void {
    this.service.getTeams().subscribe(datos => {
      for(let i = 0; i < datos.length; i++){
        this.teams.push(datos[i])
      }
    })

    this.filteredTeams = this.teams
  }

  onSearchTermChange(term: string): void {
    this.searchTerm = term;
    this.filterItemsTeams();
  }

  filterItemsTeams(): void {
    this.filteredTeams = this.teams.filter(team => {
      return team.name.toLowerCase().includes(this.searchTerm.toLowerCase())
    }
    );
  }
}
