import { Component } from '@angular/core';
import { ClientHttpService } from '../repository/client-http.service';
import { HeaderComponent } from '../header/header.component';
import { Player } from '../interface/player';

@Component({
  selector: 'app-player',
  standalone: true,
  imports: [HeaderComponent],
  templateUrl: './player.component.html',
  styleUrl: './player.component.css'
})
export class PlayerComponent {
  players: Array<Player>= []
  filteredPlayers: Array<Player>= []
  searchTerm = ''
 constructor(private service: ClientHttpService) { }

  ngOnInit(): void {
    this.service.getPlayers().subscribe(datos => {
        for(let i = 0; i < datos.length; i++){
          this.players.push(datos[i])
        }
      })

      this.filteredPlayers = this.players
    }

    onSearchTermChange(term: string): void {
      this.searchTerm = term;
      this.filterItemsPlayers();
    }

  
    filterItemsPlayers(): void {
      this.filteredPlayers = this.players.filter(player => {
        return player.firstName && player.firstName.toLowerCase().includes(this.searchTerm.toLowerCase());
      });
    }
}
