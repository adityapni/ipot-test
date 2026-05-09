import 'package:flutter/material.dart';

class WrongQRScreen extends StatelessWidget {
  const WrongQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('This is not our table',
          style: Theme.of(context).textTheme.headlineMedium,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Scan again'))
        ],
      ),
    );
  }
}
