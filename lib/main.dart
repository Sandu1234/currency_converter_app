import 'package:currency_converter_app/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String _baseCurrency = 'USD';
  String _targetCurrency = 'EUR';
  String _convertedAmount = '';
  Map<String, double> _conversionRates = {};

  @override
  void initState() {
    super.initState();
    _fetchConversionRates();
  }

  Future<void> _fetchConversionRates() async {
    const String apiKey =
        '05234b0f817cb25d408bc28daeb90a62'; // Replace with your actual API key
    const String apiUrl =
        'http://api.exchangeratesapi.io/v1/latest?access_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('rates')) {
          setState(() {
            _conversionRates = (data['rates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value is int) ? value.toDouble() : value,
              ),
            );
          });
          print("Fetched Rates: ${_conversionRates.keys}");
        } else {
          setState(() {
            _convertedAmount = 'Failed to parse rates';
          });
        }
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      setState(() {
        _convertedAmount = 'Failed to fetch rates';
      });
      print('Error fetching rates: $e');
    }
  }

  void _convertCurrency() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount != null && _conversionRates.isNotEmpty) {
      double baseRate = _conversionRates[_baseCurrency]!;
      double targetRate = _conversionRates[_targetCurrency]!;
      double converted = amount * (targetRate / baseRate);

      setState(() {
        _convertedAmount = converted.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _convertedAmount = 'Invalid input or rates not available';
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Lottie.network(
                'https://lottie.host/5f35196c-8cfa-4ddd-a4c6-fbbeff12806c/9joEt0TqPK.json',
                height: 150,
                width: 150,
                repeat: true,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            const Text(
              'Easily convert currencies in real time with the latest rates.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Card(
              color: const Color(0xFFFAFDFF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _convertedAmount.isEmpty
                          ? 'Enter amount and select currencies'
                          : 'Converted Amount: $_convertedAmount $_targetCurrency',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _baseCurrency,
                            decoration: InputDecoration(
                              labelText: 'From',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _conversionRates.keys.isNotEmpty
                                ? _conversionRates.keys
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (String? newValue) {
                              setState(() {
                                _baseCurrency = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _targetCurrency,
                            decoration: InputDecoration(
                              labelText: 'To',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _conversionRates.keys.isNotEmpty
                                ? _conversionRates.keys
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (String? newValue) {
                              setState(() {
                                _targetCurrency = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _convertCurrency,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Convert',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            const Text(
              'Powered by ExchangeRatesAPI',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
