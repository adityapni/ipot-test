import 'package:ipot/api/api.dart';
import 'package:ipot/state/cart_manager.dart';
import 'package:ipot/state/customization_manager.dart';
import 'package:ipot/state/menu_manager.dart';
import 'package:watch_it/watch_it.dart';


void configureDependencies(){
  di.registerLazySingleton<ApiService>(()=>ApiService());
  di.registerSingleton(MenuManager());
  di.registerSingleton(CustomizationManager());
  di.registerSingleton(CartManager());
}