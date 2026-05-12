import 'package:ipot/api/api.dart';
import 'package:ipot/state/menu_manager.dart';
import 'package:watch_it/watch_it.dart';


void configureDependencies(){
  di.registerLazySingleton<ApiService>(()=>ApiService());
  di.registerSingleton(MenuManager());
}