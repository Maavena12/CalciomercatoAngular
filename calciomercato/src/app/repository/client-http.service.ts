import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { newPlayer} from '../interface/player'
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class ClientHttpService {

  constructor(private service: HttpClient, private router: Router) { }

  getPlayers(): Observable<any>{
    return this.service.get(`${environment.apiUrl}/player`)
  }

  getPlayerByName(name: string): Observable<any>{
    return this.service.get(`${environment.apiUrl}/contract/name/${name}`)
  }

  getTeams(): Observable<any>{
    return this.service.get(`${environment.apiUrl}/team`)
  }

  getPlayerByTeamName(name: string): Observable<any>{
    return this.service.get(`${environment.apiUrl}/team/team/${name}`)
  }

  getTeamByName(name: string): Observable<any>{
    return this.service.get(`${environment.apiUrl}/team/name/${name}`)
  }

  addPlayer(datos: any) : Observable<any>{
    const resp = this.service.post(`${environment.apiUrl}/contract/`, datos)
    this.router.navigate(['/']);
    return resp
  }
}

