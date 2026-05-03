
import 'dart:core';
import 'dart:typed_data';
import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:dio/dio.dart';

class ApiConector {
  static final ApiConector _instance = ApiConector._internal();
  factory ApiConector() {
    return _instance;
  }

  late Dio dio;
  String? _token;

  ApiConector._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'http://localhost:8087/api', // <- url base de la API, cambiar si es necesario
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    //Interceptor para agregar el token a cada petición
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

    // guardar token después del login
      void setToken(String token) {
       _token = token;
    }
//método apra cambiar foto de perfil
Future<void> updateAvatar(User user, int id) async {
  try {
    // mandamos solo imageUrl ya que es lo único que cambia
    final response = await dio.put(
      '/users/$id',
      data: {
        'id':        user.id,
        'firstName': user.firstName,
        'lastName1': user.lastName1,
        'lastName2': user.lastName2,
        'email':     user.email,
        'phone':     user.phone,
        'role':      user.role,
        'imageUrl':  user.imageUrl,
        // password vacío: el backend debería ignorarlo o tenerlo ya
        'password':  user.password.isNotEmpty ? user.password : null,
      },
    );
 
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el avatar. Código: ${response.statusCode}');
    }
  } on DioException catch (error) {
    throw Exception('Error al actualizar el avatar: ${error.message}');
  }
}


Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await dio.post(
    '/auth/login',
    data: {
      'email': email,
      'password': password,
    },
  );

  final dynamic data = response.data;
  String token = '';

  if (data is Map<String, dynamic>) {
    token = (data['token'] ?? data['accessToken'] ?? data['jwt'] ?? '').toString();

    if (token.isEmpty && data['data'] is Map<String, dynamic>) {
      final nested = data['data'] as Map<String, dynamic>;
      token = (nested['token'] ?? nested['accessToken'] ?? nested['jwt'] ?? '').toString();
    
    }

  } else if (data is String) {
    token = data;
  }

  if (token.isEmpty) {
    throw Exception('No se recibio token en la respuesta de login.');
  }

  setToken(token);
  return {'token': token};
}
// método para coger los datos del usuario que me da el token:
Future<UserWithoutPassword> getMe() async {
  final response = await dio.get('/users/me');
  final dynamic data = response.data;

  if (data is Map<String, dynamic>) {
    return UserWithoutPassword.fromJson(data);
  }

  throw Exception('Respuesta inesperada en /users/me');
}
//MÉTODO PARA UPLOAD AVATAR, tenemos q enviar el archivo como multipart/form-data y nos devuelve una url con la imagen subida, que luego podremos guardar en el perfil del usuario
Future<String> uploadAvatar(Uint8List fileBytes, String fileName) async {
  final formData = FormData.fromMap({
    'file': MultipartFile.fromBytes(
      fileBytes,
      filename: fileName,
      contentType: DioMediaType('image', fileName.endsWith('.png') ? 'png' : 'jpeg'),
    ),
  });

  final response = await dio.post(
    '/files/upload-avatar',
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  final dynamic data = response.data;
  if (data is Map<String, dynamic>) {
    final String url = (data['imageUrl'] ?? '').toString();
    if (url.isNotEmpty) return url;
  }

  throw Exception('No se recibió imageUrl en la respuesta.');
}
//método para cargar foto de los perros
Future<String> uploadPetsImage(Uint8List fileBytes, String fileName) async {
  final formData = FormData.fromMap({
    'file': MultipartFile.fromBytes(
      fileBytes,
      filename: fileName,
      contentType: DioMediaType('image', fileName.endsWith('.png') ? 'png' : 'jpeg'),
    ),
  });

  final response = await dio.post(
    '/files/upload-pet-image',
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  final dynamic data = response.data;
  if (data is Map<String, dynamic>) {
    final String url = (data['imageUrl'] ?? '').toString();
    if (url.isNotEmpty) return url;
  }

  throw Exception('No se recibió imageUrl en la respuesta.');
}
Future<String> uploadEventsImages(Uint8List fileBytes, String fileName) async {
  final formData = FormData.fromMap({
    'file': MultipartFile.fromBytes(
      fileBytes,
      filename: fileName,
      contentType: DioMediaType('image', fileName.endsWith('.png') ? 'png' : 'jpeg'),
    ),
  });

  final response = await dio.post(
    '/files/upload-event-image',
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  final dynamic data = response.data;
  if (data is Map<String, dynamic>) {
    final String url = (data['imageUrl'] ?? '').toString();
    if (url.isNotEmpty) return url;
  }

  throw Exception('No se recibió imageUrl en la respuesta.');
}

Future<void> register(Map<String, dynamic> user) async {
  final Map<String, dynamic> sanitizedUser = Map<String, dynamic>.from(user);
  final String? imageUrl = sanitizedUser['imageUrl']?.toString().trim();

  if (imageUrl == null || imageUrl.isEmpty) {
    sanitizedUser.remove('imageUrl');
  }

  try {
    await dio.post(
      '/auth/register',
      data: sanitizedUser,
    );
  } on DioException catch (error) {
  throw Exception(_extractApiErrorMessage(error));
  }
}


  Future<List<Pet>> getPets() async {
    final Response<dynamic> response = await dio.get('/pets');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Pet.fromJson)
        .toList();
  }

  Future<Pet?> getPetById(int id) async {
    try {
      final Response<dynamic> response = await dio.get('/pets/$id');
      final dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        return Pet.fromJson(data);
      }

      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return Pet.fromJson(data.first as Map<String, dynamic>);
      }
    } catch (_) {
      // Fallback to list endpoint for backends that do not expose /pets/:id.
    }

    final List<Pet> pets = await getPets();
    for (final Pet pet in pets) {
      if (pet.id == id) {
        return pet;
      }
    }

    return null;
  }
  //post de mascotas, añadir una mascota
  Future<void> addPet (Pet pet) async {
    final Map<String, dynamic> petData = pet.toJson();
    try {
      await dio.post(
        '/pets',
        data: petData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //put de mascotas, editar una mascota
  Future<void> updatePet (Pet pet) async {
    final Map<String, dynamic> petData = pet.toJson();
    print('ENVIANDO: $petData'); 
    try {
      await dio.put(
        '/pets/${pet.id}',
        data: petData,
      );
    } on DioException catch (error) {
        print('RESPUESTA ERROR: ${error.response?.data}'); 
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //delete de mascotas, eliminar una mascota
  Future<void> deletePet (int id) async {
    try {
      await dio.delete('/pets/$id');
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }

  Future<List<Event>> getEvents() async {
    final Response<dynamic> response = await dio.get('/events');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Event.fromJson)
        .toList();
  }
  //método para añadir un evento
  Future<void> addEvent (Event event) async {
    final Map<String, dynamic> eventData = event.toJson();
    try {
      await dio.post(
        '/events',
        data: eventData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //método para editar un evento
  Future<void> updateEvent (Event event) async {
    final Map<String, dynamic> eventData = event.toJson();
    try {
      await dio.put(
        '/events/${event.id}',
        data: eventData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //método para eliminar un evento
  Future<void> deleteEvent (int id) async {
    try {
      await dio.delete('/events/$id');
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //con este método aseguramos normalizar la respuesta de la Api antes de convertirla en objetos
  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      const List<String> candidateKeys = <String>[
        'data',
        'items',
        'results',
        'content',
        'pets',
        'events',
      ];

      for (final String key in candidateKeys) {
        final dynamic value = data[key];
        if (value is List) {
          return value;
        }
      }
    }

    throw DioException(
      requestOptions: RequestOptions(path: ''),
      error: 'La respuesta de la API no contiene una lista válida.',
    );
  }

  String _extractApiErrorMessage(DioException error) {
    final dynamic data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final dynamic errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((item) => item.toString()).join('\n');
      }

      final dynamic message = data['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    return error.message ?? 'No se pudo completar el registro.';
  }
  //método para cargar donaciones
  Future<List<Donation>> getDonations() async {
    final Response<dynamic> response = await dio.get('/donations');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Donation.fromJson)
        .toList();
  }

  //método para hacer una nueva donaciçon
  Future<void> addDonation (Donation donation) async {
    final Map<String, dynamic> donationData = donation.toJson();
    try {
      await dio.post(
        '/donations',
        data: donationData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  
  //método para cargar mis donaciones
  Future<List<Donation>> getMeDonation() async {
    final Response<dynamic> response = await dio.get('/donations/me');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Donation.fromJson)
        .toList();
  }

  Future <List<Userpetrelationship>> getUserPetRelationShip() async {
    final Response<dynamic> response = await dio.get('/relationships');
      final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Userpetrelationship.fromJson)
        .toList();
  }

//método para añadir una nueva relaciçon la idea es que cuando el usuario le de en la parte de ayudas etc, le salga un cuestionario en pantalla en donde pueda meter la fecha
  // de cuando le gustarçia empezar a ayudar y la fecha de tyerminar,a demás que mascota le gustaría, se guardaria como active false y cuando nosotros le aceptemos la ayuda, se pondría active a true y se le asignaría una mascota concreta, entonces el usuario podría ver en su perfil que mascota tiene asignada y durante cuanto tiempo va a ayudar, etc.
  //además mientras tanto verá pendiente, tengo idea de poner algo como /formulario:voluntariado etc y q cambie dependiendo de q botón le des
  //y desde el back te llevbara a formulario:adopcion osea desde el enlace q se le manda al mailpit del usuario,

  Future<void> addUserPetRelationship(Userpetrelationship relationship) async {
    final Map<String, dynamic> relationshipData = relationship.toJson();
    try {
      await dio.post(
        '/relationships',
        data: relationshipData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
//método para cargar mis relaciones 
  Future<List<Userpetrelationship>> getMyRelationships(int idUser) async {
    final Response<dynamic> response = await dio.get('/relationships/user/$idUser');
      final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Userpetrelationship.fromJson)
        .toList();
  }
  //método para hacer la llamada a la api y que mande por email el enlace al formulario de adopción, 
 Future<void> requestAdoptionForm(int idUser, int idPet) async {
  try {
     await dio.post(
      '/adoption-form/send',
      queryParameters: {'userId': idUser, 'petId': idPet}, // ← queryParameters, no data
    );
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}
  //método para cuando estamos en esa página que nos ha enviado el back por email pues le damos a confirmar y esto haria un nuevor egistro en adoption requet
  //luego nosotros como admin tenemos que hacer un get de toidas las adopotion request y cuando cambiemos una a estado aceptado, se hara un nuevo registro en user pet relationshjip
  Future <void> submitAdoptionForm(Map<String, dynamic> formData, String token) async {
    try {
      await dio.post('/adoption-form/submit/$token', data: formData);
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  //get para ver todas las adopciones
  Future <List<AdoptionRequest>> getAdoptionRequest() async {
    final Response<dynamic> response = await dio.get('/adoption-requests');
    final List<dynamic> items = _extractList(response.data);
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdoptionRequest.fromJson)
        .toList();
  }
  //get para ver mis adopciones
  Future <List<AdoptionRequest>> getMeAdoptionRequest() async {
    final Response<dynamic> response = await dio.get('/adoption-requests/me');
    final List<dynamic> items = _extractList(response.data);
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdoptionRequest.fromJson)
        .toList();
  }
//put para editar el status de la relación
Future<void> updateRelationshipStatus(int relationshipId, Userpetrelationship relationship) async {
  try {
    await dio.put('/relationships/$relationshipId', data: relationship.toJson());
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}

//patch para editar el status de la adopcion
Future<void> updateAdoptionStatus(int requestId, String newStatus) async {
  try {
    await dio.patch('/adoption-requests/$requestId/status', queryParameters: {'status': newStatus}); //Solo se puede pendiente aprobada o denegada
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}
//post de relaciones de usuario normal 
Future <void> postMyRelationships(Userpetrelationship relationship) async {
  final Map<String, dynamic> relationshipData = relationship.toJson();
    try {
      await dio.post(
        '/relationships/me',
        data: relationshipData,
      );
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }

  }
}