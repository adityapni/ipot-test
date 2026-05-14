import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/menu_response.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key,
  this.image,
  this.name,
  this.description,
  this.price,
  this.customizationGroups});

  final String? image;
  final String? name;
  final String? description;
  final String? price;
  final List<CustomizationGroup>? customizationGroups;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(Uri(path:'/menu_display/customization',queryParameters: {'name':name}).toString(),
          extra: {
            'image': image,
            'description': description,
            'customization_groups': customizationGroups
          },);
      },
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(image??'https://via.placeholder.com/150',fit: BoxFit.cover,)
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$name', style: Theme.of(context).textTheme.titleMedium),
                  Text('$description', style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,),
                  Text('$price', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
