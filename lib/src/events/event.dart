// event_data.dart (or similar)
import 'dart:convert';

abstract class EventData {
  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());
}
