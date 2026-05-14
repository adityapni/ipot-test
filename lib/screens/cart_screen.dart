import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipot/components/cart_item_card.dart';
import 'package:ipot/state/cart_manager.dart';
import 'package:ipot/state/customization_manager.dart';
import 'package:watch_it/watch_it.dart';

class CartScreen extends WatchingWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = watchValue((CartManager cartManager)=> cartManager.orders);
    final orderCards = orders.map((e) => CartItemCard(
      subtotal: e.subtotal.toStringAsFixed(2), image: e.image, name: e.name,
      customizations: e.orderCustomizations,
    )
    ).toList();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order Summary',style: Theme.of(context).textTheme.titleLarge),
                  TextButton(onPressed: (){
                    di.get<CustomizationManager>().customizations.clear();
                    context.go('/menu_display');
                  }, child: Text('Add Order'))
                ],
              ),
              SizedBox(height: 20,),
              ...orderCards,
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount',style: Theme.of(context).textTheme.titleLarge),
                  Text(orders.map((e) => e.subtotal).reduce((value, element) => value + element).toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary
                ),
                onPressed: (){

                },
                child: Text('Place Order'))
            ],
          ),
        ),
      )
    );
  }
}
