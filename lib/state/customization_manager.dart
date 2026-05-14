import 'package:flutter/cupertino.dart';
import 'package:listen_it/collections.dart';

import '../models/customization.dart';
import '../models/customization_type.dart';
import '../models/menu_response.dart';
import '../utils/logger.dart';


class CustomizationManager {
  final customizations = MapNotifier<String,Customization>();
  List<CustomizationGroup> customizationGroups = <CustomizationGroup>[];
  int quantity = 1;

  void initCustomizations(List<CustomizationGroup> cgs){
      customizations.clear();
      customizationGroups = cgs;
      customizations.addAll({for (var group in cgs)
        group.name: Customization(
            name: group.name,
            selectedOption: null,
            multiSelectOption: <String>[],
            customizationType: group.maxSelections == 1 ? CustomizationType.radio : CustomizationType.checkbox,
            required: group.required
        )});
  }


  void changeCustomizationSingle(String name, String selectedOption){
    final item = customizations[name];
    if (item != null) {
      item.selectedOption = selectedOption;
      // Re-assign to the map to trigger the notifier
      customizations[name] = item;
      logger.d('name: $name, selectedOption: ${item.selectedOption}');
    }
  }

  void changeCustomizationMulti(String name, String selectedOption){
    final item = customizations[name];
    if (item != null) {
      if (item.multiSelectOption.contains(selectedOption)) {
        item.multiSelectOption.remove(selectedOption);
      } else {
        item.multiSelectOption.add(selectedOption);
      }
      // Re-assign to the map to trigger the notifier
      customizations[name] = item;
      logger.d('name: $name, multiSelectOption: ${item.multiSelectOption}');
    }
  }

  void changeQuantity(int newQuantity){
    quantity = newQuantity;
  }
}