class OrderSubmission {
  String? tableId;
  List<OrderItem>? items;
  String? customerNote;

  OrderSubmission({
    this.tableId,
    this.items,
    this.customerNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'table_id': tableId,
      'items': items?.map((item) => item.toJson()).toList(),
      'customer_note': customerNote,
    };
  }
}

class OrderItem {
  int? menuItemId;
  int? quantity;
  List<ItemCustomization>? customizations;

  OrderItem({
    this.menuItemId,
    this.quantity,
    this.customizations,
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'customizations': customizations?.map((c) => c.toJson()).toList(),
    };
  }
}

class ItemCustomization {
  String? optionId;
  int? quantity;

  ItemCustomization({
    this.optionId,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'quantity': quantity,
    };
  }
}