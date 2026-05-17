/* TypeScript file generated from AppTypes.res by genType. */

/* eslint-disable */
/* tslint:disable */

export type contentType = 
    "Movie"
  | "TVShow"
  | "Live"
  | "Documentary"
  | "Series";

export type media = {
  readonly id: string; 
  readonly title: string; 
  readonly thumbnail: string; 
  readonly category: contentType; 
  readonly description: string; 
  readonly year: number; 
  readonly duration: string; 
  readonly rating: number
};

export type mediaDetail = {
  readonly id: string; 
  readonly tmdbType: string; 
  readonly title: string; 
  readonly tagline: string; 
  readonly overview: string; 
  readonly backdrop: string; 
  readonly poster: string; 
  readonly year: number; 
  readonly runtime: number; 
  readonly rating: number; 
  readonly genres: string[]; 
  readonly status: string; 
  readonly numberOfSeasons: number
};
