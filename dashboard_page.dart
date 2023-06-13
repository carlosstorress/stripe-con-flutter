// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "img/colegiatura.jpg",
            ),
            const Text(
              'Colegiatura',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '\$4167.60',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showPaymentInfoDialog(context);
              },
              child: const Text('Pagar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(
      String shippingName,
      String shippingAddressLine1,
      String shippingAddressLine2,
      String shippingCity,
      String shippingState,
      String shippingPostalCode,
      String shippingCountry) async {
    final url = Uri.parse(
        'https://us-central1-pagosconstri.cloudfunctions.net/stripePayment');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    paymentIntentData = json.decode(response.body);

    paymentIntentData!['shipping'] = {
      'name': shippingName,
      'address': {
        'line1': shippingAddressLine1,
        'line2': shippingAddressLine2,
        'city': shippingCity,
        'state': shippingState,
        'postal_code': shippingPostalCode,
        'country': shippingCountry,
      }
    };

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
      applePay: true,
      googlePay: true,
      style: ThemeMode.dark,
      customerId: 'customerId',
      merchantCountryCode: 'MXN',
      merchantDisplayName: 'Carlos Jesus',
      testEnv: true,
    ));

    setState(() {});

    displayPaymentSheet();
  }

  Future<void> _showPaymentInfoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String shippingName = "";
        String shippingAddressLine1 = "";
        String shippingAddressLine2 = "";
        String shippingCity = "";
        String shippingState = "";
        String shippingPostalCode = "";
        String shippingCountry = "";

        return AlertDialog(
          title: const Text('Ingrese la información de pago'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre del titular'),
                  onChanged: (value) {
                    shippingName = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Dirección línea 1'),
                  onChanged: (value) {
                    shippingAddressLine1 = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Dirección línea 2'),
                  onChanged: (value) {
                    shippingAddressLine2 = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ciudad'),
                  onChanged: (value) {
                    shippingCity = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Estado/Provincia'),
                  onChanged: (value) {
                    shippingState = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Código postal'),
                  onChanged: (value) {
                    shippingPostalCode = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'País'),
                  onChanged: (value) {
                    shippingCountry = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await makePayment(
                  shippingName,
                  shippingAddressLine1,
                  shippingAddressLine2,
                  shippingCity,
                  shippingState,
                  shippingPostalCode,
                  shippingCountry,
                );
              },
              child: const Text('Crear pago'),
            ),
          ],
        );
      },
    );
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          // ignore: deprecated_member_use
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['paymentIntent'],
              confirmPayment: true));

      setState(() {
        paymentIntentData = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago realizado con exito')));

      // await FirebaseFirestore.instance
      //     .collection('pagos')
      //     .add({'monto': 416760, 'fecha': DateTime.now()});
    } catch (e) {
      print(e);
    }
  }
}
