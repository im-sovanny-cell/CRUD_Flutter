import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum AppState { idle, loading, error }

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  AppState _state = AppState.idle;
  String _errorMessage = '';

  List<Product> get products => _products;
  AppState get state => _state;
  String get errorMessage => _errorMessage;

  ProductProvider() {
    fetchProducts();
  }

  void _setState(AppState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setState(AppState.loading);
    try {
      _products = await _apiService.getProducts();
      _setState(AppState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AppState.error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await _apiService.createProduct(product);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final updatedProduct =
          await _apiService.updateProduct(product.productId!, product);
      final index =
          _products.indexWhere((p) => p.productId == updatedProduct.productId);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((p) => p.productId == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    }
  }
}
