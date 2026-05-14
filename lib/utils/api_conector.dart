import 'dart:core';
import 'dart:typed_data';
import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:dio/dio.dart';


/// Main API service class responsible for
/// all HTTP communication with the backend.
///
/// This class:
/// - Handles authentication.
/// - Manages pets, events, donations, and relationships.
/// - Uploads images.
/// - Sends adoption requests.
/// - Centralizes API error handling.
///
/// Implemented as a Singleton to ensure
/// a single Dio instance across the app.

class ApiConector {
  /// Singleton instance.
  static final ApiConector _instance = ApiConector._internal();
  factory ApiConector() {
    return _instance;
  }
  /// Dio HTTP client instance configured for API communication.
  late Dio dio;
  /// Authentication token used in
  /// authorized API requests.
  String? _token;

  /// Private constructor that initializes:
  /// - Dio configuration.
  /// - Base API URL.
  /// - Timeouts.
  /// - Global headers.
  /// - Authentication interceptor.
  ApiConector._internal() {
    dio = Dio(
      /// Base options for all API requests, including:
      /// - Base URL of the API.
      BaseOptions(
        baseUrl:
            'http://localhost:8087/api', // <- base API url, change if needed
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    // Interceptor used to automatically
    // attach the JWT token to every request.
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

      /// Save token after login.
      /// Stores the authentication token
      /// used for future API requests.
      void setToken(String token) {
       _token = token;
    }
  // Method used to update the user's avatar.
  /// Updates the authenticated user's avatar.
  ///
  /// Sends a PUT request containing
  /// updated user information.
  ///
  /// Only the imageUrl is expected
  /// to change.
  Future<void> updateAvatar(User user, int id) async {
    try {
      // just send the imageUrl to update the avatar, the backend should ignore the rest of the fields
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
          
          // Empty password should be ignored
          // by the backend.
          'password':  user.password.isNotEmpty ? user.password : null,
        },
      );
  
      if (response.statusCode != 200) {
        throw Exception('Failed to update avatar. Status code: ${response.statusCode}');
      }
    } on DioException catch (error) {
      throw Exception('Failed to update avatar: ${error.message}');
    }
  }

  /// Authenticates a user using
  /// email and password credentials.
  ///
  /// Returns:
  /// - JWT token map.
  ///
  /// Automatically stores the token
  /// using [setToken].
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
      throw Exception('No token received in login response.');
    }

