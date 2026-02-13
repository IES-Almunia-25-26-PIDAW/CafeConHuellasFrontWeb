import { Pet } from '../models/pet.model';

export const PETS_MOCK: Pet[] = [
  {
    id: 1,
    name: 'Luna',
    species: 'Perro',
    breed: 'Mestiza',
    age: 2,
    size: 'Mediano',
    location: 'Madrid',
    adopted: false,
    imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=900&q=80',
    description: 'Juguetona y sociable. Le encanta correr y convivir con ninos.'
  },
  {
    id: 2,
    name: 'Milo',
    species: 'Gato',
    breed: 'Europeo comun',
    age: 1,
    size: 'Pequeno',
    location: 'Barcelona',
    adopted: false,
    imageUrl: 'https://images.unsplash.com/photo-1511044568932-338cba0ad803?auto=format&fit=crop&w=900&q=80',
    description: 'Curioso y carinoso. Ideal para piso y convivencia tranquila.'
  },
  {
    id: 3,
    name: 'Thor',
    species: 'Perro',
    breed: 'Labrador',
    age: 4,
    size: 'Grande',
    location: 'Valencia',
    adopted: true,
    imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=900&q=80',
    description: 'Muy obediente y tranquilo. Ya encontro un hogar definitivo.'
  },
  {
    id: 4,
    name: 'Nala',
    species: 'Gato',
    breed: 'Siames',
    age: 3,
    size: 'Pequeno',
    location: 'Sevilla',
    adopted: false,
    imageUrl: 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?auto=format&fit=crop&w=900&q=80',
    description: 'Activa y muy expresiva. Disfruta juegos de inteligencia.'
  }
];