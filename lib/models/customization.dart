import 'customization_type.dart';

class Customization {
  Customization({
    required this.name,
    this.selectedOption,
    this.multiSelectOption = const <String>[],
    required this.customizationType,
    required this.required
  });

  String name;
  String? selectedOption;
  List<String> multiSelectOption;
  CustomizationType customizationType;
  bool required;
}

