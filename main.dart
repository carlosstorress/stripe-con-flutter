import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dashboard_page.dart';

void main() {
  Stripe.publishableKey = //LLAMAR A LA CLAVE PUBLICA PARA ENVIAR INFORMACION DEL PAGO
      'pk_test_51MgqzbFsLXR5H817ERftCB8k0o5EQwZ2O1kZIVGMowZ8IHwynOLZBu36kl6uD0DBglSypRzQYecgSqWfvs0TuTRh000YGNf2Id';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}
