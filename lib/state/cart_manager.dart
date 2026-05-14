
import 'package:flutter/cupertino.dart';
import 'package:ipot/models/order_submission.dart';
import 'package:ipot/state/table_manager.dart';
import 'package:listen_it/collections.dart';
import 'package:watch_it/watch_it.dart';

import '../api/api.dart';
import '../models/customization.dart';
import '../models/customization_type.dart';
import '../models/menu_response.dart';
import '../models/order.dart';
import '../utils/logger.dart';
import 'menu_manager.dart';

class CartManager {
  final orders = ListNotifier<Order>();
  final isLoading = ValueNotifier<bool>(false);
  final orderId = ValueNotifier<String?>(null);
  final error = ValueNotifier<String?>(null);

  void addOrderToCart({required String orderName, required int quantity, String? note,
  Map<String,Customization>? customizations, int? customizationQuantity,
  required String image}){
    final menu = getMenuFromManager(orderName);
    final selectedCustomizations = getCustomizationFromManager(menu: menu,
        customizations: customizations);
    double subtotal = menu.price * quantity;
    double customizationTotal = 0;
    List<OrderCustomization> orderCustomizations =[];
    if(selectedCustomizations != null){
      for(final customization in selectedCustomizations){
        customizationTotal += customization.priceModifier;
        logger.d('name: ${customization.name}, priceModifier: ${customization.priceModifier}');
      }

      for (final entry in customizations!.entries) {
        if(entry.value.selectedOption == null && entry.value.multiSelectOption.isEmpty){
          continue;
        }
        OrderCustomization newOrderCustomization = OrderCustomization(
            name: entry.key,
            selectedOption: entry.value.selectedOption,
            multiSelectOption: entry.value.multiSelectOption,
            quantity: customizationQuantity ?? 0,
            id: selectedCustomizations
                .where((e) {
                  logger.d('name: ${e.name}, selectedOption: ${entry.value.selectedOption}, multiSelectOption: ${entry.value.multiSelectOption}');
                  if(entry.value.customizationType == CustomizationType.checkbox){
                    return entry.value.multiSelectOption.contains(e.name);
                  }
                  return e.name == entry.value.selectedOption;
                })
                .first
                .id
                .toString(),
            customizationType: entry.value.customizationType.index == 0
                ? CustomizationType.radio
                : CustomizationType.checkbox
        );
        orderCustomizations.add(newOrderCustomization);
      }
    } else {
      orderCustomizations = <OrderCustomization>[];
    }
    subtotal = subtotal + customizationTotal;

    final order = Order(
      name: orderName,
      id: menu.id.toString(),
      quantity: quantity.toString(),
      note: note,
      orderCustomizations: orderCustomizations,
      subtotal: subtotal,
      image: image
    );
    orders.add(order);
  }

  MenuItem getMenuFromManager(String orderName){
    final menu = di.get<MenuManager>().menuItems.value.firstWhere((element) => element.name == orderName);
    return menu;
  }

  List<Option>? getCustomizationFromManager({required MenuItem menu, Map<String,Customization>? customizations}){
    if(customizations != null ){
      for (final customization in customizations.values) {
        logger.d('name: ${customization.name}, selectedOption: ${customization.selectedOption}');
      }
      final customizationMenu = menu.customizationGroups.where((e)=>customizations.containsKey(e.name));
      for (final group in customizationMenu) {
       logger.d('name: ${group.name}, options: ${group.options}');
      };
      List<Option> selectedCustomizations = [];
      for (final group in customizationMenu) {
        if (customizations[group.name]!.customizationType == CustomizationType.radio) {
          selectedCustomizations.add(
              group.options.firstWhere((option)=>option.name == customizations[group.name]!.selectedOption));
        } else {
          selectedCustomizations.addAll(
              group.options.where((option)=>customizations[group.name]!.multiSelectOption.contains(option.name)));
        }
      }
      return selectedCustomizations;
    }
    return null;
  }

  void changeQuantity({required String name, required int newQuantity}){
    final index = orders.value.indexWhere((element) => element.name == name);
    final subtotal = newQuantity * orders[index].subtotal / double.parse(orders[index].quantity);
    orders[index] = Order(
      name: orders[index].name,
      id: orders[index].id,
      quantity: newQuantity.toString(),
      note: orders[index].note,
      orderCustomizations: orders[index].orderCustomizations,
      subtotal: subtotal,
      image: orders[index].image
    );

  }

  void submitOrder() async {
    error.value = null;
    String tableId = di.get<TableManager>().tableId;
    OrderSubmission orderSubmission = OrderSubmission(
      tableId: tableId,
      items: orders.value.map((e) => OrderItem(
        menuItemId: int.parse(e.id),
        quantity: int.parse(e.quantity),
        customizations: e.orderCustomizations?.map((customization) => ItemCustomization(
          optionId: customization.id,
          quantity: customization.quantity
        )).toList()
      )).toList(),
    );
    isLoading.value = true;
    final result =  await di.get<ApiService>().submitOrder(orderSubmission);
    isLoading.value = false;
    result.fold((success){
      orderId.value = success.orderId;
    }, (failure){
      error.value = failure.toString();
    });
  }


}