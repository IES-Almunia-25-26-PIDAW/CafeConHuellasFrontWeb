# 🐾 Café con Huellas — Frontend

Frontend web de la protectora de animales **Café con Huellas**, desarrollado en **Flutter Web** y servido con **Nginx** dentro de Docker.

---

## 📋 Requisitos previos

| Herramienta | Versión mínima |
|-------------|---------------|
| Docker | 24+ |
| Docker Compose | v2+ |

> ⚠️ **El backend debe estar levantado antes de iniciar el frontend.** Consulta el README del repositorio de backend.

---

## 🚀 Levantamiento con Docker (recomendado)

### 1. Clonar el repositorio

```bash
git clone https://github.com/IES-Almunia-25-26-PIDAW/CafeConHuellasFrontWeb.git
cd CafeConHuellasFrontWeb
```

### 2. Crear el archivo `.env`

```bash
cp .env.example .env
```

Edita `.env` con la URL donde esté corriendo el backend:

```dotenv
BACKEND_URL=http://localhost:8087
```

> Si el backend corre en otra máquina o puerto, cambia la URL aquí.

### 3. Levantar el contenedor

```bash
docker compose up -d --build
```

La primera vez tarda varios minutos porque Docker descarga la imagen de Flutter y compila la app.

### 4. Acceder a la aplicación

Abre el navegador en:

```
http://localhost:4200
```

---

## 🔧 Variables de entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `BACKEND_URL` | URL base del backend Spring Boot | `http://localhost:8087` |

> La URL del backend se hornea en el binario durante el build de Flutter con `--dart-define`. Si cambias la variable, hay que reconstruir la imagen (`--build`).

---

## 🛑 Parar el contenedor

```bash
docker compose down
```

---

## 📦 Estructura del proyecto

```
cafeconhuellas-front/
├── lib/
│   ├── config/
│   │   ├── app_router.dart          # Definición de rutas con GoRouter
│   │   └── app_theme.dart           # ThemeData global de la app
│   ├── models/
│   │   ├── event.dart               # Modelo Event
│   │   ├── pet.dart                 # Modelo Pet + enum Species
│   │   └── user.dart                # Modelos User y UserWithoutPassword
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart       # Lógica de autenticación
│   │   │   ├── auth_event.dart      # Eventos: LoginSubmitted, LogoutRequested
│   │   │   ├── auth_state.dart      # Estado: token, user, isLoading, error
│   │   │   ├── pet_bloc.dart        # Lógica de mascotas y eventos
│   │   │   ├── pet_event.dart       # Eventos: LoadPets, LoadEvents, FilterSpecies, ToggleEmergency
│   │   │   └── pet_state.dart       # Estado: pets, events, filtros, isLoading
│   │   ├── screens/
│   │   │   ├── contactus.dart       # Pantalla de contacto
│   │   │   ├── donations.dart       # Pantalla de donaciones
│   │   │   ├── events.dart          # Pantalla de eventos
│   │   │   ├── helpus_screen.dart   # Pantalla de cómo ayudar
│   │   │   ├── home_screen.dart     # Pantalla de inicio
│   │   │   ├── information_screen.dart  # Quiénes somos
│   │   │   ├── login_screen.dart    # Pantalla de login
│   │   │   ├── petdetail.dart       # Detalle de mascota
│   │   │   ├── pets_screen.dart     # Listado de mascotas
│   │   │   ├── profile_screen.dart  # Perfil del usuario
│   │   │   ├── register_screen.dart # Registro de usuario
│   │   │   └── session_expired_screen.dart  # Sesión expirada
│   │   └── widgets/
│   │       ├── actionitem.dart      # Item de "qué hacemos" en Home
│   │       ├── app_footer.dart      # Footer común
│   │       ├── app_header.dart      # Header/navbar común
│   │       ├── eventcard.dart       # Tarjeta de evento
│   │       ├── mapWidget.dart       # Widget de mapa (Google Maps)
│   │       └── petcard.dart         # Tarjeta de mascota
│   ├── theme/
│   │   └── AppColors.dart           # Paleta de colores centralizada
│   └── utils/
│       └── api_conector.dart        # Cliente HTTP centralizado
├── assets/
│   └── images/                      # Banners, iconos, imágenes de secciones
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── .env.example
└── pubspec.yaml
```

---

## 🗺️ Rutas de la aplicación

| Ruta | Pantalla |
|------|----------|
| `/` | Inicio |
| `/pets` | Listado de mascotas |
| `/pets/:id` | Detalle de mascota |
| `/information` | Quiénes somos |
| `/helpus` | Cómo ayudar |
| `/donations` | Donaciones |
| `/events` | Eventos |
| `/contactus` | Contacto |
| `/login` | Iniciar sesión |
| `/register` | Registro |
| `/profile` | Perfil de usuario |

---

## 🧱 Arquitectura

La app usa **BLoC** como gestión de estado:

- **`AuthBloc`** — Maneja login, logout y sesión del usuario. Al hacer login obtiene el token JWT y carga el perfil del usuario desde `/users/me`.
- **`PetsBloc`** — Carga mascotas y eventos desde la API. Soporta filtrado por especie y por emergencia.

La comunicación con el backend se centraliza en `ApiConector`, que lee la `BACKEND_URL` inyectada en tiempo de compilación.

---

## 🔍 Clases principales

### 🔐 AuthBloc

**Archivo:** `lib/presentation/bloc/auth_bloc.dart`

Gestiona toda la autenticación de la app. Extiende `Bloc<AuthEvent, AuthState>` y escucha dos eventos:

