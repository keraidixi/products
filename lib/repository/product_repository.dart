import '../models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      ProductModel(
        id: '1',
        name: 'iPhone 15 Pro Max',
        price: 1099.99,
        imageUrl:
            'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=500&auto=format&fit=crop&q=80',
        description:
            'Experience titanium design, ground-breaking A17 Pro chip, and the most powerful iPhone camera system ever.',
      ),
      ProductModel(
        id: '2',
        name: 'MacBook Pro 16" M3 Max',
        price: 2499.00,
        imageUrl:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&auto=format&fit=crop&q=80',
        description:
            'The most advanced chips ever built for a personal computer. Phenomenal battery life and a stunning Liquid Retina XDR display.',
      ),
      ProductModel(
        id: '3',
        name: 'Sony WH-1000XM5',
        price: 398.00,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
        description:
            'Industry-leading noise cancellation, exceptional sound quality, and crystal-clear hands-free calling.',
      ),
      ProductModel(
        id: '4',
        name: 'iPad Pro 12.9" M2',
        price: 1099.00,
        imageUrl:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&auto=format&fit=crop&q=80',
        description:
            'Astonishing performance, incredibly advanced displays, superfast wireless connectivity, and next-level Apple Pencil capabilities.',
      ),
      ProductModel(
        id: '5',
        name: 'Logitech MX Master 3S',
        price: 99.99,
        imageUrl:
            'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=500&auto=format&fit=crop&q=80',
        description:
            'An icon remastered. Feel every moment of your workflow with even more precision, tactility, and performance.',
      ),
      ProductModel(
        id: '6',
        name: 'Keychron Q1 Pro Keyboard',
        price: 199.00,
        imageUrl:
            'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500&auto=format&fit=crop&q=80',
        description:
            'A full metal QMK/VIA custom mechanical keyboard. Beautifully designed CNC aluminum body with premium tactile switches.',
      ),
    ];
  }
}
