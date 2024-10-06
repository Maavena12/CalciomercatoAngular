import { Component, OnInit } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { ActivatedRoute } from '@angular/router';
import { ClientHttpService } from '../repository/client-http.service';

@Component({
  selector: 'app-player-info',
  standalone: true,
  imports: [HeaderComponent],
  templateUrl: './player-info.component.html',
  styleUrl: './player-info.component.css'
})
export class PlayerInfoComponent implements OnInit {
  firstName!: string;
  lastName!: string;
  data: any

  constructor(private route: ActivatedRoute, private service: ClientHttpService) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.firstName = params['name'];
      this.lastName = params['lastname'];
    });

    this.service.getPlayerByName(this.firstName).subscribe( 
      response => {
        this.data = response
      }
    )
  }

  formatDate(date: Date){
    console.log(date)
    if (date === null){
      return 
    }
    return this.dateConvert(date)
  }

  dateConvert(date: any) {
    const parts = date.split('-');
    if (parts.length !== 3) {
        throw new Error('Invalid date. Date most be yyyy/mm/dd');
    }

    const [year, month, day] = parts;
    return `${month}/${day}/${year}`;
  }
}
