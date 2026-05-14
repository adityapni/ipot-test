import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key,
    required this.orderId
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text('Order Confirmed!',style: Theme.of(context).textTheme.headlineMedium,),
            Text('Order Id: $orderId')
          ],
        ),
      ),
    );
  }
}
