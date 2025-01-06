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

  loadingPlayers: boolean = true;  
  loadingTeams: boolean = true;  
  showMessage: boolean = false; 

  constructor(private service: ClientHttpService) { }

  ngOnInit(): void {  
    // Cargar jugadores  
    const playersTimer = setTimeout(() => {  
      this.showMessage = true; // Mostrar mensaje si no se carga en 20 segundos  
    }, 20000);  

    this.service.getPlayers().subscribe(datos => {  
      this.players = datos; // Asigna directamente los datos  
      this.filteredPlayers = this.players;  
      this.updatePaginatedItems();  
      this.loadingPlayers = false; // Carga completa  
      clearTimeout(playersTimer); // Limpiar el temporizador  
    }, (error) => {  
      console.error('Error al cargar jugadores', error);  
      this.loadingPlayers = false; // Cambiar a no cargando en caso de error  
      clearTimeout(playersTimer); // Limpiar el temporizador  
    });  

    // Cargar equipos  
    const teamsTimer = setTimeout(() => {  
      this.showMessage = true; // Mostrar mensaje si no se carga en 20 segundos  
    }, 20000);  

    this.service.getTeams().subscribe(datos => {  
      this.teams = datos; // Asigna directamente los datos  
      this.filteredTeams = this.teams;  
      this.updatePaginatedItemsTeams();  
      this.loadingTeams = false; // Carga completa  
      clearTimeout(teamsTimer); // Limpiar el temporizador  
    }, (error) => {  
      console.error('Error al cargar equipos', error);  
      this.loadingTeams = false; // Cambiar a no cargando en caso de error  
      clearTimeout(teamsTimer); // Limpiar el temporizador  
    });  
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
