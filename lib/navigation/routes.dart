import 'package:go_router/go_router.dart';

import '../main.dart';
import '../models/menu_response.dart';
import '../screens/cart_screen.dart';
import '../screens/customization_screen.dart';
import '../screens/menu_display_screen.dart';
import '../screens/wrong_qr_screen.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(path: '/',
    builder: (context, state) => const MyHomePage(title: 'Aditya Pendar IPOT Test'),
  ),
  GoRoute(path: '/wrong_qr',
    builder: (context, state) => const WrongQRScreen(),
  ),
  GoRoute(path: '/menu_display',
    builder: (context, state) {
      final tableId = state.uri.queryParameters['table_id'];
      return  MenuDisplayScreen(tableId: tableId??'',);
    },
  ),
  GoRoute(path: '/menu_display/customization',
    builder: (context,state){
      final name = state.uri.queryParameters['name'];
      final extra = state.extra as Map<String, dynamic>;
      final image = extra['image'];
      final description = extra['description'];
      final customizationGroups = extra['customization_groups'] as List<CustomizationGroup>;
      return CustomizationScreen(
          customizationGroups: customizationGroups,
          image: image.toString(),
          name: name.toString(),
          description: description.toString(),
      );
    }
  ),
  GoRoute(path: '/cart',
    builder: (context, state) => const CartScreen(),
  )

]);