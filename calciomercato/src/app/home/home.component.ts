import { Component, Input } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { ClientHttpService } from '../repository/client-http.service';
import { Player } from '../interface/player';
import { Team } from '../interface/team';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [HeaderComponent, MatPaginatorModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  teams: Array<Team>= []
  players: Array<Player>= []
  searchTerm = ''
  filteredTeams: Array<Team>= []
  filteredPlayers: Array<Player>= []
  paginatedItemsPlayers: Array<Player> = [];
  paginatedItemsTeams: Array<Team> = [];
  pageSize: number = 5;
  pageIndex: number = 0;
  pageSizeTeam: number = 5;
  pageIndexTeam: number = 0;

  constructor(private service: ClientHttpService) { }

  ngOnInit(): void {
    this.service.getPlayers().subscribe(datos => {
      for(let i = 0; i < datos.length; i++){
        this.players.push(datos[i])
      }
      this.filteredPlayers = this.players
      this.updatePaginatedItems();
    })
    this.service.getTeams().subscribe(datos => {
      for(let i = 0; i < datos.length; i++){
        this.teams.push(datos[i])
      }
      this.filteredTeams = this.teams
      this.updatePaginatedItemsTeams();
    })
  }

  onSearchTermChange(term: string): void {
    this.searchTerm = term;
    this.filterItemsTeams();
    this.filterItemsPlayers();
  }

  filterItemsTeams(): void {
    this.filteredTeams = this.teams.filter(team => {
      return team.name.toLowerCase().includes(this.searchTerm.toLowerCase())
    }
    );
  }

  filterItemsPlayers(): void {
    this.filteredPlayers = this.players.filter(player => {
      return player.firstName && player.firstName.toLowerCase().includes(this.searchTerm.toLowerCase());
    });

  }

  onPageChange(event: PageEvent) {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.updatePaginatedItems();
  }

  onPageChangeTeam(event: PageEvent) {
    this.pageIndexTeam = event.pageIndex;
    this.pageSizeTeam = event.pageSize;
    this.updatePaginatedItemsTeams();
  }

  updatePaginatedItems() {
    const startIndex = this.pageIndex * this.pageSize;
    this.paginatedItemsPlayers = this.players.slice(startIndex, startIndex + this.pageSize);
  }

  updatePaginatedItemsTeams() {
    const startIndex = this.pageIndexTeam * this.pageSizeTeam;
    this.paginatedItemsTeams = this.teams.slice(startIndex, startIndex + this.pageSizeTeam);
  }
}
