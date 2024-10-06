import { Component, OnInit } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { ActivatedRoute } from '@angular/router';
import { ClientHttpService } from '../repository/client-http.service';

@Component({
  selector: 'app-team-info',
  standalone: true,
  imports: [HeaderComponent],
  templateUrl: './team-info.component.html',
  styleUrl: './team-info.component.css'
})
export class TeamInfoComponent  implements OnInit {
  name!: string;
  data: any
  teamData: any

  constructor(private route: ActivatedRoute, private service: ClientHttpService) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.name = params['name'];
    });

    this.service.getPlayerByTeamName(this.name).subscribe( 
      response => {
        console.log(response)
        this.data = response
      }
    )

    this.service.getTeamByName(this.name).subscribe( 
      response => {
        console.log(response)
        this.teamData = response
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
