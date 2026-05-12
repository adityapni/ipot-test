import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WrongQRScreen extends StatelessWidget {
  const WrongQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('This is not our table',
            style: Theme.of(context).textTheme.headlineMedium,),
            ElevatedButton(onPressed: (){
              context.go('/');
            }, child: Text('Scan again'))
          ],
        ),
      ),
    );
  }
}
