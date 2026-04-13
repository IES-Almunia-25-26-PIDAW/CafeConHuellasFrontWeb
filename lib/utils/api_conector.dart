
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
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
  dynamic user;

  if (data is Map<String, dynamic>) {
    token = (data['token'] ?? data['accessToken'] ?? data['jwt'] ?? '').toString();

    if (token.isEmpty && data['data'] is Map<String, dynamic>) {
      final nested = data['data'] as Map<String, dynamic>;
      token = (nested['token'] ?? nested['accessToken'] ?? nested['jwt'] ?? '').toString();
      user = nested['user'];
    }

    user ??= data['user'] ?? data['usuario'];
  } else if (data is String) {
    token = data;
  }

  if (token.isEmpty) {
    throw Exception('No se recibio token en la respuesta de login.');
  }

  setToken(token);
  return {'token': token, 'user': user};
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

  Future<List<Event>> getEvents() async {
    final Response<dynamic> response = await dio.get('/events');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Event.fromJson)
        .toList();
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
}
