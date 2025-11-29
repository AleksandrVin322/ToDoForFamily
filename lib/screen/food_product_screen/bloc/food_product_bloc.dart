import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/service/firestore_service.dart';
import '../../../entity/product.dart';

part 'food_product_event.dart';
part 'food_product_state.dart';

class FoodProductBloc extends Bloc<FoodProductEvent, FoodProductState> {
  final FirestoreService _firestoreService;
  StreamSubscription<List<Product>>? _productsSubscription;

  FoodProductBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(FoodProductInitial()) {
    on<LoadProductsEvent>(_onLoadItems);
    on<ProductLoadedEvent>(_productsUpdated);
    on<AddProductEvent>(_addProduct);
    on<SwitchIsBuyProductEvent>(_switchIsBuyFromProduct);
  }

  void _onLoadItems(
      LoadProductsEvent event, Emitter<FoodProductState> emit) async {
    _productsSubscription?.cancel();
    _productsSubscription = _firestoreService
        .getProducts(familiesId: 'rx3ejgCpPf6uFOVYNu8h')
        .listen(
      (products) {
        add(ProductLoadedEvent(products));
      },
    );
  }

  void _productsUpdated(
    ProductLoadedEvent event,
    Emitter<FoodProductState> emit,
  ) {
    event.products.sort((a, b) {
      if (b.isBuy && !a.isBuy) return -1;
      if (!b.isBuy && a.isBuy) return 1;
      return 0;
    });
    emit(ProductLoadedState(products: event.products));
  }

  void _addProduct(
    AddProductEvent event,
    Emitter<FoodProductState> emit,
  ) async {
    await _firestoreService.addProduct(
      familiesId: 'rx3ejgCpPf6uFOVYNu8h',
      isBuy: false,
      name: event.name,
    );
  }

  void _switchIsBuyFromProduct(
    SwitchIsBuyProductEvent event,
    Emitter<FoodProductState> emit,
  ) async {
    if (event.isBuy == true) {
      await _firestoreService.switchIsBuyFromProduct(
        familiesId: 'rx3ejgCpPf6uFOVYNu8h',
        idDoc: event.idDoc,
        isBuy: false,
      );
    } else {
      await _firestoreService.switchIsBuyFromProduct(
        familiesId: 'rx3ejgCpPf6uFOVYNu8h',
        idDoc: event.idDoc,
        isBuy: true,
      );
    }
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
