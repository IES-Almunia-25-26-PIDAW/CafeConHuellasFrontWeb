
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
            'http://localhost:8087/api', // <-- url base de la API, cambiar si es necesario
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
  
Future<void> login(String email, String password) async {
  final response = await dio.post(
    '/auth/login',
    data: {
      'email': email,
      'password': password,
    },
  );

  final token = response.data['token'];
  setToken(token);
}

Future<void> register(Map<String, dynamic> user) async {
  await dio.post(
    '/auth/register',
    data: user,
  );
}

  Future<List<Pet>> getPets() async {
    final Response<dynamic> response = await dio.get('/pets');
    final List<dynamic> items = _extractList(response.data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(Pet.fromJson)
        .toList();
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
}
