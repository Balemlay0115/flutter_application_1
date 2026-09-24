import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/market_store.dart';
import '../models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitialState()) {
    on<GetProductsEvent>((event, emit) {
      emit(ProductLoading());

      final products = MarketStore.products;

      emit(ProductListState(products: products));
    });

    on<GetProductEvent>((event, emit) {
      final product = MarketStore.findProduct(event.productId);

      emit(ProductLoadedState(product: product));
    });

    on<CreateProductEvent>((event, emit) {
      MarketStore.addProduct(event.product);

      final products = MarketStore.products;

      emit(ProductListState(products: products));
    });

    on<UpdateProductEvent>((event, emit) {
      MarketStore.updateProduct(event.product);

      final products = MarketStore.products;

      emit(ProductListState(products: products));
    });

    on<DeleteProductEvent>((event, emit) {
      MarketStore.deleteProduct(event.productId);

      final products = MarketStore.products;
      emit(ProductListState(products: products));
    });
  }
}
