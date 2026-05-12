import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'navigation/routes.dart';
import 'utils/logger.dart';
import 'state/services.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  configureDependencies();

  runApp(const MyApp());
}

String getRouteForQr(String qrValue) {
  if (qrValue.startsWith('ipot://table/')) {
    return Uri(path:'menu_display',queryParameters: {'table_id':qrValue.split('/').last}).toString();
  }
  return 'wrong_qr';
}

void readQr(String qrValue,BuildContext context){
  final route = getRouteForQr(qrValue);
  context.go(route);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IPOT Test',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: MobileScanner(
                onDetect: (result) {
                  String? qrValue = result.barcodes.first.rawValue;
                  logger.i('qr value: $qrValue');
                  readQr(qrValue??'',context);
                },
              ),
            ),
            Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Text('Please scan your table',
                  style: Theme.of(context).textTheme.headlineSmall,)
            ),
          ],
        ),
      ),

    );
  }
}
