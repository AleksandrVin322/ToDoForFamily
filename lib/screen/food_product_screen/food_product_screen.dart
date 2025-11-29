import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/service/firestore_service.dart';
import 'bloc/food_product_bloc.dart';

class FoodProductScreen extends StatelessWidget {
  const FoodProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodProductBloc(
        firestoreService: context.read<FirestoreService>(),
      )..add(LoadProductsEvent()),
      child: BlocBuilder<FoodProductBloc, FoodProductState>(
        builder: (context, state) {
          if (state is ProductLoadedState) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => _addProduct(context, state),
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: const Text(
                  'Продукты',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    endActionPane: const ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: null,
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          onPressed: null,
                          backgroundColor: Colors.yellow,
                          icon: Icons.create,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => context.read<FoodProductBloc>().add(
                            SwitchIsBuyProductEvent(
                              isBuy: state.products[index].isBuy,
                              idDoc: state.products[index].id,
                            ),
                          ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            state.products[index].name,
                            style: TextStyle(
                              decoration: (state.products[index].isBuy)
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else
            return const CircularProgressIndicator();
        },
      ),
    );
  }
}

void _addProduct(BuildContext context, ProductLoadedState state) async {
  const inputDecoration = InputDecoration(border: OutlineInputBorder());
  final FoodProductBloc tasksBloc = context.read<FoodProductBloc>();
  final name = TextEditingController();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Добавить продукт')),
      content: SizedBox(
        width: 1000,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text('Введите название продукта'),
              TextField(
                controller: name,
                decoration: inputDecoration,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                tasksBloc.add((AddProductEvent(name: name.text)));
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.save,
                size: 50,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.cancel,
                size: 50,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
