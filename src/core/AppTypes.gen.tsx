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
