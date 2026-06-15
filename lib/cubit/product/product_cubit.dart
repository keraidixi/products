import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductInProgress());

    try {
      final products = await repository.fetchProducts();
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductFailure('Failed to load products: $e'));
    }
  }
}