import { Routes } from '@angular/router';
import { PlayerComponent } from './player/player.component';
import { HomeComponent } from './home/home.component';
import { AddPlayerComponent } from './add-player/add-player.component';
import { TeamComponent } from './team/team.component';
import { PlayerInfoComponent } from './player-info/player-info.component';
import { TeamInfoComponent } from './team-info/team-info.component';

export const routes: Routes = [
    {
        path: '',
        component: HomeComponent
    },
    {
        path: 'player',
        component: PlayerComponent
    },
    {
        path: 'team',
        component: TeamComponent
    },
    {
        path: 'add',
        component: AddPlayerComponent
    },
    {
        path: 'playerInfo/:name/:lastname',
        component: PlayerInfoComponent
    },
    {
        path: 'teamInfo/:name',
        component: TeamInfoComponent
    }
];