| Evento | Qué hace |
|--------|----------|
| `LoginSubmitted(email, password)` | Llama a la API de login, guarda el token JWT y carga el perfil del usuario con `/users/me` |
| `LogoutRequested` | Resetea el estado completo, borrando token y datos del usuario |

El estado `AuthState` contiene:
- `isAuthenticated` — si hay token válido
- `isLoading` — mientras espera respuesta de la API
- `user` — objeto `UserWithoutPassword` con los datos del perfil
- `errorMessage` — mensaje de error si el login falla

> El token JWT se guarda en el estado del BLoC (en memoria). Si el usuario recarga la página, la sesión se pierde y debe volver a iniciar sesión.

---

### 🐶 PetsBloc

**Archivo:** `lib/presentation/bloc/pet_bloc.dart`

Gestiona la carga y filtrado de mascotas y eventos. Extiende `Bloc<PetsEvent, PetsState>` y escucha cuatro eventos:

| Evento | Qué hace |
|--------|----------|
| `LoadPets` | Carga todas las mascotas desde la API y las guarda internamente |
| `LoadEvents` | Carga todos los eventos desde la API |
| `FilterSpecies(species)` | Filtra las mascotas por especie (`Perro` / `Gato` / todas) |
| `ToggleEmergency` | Activa/desactiva el filtro para mostrar solo mascotas en emergencia |

Los filtros se aplican siempre sobre la lista completa `_allPets`, por lo que cambiar un filtro no descarta los datos originales.

---

### 🐾 Modelo `Pet`

**Archivo:** `lib/models/pet.dart`

Representa una mascota de la protectora. Los campos más relevantes:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | `int` | Identificador único |
| `name` | `String` | Nombre de la mascota |
| `species` | `Species` | Enum: `perro` o `gato` |
| `breed` | `String` | Raza |
| `age` | `int` | Edad en años |
| `weight` | `double` | Peso en kg |
| `adopted` | `bool` | Si ya ha sido adoptada |
| `emergency` | `bool` | Si es un caso urgente |
| `isPpp` | `bool` | Si es raza potencialmente peligrosa |
| `neutered` | `bool` | Si está castrada |
| `imageUrl` | `String` | URL de la imagen principal |
| `imageUrls` | `List<String>` | Galería de imágenes |

El método `Pet.fromJson()` es tolerante: acepta tanto `imageUrl` como `image_url`, `isAdopted` como `adopted`, etc., para adaptarse a variaciones en la respuesta de la API.

---

### 👤 Modelos `User` y `UserWithoutPassword`

**Archivo:** `lib/models/user.dart`

Existen dos variantes del modelo de usuario:

- **`User`** — incluye el campo `password`. Se usa al enviar datos de registro.
- **`UserWithoutPassword`** — sin contraseña. Es lo que devuelve el endpoint `/users/me` y lo que se guarda en `AuthState` una vez autenticado.

Campos comunes:

| Campo | Descripción |
|-------|-------------|
| `firstName` / `lastName1` / `lastName2` | Nombre y apellidos |
| `email` | Correo electrónico |
| `phone` | Teléfono |
| `role` | Rol del usuario (`USER`, `ADMIN`, etc.) |
| `imageUrl` | Avatar del perfil |

---

### 🌐 Navegación (`GoRouter`)

**Archivo:** `lib/router/app_router.dart`

La app usa **GoRouter** para la navegación declarativa. La ruta `/pets/:id` merece especial atención: recibe el `id` por path y, opcionalmente, el objeto `Pet` completo por `state.extra` para evitar una llamada extra a la API si ya se tiene la mascota cargada en memoria.

```dart
// Si viene de la lista de mascotas, se pasa el objeto Pet directamente
// Si se accede por URL directa, se carga desde la API con el id
final Pet? selectedPet = state.extra is Pet ? state.extra as Pet : null;
return PetDetailScreen(petId: petId, pet: selectedPet);
```

---

### 🎨 Tema visual (`AppTheme` y `AppColors`)

**Archivos:** `lib/theme/AppTheme.dart` / `lib/theme/AppColors.dart`

La app tiene una paleta de colores centralizada en `AppColors`, con tonos morados, vainilla y crema que definen la identidad visual de la protectora. `AppTheme` configura el `ThemeData` global de Flutter usando Material 3, con:

- Color primario: `AppColors.purple`
- Fondo de scaffolds: `AppColors.vanilla`
- Cards con bordes redondeados y elevación suave
- Tipografías personalizadas: `WinkyMilky` (títulos) y `MilkyVintage` (texto decorativo)

---

## ⚙️ Orden de levantamiento completo

Si partes desde cero con los dos repositorios:

```bash
# 1. Backend (levanta MySQL, Mailpit y la API)
cd cafeconhuellas-backend/
docker compose up -d

# 2. Frontend (espera a que el backend esté listo)
cd cafeconhuellas-front/
docker compose up -d --build
```

Servicios disponibles tras levantar ambos:

| Servicio | URL |
|----------|-----|
| 🌐 Frontend | http://localhost:4200 |
| ⚙️ Backend API | http://localhost:8087 |
| 📧 Mailpit (emails) | http://localhost:8025 |

---

## ❓ Problemas frecuentes

**La app carga pero no se conecta al backend**
Revisa que `BACKEND_URL` en `.env` apunta a la dirección correcta y que el backend está corriendo.

**Cambié `.env` pero sigue igual**
La URL se hornea en el build. Hay que reconstruir la imagen:
```bash
docker compose up -d --build
```

**Puerto 4200 ocupado**
Cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "3000:80"   # cambia 4200 por el que quieras
```
