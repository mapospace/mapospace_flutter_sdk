// sale_event.dart
import 'dart:convert';

import 'package:mapospace_flutter_sdk/src/events/event.dart';
import 'package:mapospace_flutter_sdk/src/models/product_model.dart';

class SaleEvent extends EventData {
  factory SaleEvent.fromMap(Map<String, dynamic> map) {
    return SaleEvent(
      orderId: map['order_id'] as String,
      products: (jsonDecode(map['products'] as String) as List<dynamic>)
          .map<Product>((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList(),
      orderValue: map['order_value'] as String,
      paymentStatus: map['payment_status'] as String,
      paymentType: map['payment_type'] as String,
      couponCode: (jsonDecode(map['coupon_code'] as String) as List<dynamic>?)
          ?.map<String>((e) => e as String)
          .toList(),
      timestamp: map['timestamp'] as String,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  SaleEvent({
    required this.orderId,
    required this.products,
    required this.orderValue,
    required this.paymentStatus,
    required this.paymentType,
    this.couponCode,
    required this.timestamp,
    this.id,
  });

  factory SaleEvent.fromJson(String source) =>
      SaleEvent.fromMap(json.decode(source) as Map<String, dynamic>);
  final String orderId;
  final List<Product> products;
  final String orderValue;
  final String paymentStatus;
  final String paymentType;
  final List<String>? couponCode;
  final String timestamp;
  int? id;

  @override
  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'products': jsonEncode(products.map((x) => x.toMap()).toList()),
      'order_value': orderValue,
      'payment_status': paymentStatus,
      'payment_type': paymentType,
      'coupon_code': jsonEncode(couponCode),
      'timestamp': timestamp,
    };
  }
}
