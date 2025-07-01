import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  //static const String _baseUrl = 'http://10.0.2.2:3000';
  static const String _baseUrl = 'http://localhost:3000';

  // Helper to handle responses
  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 204:
        return null;
      case 400:
      case 404:
        throw Exception(json.decode(response.body)['message']);
      case 500:
      default:
        throw Exception('Error connecting to the server.');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    final data = _processResponse(response) as List;
    return data.map((item) => Product.fromJson(item)).toList();
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    return Product.fromJson(_processResponse(response));
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    return Product.fromJson(_processResponse(response));
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/products/$id'));
    _processResponse(response);
  }
}
