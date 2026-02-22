export interface Pet {
  id: number;
  name: string;
  species: 'Perro' | 'Gato';
  breed: string;
  age: number;
  size: 'Pequeno' | 'Mediano' | 'Grande';
  location: string;
  adopted: boolean;
  imageUrl: string;
  description: string;
  emergency: boolean;
}