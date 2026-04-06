import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<List<dynamic>> fetchProducts({int page = 1, int limit = 20}) async {
    final uri = Uri.parse('$baseUrl/api/products?page=$page&limit=$limit');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return body['products'] as List<dynamic>;
    }
    throw Exception('Failed to fetch products');
  }
}
