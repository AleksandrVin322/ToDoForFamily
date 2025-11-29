part of 'food_product_bloc.dart';

@immutable
abstract class FoodProductEvent {}

class LoadProductsEvent extends FoodProductEvent {}

class ProductLoadedEvent extends FoodProductEvent {
  final List<Product> products;

  ProductLoadedEvent(this.products);
}

class AddProductEvent extends FoodProductEvent {
  final String name;
  AddProductEvent({required this.name});
}

class SwitchIsBuyProductEvent extends FoodProductEvent {
  final bool isBuy;
  final String idDoc;
  SwitchIsBuyProductEvent({required this.isBuy, required this.idDoc});
}
