import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mapospace_flutter_sdk/src/api_key_reader.dart';
import 'package:mapospace_flutter_sdk/src/events/sale_event.dart';
import 'package:mapospace_flutter_sdk/src/utils/sqflite_helper.dart';
import 'package:uuid/uuid.dart';

class Mapospace {
  factory Mapospace() => _instance;

  Mapospace._internal();
  static final Mapospace _instance = Mapospace._internal();

  bool _isInitialized = false;
  String? _apiKey;
  String? _deviceId;
  String? _sessionID; // You might want to generate a session ID
  String? _mapospaceToken; // You might want to generate a session ID
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  BaseDeviceInfo? _deviceSpecs;
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  Position? _currentPosition;
  String? _useragent;
  final SaleEventDatabaseHelper _dbHelper = SaleEventDatabaseHelper();
  final String _apiUrl =
      'https://developingress-dot-mapospacev1.el.r.appspot.com/api/v1/sdk/payload/custom'; // *** REPLACE THIS! ***
  static const int _batchSize = 10;

  bool get isInitialized => _isInitialized;
  String? get deviceId => _deviceId;
  String? get sessionID => _sessionID;
  BaseDeviceInfo? get deviceSpecs => _deviceSpecs;
  Position? get currentPosition => _currentPosition;
  String? get useragent => _useragent;

  Future<String> _getApiKey(String apiKeyPath) async {
    return await APIKeyReader().readProjectAsset(apiKeyPath);
  }

  Future<String> _getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      return webBrowserInfo.userAgent ?? "Unknown";
    } else {
      final deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    }
  }

  Future<BaseDeviceInfo> _getDeviceSpecs() async {
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo;
    }
  }

  Future<String?> _getUserAgent() async {
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent;
    } else {
      return null;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
          'Location services are disabled. Please enable the services');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time stay silent
        return Future.error(
            'Location permissions are denied. Please enable the permission');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> captureSaleEvent({required SaleEvent event}) async {
    await _dbHelper.insertSaleEvent(event);
    print('Sale event captured and stored locally.');
  }

  Future<void> _sendSaleEventsToApi() async {
    final unsentEvents = await _dbHelper.getUnsentSaleEvents();
    if (unsentEvents.isEmpty) {
      print('No unsent sale events.');
      return;
    }
    // Break into batches of 10
    List<List<SaleEvent>> chunkedEvents = [];
    for (var i = 0; i < unsentEvents.length; i += _batchSize) {
      chunkedEvents.add(unsentEvents.sublist(
          i,
          i + _batchSize > unsentEvents.length
              ? unsentEvents.length
              : i + _batchSize));
    }

    for (final eventBatch in chunkedEvents) {
      try {
        // Construct the request body to the specified format
        List<Map<String, dynamic>> eventList = [];
        for (final event in eventBatch) {
          eventList.add(event.toMap());
        }
        final requestBody = jsonEncode({
          'deviceId': _deviceId,
          'mapospaceToken': _mapospaceToken,
          'session_id': _sessionID,
          'device_specs': _deviceSpecs is AndroidDeviceInfo
              ? (_deviceSpecs! as AndroidDeviceInfo).data
              : _deviceSpecs is WebBrowserInfo
                  ? (_deviceSpecs! as WebBrowserInfo).data
                  : <String, dynamic>{},
          'location': {
            'location_type': 'fine',
            'lat': _currentPosition?.latitude,
            'lng': _currentPosition?.longitude,
            'alt': _currentPosition?.altitude,
          },
          'events': eventList,
        });
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'api-key': _apiKey ?? '',
          },
          body: requestBody,
        );

        if (response.statusCode == 200) {
          if (kDebugMode) {
            print('Sale events sent successfully!');
          }
          // Remove sent events from the local database
          for (final event in eventBatch) {
            await _dbHelper.deleteSaleEvent(event.id!);
          }
        } else {
          if (kDebugMode) {
            print(
                'Failed to send events. Status code: ${response.statusCode}, body: ${response.body}');
          }
          // Optionally, implement retry logic or error handling
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending sale events: $e');
        }
        // Optionally, implement retry logic or error handling
      }
    }
  }

  Future<void> initialize({required String apiKeyPath}) async {
    // Set the initialized flag
    _isInitialized = true;
    _apiKey = await _getApiKey(apiKeyPath);
    _deviceId = await _getDeviceId();
    _sessionID = Uuid().v1(); //Generate new one every time or on app restart
    _mapospaceToken = '$deviceId';
    _deviceSpecs = await _getDeviceSpecs();
    _currentPosition = await _determinePosition();
    _useragent = await _getUserAgent();
    await _dbHelper.database;
    await _sendSaleEventsToApi();
  }
}