    setToken(token);
    return {'token': token};
  }
  // Method used to retrieve the
  // authenticated user's information.
  /// Fetches the authenticated user's data
  /// using the stored JWT token.
  Future<UserWithoutPassword> getMe() async {
    final response = await dio.get('/users/me');
    final dynamic data = response.data;

    if (data is Map<String, dynamic>) {
      return UserWithoutPassword.fromJson(data);
    }

    throw Exception('Unexpected response from /users/me');
  }
  // Method used to upload user avatars.
  /// Uploads a user avatar image
  /// using multipart/form-data.
  ///
  /// Returns the uploaded image URL.
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

    throw Exception('No imageUrl received in response.');
  }
  // Method used to upload pet images.
  /// Uploads a pet image
  /// using multipart/form-data.
  ///
  /// Returns the uploaded image URL.
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

  throw Exception('No imageUrl received in response.');
}
  // Method used to upload event images.
  /// Uploads an event image
  /// using multipart/form-data.
  ///
  /// Returns the uploaded image URL.
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

  throw Exception('No imageUrl received in response.');
}

  // Method used to register a new user.
  /// Registers a new user account.
  ///
  /// Strips empty imageUrl before sending
  /// to avoid backend validation errors.
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

  // Method used to fetch all available pets.
  Future<List<Pet>> getPets() async {
    final Response<dynamic> response = await dio.get('/pets');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Pet.fromJson)
        .toList();
  }

  // Method used to fetch a single pet by id.
  // Falls back to the full list endpoint if /pets/:id is not available.
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
  // Method used to add a new pet.
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
  // Method used to update an existing pet.
  Future<void> updatePet (Pet pet) async {
    final Map<String, dynamic> petData = pet.toJson();
    print('SENDING: $petData'); 
    try {
      await dio.put(
        '/pets/${pet.id}',
        data: petData,
      );
    } on DioException catch (error) {
        print('ERROR RESPONSE: ${error.response?.data}'); 
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  // Method used to delete a pet by id.
  Future<void> deletePet (int id) async {
    try {
      await dio.delete('/pets/$id');
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }

  // Method used to fetch all available events.
  Future<List<Event>> getEvents() async {
    final Response<dynamic> response = await dio.get('/events');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Event.fromJson)
        .toList();
  }
  // Method used to add a new event.
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
  // Method used to update an existing event.
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
  // Method used to delete an event by id.
  Future<void> deleteEvent (int id) async {
    try {
      await dio.delete('/events/$id');
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  // Helper used to normalize API list responses
  // before mapping them into model objects.
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
      error: 'API response does not contain a valid list.',
    );
  }

  // Helper used to extract a readable error message
  // from a DioException response body.
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

    return 'Could not complete the request due to a server error.';
  }
  // Method used to fetch all donations.
  Future<List<Donation>> getDonations() async {
    final Response<dynamic> response = await dio.get('/donations');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Donation.fromJson)
        .toList();
  }

  // Method used to submit a new donation.
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
  
  // Method used to fetch the authenticated user's donations.
  Future<List<Donation>> getMeDonation() async {
    final Response<dynamic> response = await dio.get('/donations/me');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Donation.fromJson)
        .toList();
  }

  // Method used to fetch all user-pet relationships.
  Future <List<Userpetrelationship>> getUserPetRelationShip() async {
    final Response<dynamic> response = await dio.get('/relationships');
      final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Userpetrelationship.fromJson)
        .toList();
  }

  // Method used to create a new user-pet relationship.
  // The user fills a form with a start date, end date, and preferred pet.
  // The relationship is saved as active=false until an admin approves it.
  // Once approved, active is set to true and a specific pet is assigned.
  // The user can then see the assigned pet and the help period in their profile.
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
  // Method used to fetch relationships belonging to a specific user.
  Future<List<Userpetrelationship>> getMyRelationships(int idUser) async {
    final Response<dynamic> response = await dio.get('/relationships/user/$idUser');
      final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Userpetrelationship.fromJson)
        .toList();
  }
  // Method used to trigger the adoption form email.
  // The backend sends a link to the user's email to fill in the adoption form.
 Future<void> requestAdoptionForm(int idUser, int idPet) async {
  try {
     await dio.post(
      '/adoption-form/send',
      queryParameters: {'userId': idUser, 'petId': idPet}, // ← queryParameters, not data
    );
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}
  // Method used to submit the adoption form received by email.
  // Creates a new record in adoption-requests.
  // When the admin approves it, a new user-pet relationship is automatically created.
  Future <void> submitAdoptionForm(Map<String, dynamic> formData, String token) async {
    try {
      await dio.post('/adoption-form/submit/$token', data: formData);
    } on DioException catch (error) {
      throw Exception(_extractApiErrorMessage(error));
    }
  }
  // Method used to fetch all adoption requests (admin only).
  Future <List<AdoptionRequest>> getAdoptionRequest() async {
    final Response<dynamic> response = await dio.get('/adoption-requests');
    final List<dynamic> items = _extractList(response.data);
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdoptionRequest.fromJson)
        .toList();
  }
  // Method used to fetch the authenticated user's adoption requests.
  Future <List<AdoptionRequest>> getMeAdoptionRequest() async {
    final Response<dynamic> response = await dio.get('/adoption-requests/me');
    final List<dynamic> items = _extractList(response.data);
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdoptionRequest.fromJson)
        .toList();
  }
  // Method used to update the status of a user-pet relationship.
Future<void> updateRelationshipStatus(int relationshipId, Userpetrelationship relationship) async {
  try {
    await dio.put('/relationships/$relationshipId', data: relationship.toJson());
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}

  // Method used to update the status of an adoption request.
  // Only accepts: pending, approved or denied.
Future<void> updateAdoptionStatus(int requestId, String newStatus) async {
  try {
    await dio.patch('/adoption-requests/$requestId/status', queryParameters: {'status': newStatus});
  } on DioException catch (error) {
    throw Exception(_extractApiErrorMessage(error));
  }
}
  // Method used to create a relationship for the authenticated user (no admin privileges required).
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