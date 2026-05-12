import 'package:go_router/go_router.dart';

import '../main.dart';
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

]);