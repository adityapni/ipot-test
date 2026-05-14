import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipot/components/quantity_selector.dart';
import 'package:ipot/models/menu_response.dart';
import 'package:ipot/state/cart_manager.dart';
import 'package:watch_it/watch_it.dart';


import '../state/customization_manager.dart';

class CustomizationScreen extends WatchingWidget {
  const CustomizationScreen({super.key,
  required this.image,
  required this.name,
  required this.description,
  this.customizationGroups = const <CustomizationGroup>[]});

  final String image;
  final String name;
  final String description;
  final List<CustomizationGroup> customizationGroups;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    callOnce((_) {
      di.get<CustomizationManager>().initCustomizations(customizationGroups);
    });

    final noteController = createOnce(() => TextEditingController(),
        dispose: (c) => c.dispose());

    final customizationManager = di.get<CustomizationManager>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(image,fit: BoxFit.cover,)
              ),
              SizedBox(height: 20,),
              Text(name,style: Theme.of(context).textTheme.titleLarge),
              Text(description,style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 20,),
              Text('Note for restaurant',style: Theme.of(context).textTheme.titleLarge),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hint: Text('Add a note'),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20,),
              customizationGroups.isNotEmpty?
              Text('Customize your order',style: Theme.of(context).textTheme.titleMedium):
              const SizedBox.shrink(),
              ...(customizationGroups.map((e) => CustomizationSelection(customizationGroup: e))),
              SizedBox(height: 20,),
              QuantitySelector(
                onChanged: (value){
                  customizationManager.changeQuantity(value);
                },
                spacing: 50,
              ),
              SizedBox(height: height * 0.1,),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.surface,
        height: height * 0.1,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary
                ),
                onPressed: (){
                  di.get<CartManager>().addOrderToCart(
                    orderName: name,
                    quantity: customizationManager.quantity,
                    image: image,
                    customizations: customizationManager.customizations.value,
                  );
                  context.push('/cart',);
                },
                child: Text('Add to cart')
            ),
          )
        ),
      ),
    );
  }
}

class CustomizationSelection extends WatchingWidget {
  const CustomizationSelection({super.key,
  required this.customizationGroup});

  final CustomizationGroup customizationGroup;

  @override
  Widget build(BuildContext context) {
    final manager = di.get<CustomizationManager>();
    final customizations = watch(manager.customizations).value;

    final multiSelectOption = customizations[customizationGroup.name]?.multiSelectOption;
    final singleSelectionOptions = customizationGroup.options.map((e) =>
        RadioListTile(
          value: e.name,
          title: Row(
            children: [
              Text(e.name),
              Spacer(),
              Text(e.priceModifier.toString())
            ],
          ),
        )
    ).toList();
    final singleSelection = RadioGroup(
      groupValue: customizations[customizationGroup.name]?.selectedOption,
      onChanged: (selected){
        manager.changeCustomizationSingle(customizationGroup.name, selected??'');
      },
      child: Column(
        children: singleSelectionOptions,
      ),
    );
    final multipleSelection = customizationGroup.options.map((e) =>
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
            value: multiSelectOption?.contains(e.name),
            onChanged: (value){
              manager.changeCustomizationMulti(customizationGroup.name, e.name);
            },
            title: Row(
              children: [
                Text(e.name),
                Spacer(),
                Text(e.priceModifier.toString())
              ],
            )
        )).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(customizationGroup.name,style: Theme.of(context).textTheme.titleMedium),
        ),
        ...(customizationGroup.maxSelections == 1 ? [singleSelection]: multipleSelection),

      ],
    );
  }
}

