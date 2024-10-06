export interface Player {
    idPlayer: number,
    firstName: string,
    lastName: string,
    position: string,
    birth_date: Date,
    image: string,
    cost: string,
    createdDate: Date,
    modifiedDate: Date
}


export interface newPlayer {
    firstName: string | undefined | null,
    lastName: string | undefined | null,
    position: string | undefined | null,
    birth_date: Date | undefined | null,
    playerImage: string | undefined | null,
    cost: string | undefined | null,
    name: string | undefined | null,
    country: string | undefined | null,
    fundation: string | undefined | null,
    teamImage: string | undefined | null,
    games: number | undefined | null,
    goals: number | undefined | null,
    assits: number | undefined | null,
    salary: string | undefined | null,
    beginDate: Date | undefined | null,
    endDate: Date
}