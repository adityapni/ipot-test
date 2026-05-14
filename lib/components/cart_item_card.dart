import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipot/components/quantity_selector.dart';
import 'package:ipot/models/order.dart';
import 'package:ipot/state/customization_manager.dart';
import 'package:watch_it/watch_it.dart';

import '../models/customization_type.dart';
import '../state/cart_manager.dart';
import '../state/menu_manager.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key,
    required this.subtotal,
    this.customizations,
    required this.image,
    required this.name
  });
  final String subtotal;
  final List<OrderCustomization>? customizations;
  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    List<Widget> customizationsWidgets = [];
    if(customizations != null){
      for (final customization in customizations!) {
        if (customization.customizationType == CustomizationType.radio) {
          customizationsWidgets.add(Text(customization.selectedOption??''));
        } else {
          for (final option in customization.multiSelectOption!){
            customizationsWidgets.add(Text(option));
          }
        }
      }
    }
    final List<Widget>middleRow = [
      Text(name,style: Theme.of(context).textTheme.titleMedium)
    ];
    middleRow.addAll(customizationsWidgets);
    return InkWell(
      onTap: (){
        var cgs = di.get<MenuManager>().menuItems.value.firstWhere((element) => element.name == name).customizationGroups;
        di.get<CustomizationManager>().initCustomizations(cgs);
        di.get<CartManager>().orders.removeWhere((e)=>e.name == name);
        context.go(Uri(path: '/menu_display/customization',
            queryParameters: {'name':name}).toString(),extra: {
        'image': image,
        'description': di.get<MenuManager>().menuItems.value.firstWhere((element) => element.name == name).description,
        'customization_groups': cgs
        });
      },
      child: Card(
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: middleRow,
            ),
            Spacer(),
            Column(
              children: [
                Text(subtotal, style: Theme.of(context).textTheme.titleLarge),
                QuantitySelector(
                  onChanged: (value){
                    di.get<CartManager>().changeQuantity(newQuantity: value, name: name);
                  },
                  filled: false,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
