import 'customization_type.dart';

class Order {
  Order({
    required this.quantity,
    required this.id,
    required this.name,
    this.orderCustomizations,
    this.note,
    required this.subtotal,
    required this.image
  });
  String name;
  String id;
  String quantity;
  List<OrderCustomization>? orderCustomizations;
  String? note;
  double subtotal;
  String image;
}

class OrderCustomization{
  OrderCustomization({
    required this.name,
    this.selectedOption,
    this.multiSelectOption,
    required this.quantity,
    required this.id,
    required this.customizationType,
  });
  String name;
  String? selectedOption;
  List<String>? multiSelectOption;
  int quantity;
  String id;
  CustomizationType customizationType;
}

