part of 'food_product_bloc.dart';

@immutable
abstract class FoodProductState {}

class FoodProductInitial extends FoodProductState {}

class ProductLoadedState extends FoodProductState {
  final List<Product> products;
  ProductLoadedState({this.products = const []});
}
