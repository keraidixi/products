import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => ProductModel.fromApiJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load products: status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
