import 'package:flutter/cupertino.dart';
import 'package:ipot/models/menu_response.dart';
import 'package:ipot/utils/logger.dart';
import 'package:watch_it/watch_it.dart';

import '../api/api.dart';

class MenuManager {
  final menuItems = ValueNotifier<List<MenuItem>>(<MenuItem>[]);
  final isLoading = ValueNotifier<bool>(false);
  final error = ValueNotifier<String?>(null);
  final categories = ValueNotifier<List<Category>>(<Category>[]);
  late final List<MenuItem> unfiltered;
  final filters = ValueNotifier<Set<Category>>({});

  void getMenu(String tableId) async {
    isLoading.value = true;
    final result = await di.get<ApiService>().getMenu(tableId);
    isLoading.value = false;
    result.fold((success){
      menuItems.value = success.items;
      categories.value = success.categories;
      unfiltered = success.items;
    }, (failure){
      error.value = failure.toString();
    });
  }

  void addFilter(Category selected){
    logger.d('adding filter: ${selected.name}');
    filters.value.add(selected);
    logger.d('filters: ${filters.value.map((e) => e.name)}');
    menuItems.value = unfiltered.where((filter) =>
        filters.value.any((category)=>category.id == filter.categoryId)).toList();
  }

  void removeFilter(Category selected){
    filters.value.remove(selected);
    logger.d('removing filter: ${selected.name}');
    logger.d('filters: ${filters.value.map((e) => e.name)}');
    if (filters.value.isEmpty) {
      menuItems.value = unfiltered;
    } else {
      menuItems.value = unfiltered.where((filter) =>
          filters.value.any((category)=>category.id == filter.categoryId)).toList();
    }
  }
}