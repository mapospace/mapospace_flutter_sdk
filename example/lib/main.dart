import 'package:flutter/material.dart';
import 'package:mapospace_flutter_sdk/mapospace_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Mapospace mapospaceFlutterSdk = Mapospace();
  @override
  void initState() {
    mapospaceFlutterSdk.initialize(apiKeyPath: 'assets/api_key.txt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              mapospaceFlutterSdk.captureSaleEvent(
                event: SaleEvent(
                  orderId: "1",
                  products: [
                    Product(
                      productId: 'Cashew_001',
                      productName: 'Premium Cashew',
                      categoryId: 'Dry_fruits_001',
                      category: 'Dry fruits',
                      subcategory: '',
                      subcategoryId: '',
                      itemValue: '200',
                      itemCount: '5',
                    )
                  ],
                  orderValue: "1000",
                  paymentStatus: "successful",
                  paymentType: 'UPI',
                  timestamp: DateTime.now().toIso8601String(),
                ),
              );
            },
            child: Text('hello')),
      ),
    );
  }
}
