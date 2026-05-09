

class MenuResponse {
  final Restaurant? restaurant;
  final List<Category> categories;
  final List<MenuItem> items;

  MenuResponse({
    this.restaurant,
    required this.categories,
    required this.items,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      categories: (json['categories'] as List)
          .map((i) => Category.fromJson(i))
          .toList(),
      items: (json['items'] as List)
          .map((i) => MenuItem.fromJson(i))
          .toList(),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String tableId;

  Restaurant({
    required this.id,
    required this.name,
    required this.tableId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      tableId: json['table_id'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      sortOrder: json['sort_order'],
    );
  }
}

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String? imageUrl;
  final List<CustomizationGroup> customizationGroups;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    required this.customizationGroups,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      // Handles both int and double from JSON safely
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      customizationGroups: (json['customization_groups'] as List)
          .map((i) => CustomizationGroup.fromJson(i))
          .toList(),
    );
  }
}

class CustomizationGroup {
  final int id;
  final String name;
  final bool required;
  final int maxSelections;
  final List<Option> options;

  CustomizationGroup({
    required this.id,
    required this.name,
    required this.required,
    required this.maxSelections,
    required this.options,
  });

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) {
    return CustomizationGroup(
      id: json['id'],
      name: json['name'],
      required: json['required'] ?? false,
      maxSelections: json['max_selections'] ?? 0,
      options: (json['options'] as List)
          .map((i) => Option.fromJson(i))
          .toList(),
    );
  }
}

class Option {
  final int id;
  final String name;
  final double priceModifier;

  Option({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      name: json['name'],
      priceModifier: (json['price_modifier'] as num).toDouble(),
    );
  }
}