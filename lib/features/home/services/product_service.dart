import '../models/product_model.dart';
import '../models/dummy_products.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    return dummyProducts;
  }
}