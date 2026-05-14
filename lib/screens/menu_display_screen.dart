import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipot/components/menu_item_card.dart';

import 'package:watch_it/watch_it.dart';

import '../models/menu_response.dart';
import '../state/menu_manager.dart';

class MenuDisplayScreen extends WatchingWidget {
  const MenuDisplayScreen({super.key,
  required this.tableId});

  final String tableId;


  @override
  Widget build(BuildContext context) {

    final isLoading = watchValue((MenuManager menuManager) => menuManager.isLoading);
    final menuItems = watchValue((MenuManager menuManager) => menuManager.menuItems);
    final error = watchValue((MenuManager menuManager) => menuManager.error);
    final categories = watchValue((MenuManager menuManager) => menuManager.categories);
    final filters = watchValue((MenuManager menuManager) => menuManager.filters);

    callOnce((_){
      di.get<MenuManager>().getMenu(tableId);
    });
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (error != null) {
      return Scaffold(
        body: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(error,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: (){
                  di.get<MenuManager>().error.value = null;
                  di.get<MenuManager>().getMenu(tableId);
                },
                child: Text('Try Again'),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                MenuSearch(menu: menuItems),
                Filters(categories: categories, filters: filters),
                MenuList(menu: menuItems),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuSearch extends StatelessWidget {
  const MenuSearch({
    super.key,
    required this.menu,
  });

  final List<MenuItem> menu;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (context,controller){
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: (){
              controller.openView();
            },
            onChanged: (_){
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (context,controller){
          final suggestions = menu.where((e)=>e.name.toLowerCase().contains(controller.text.toLowerCase()));
          return suggestions.map((e) => InkWell(
            onTap: (){
              controller.closeView(e.name);
              context.push(Uri(path:'/menu_display/customization',queryParameters: {'name':e.name}).toString(),
                extra: {
                  'image': e.imageUrl,
                  'description': e.description,
                  'customization_groups': e.customizationGroups
                },);
            },
            child: ListTile(
              title: Text(e.name),
            ),
          ));
        }
    );
  }
}

class MenuList extends StatelessWidget {
  const MenuList({super.key,
    required this.menu
  });

  final List<MenuItem> menu;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = menu[index];
        return MenuItemCard(
          image: item.imageUrl,
          name: item.name,
          description: item.description,
          price: item.price.toString(),
          customizationGroups: item.customizationGroups,
        );
      },
      itemCount: menu.length,
    );
  }
}

class Filters extends StatelessWidget {
  const Filters({super.key,
  required this.categories,
  required this.filters});

  final List<Category> categories;
  final Set<Category> filters;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: categories.map((e) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilterChip(
            label: Text(e.name),
            selected: filters.contains(e),
            onSelected: (value) {
              if(value){
                di.get<MenuManager>().addFilter(e);
              } else {
                di.get<MenuManager>().removeFilter(e);
              }
            }),
      ))
          .toList(),
    );
  }
}

