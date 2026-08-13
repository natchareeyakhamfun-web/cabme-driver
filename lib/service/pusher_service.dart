import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();

  factory PusherService() => _instance;

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final Map<String, Function(dynamic)> _eventCallbacks = {};
  final Set<String> _subscribedChannels = {};
  bool _initialized = false;

  PusherService._internal();

  /// Initialize Pusher
  Future<void> init({
    required String apiKey,
    required String cluster,
  }) async {
    if (_initialized) return;

    await pusher.init(
      apiKey: apiKey,
      cluster: cluster,
      onEvent: (PusherEvent event) {
        final key = '${event.channelName}:${event.eventName}';
        final raw = event.data;

        if (_eventCallbacks.containsKey(key)) {
          dynamic decoded = raw;
          try {
            if (raw is String && raw.trim().startsWith("{")) {
              decoded = jsonDecode(raw);
            }
          } catch (e) {
            debugPrint("❌ JSON decode error: $e | raw: $raw");
          }

          try {
            _eventCallbacks[key]?.call(decoded);
          } catch (e, stack) {
            debugPrint("❌ Callback error: $e\n$stack");
          }
        }
      },
      onConnectionStateChange: (currentState, previousState) {
        debugPrint("🔌 Connection state changed: $previousState → $currentState");

        // ✅ Re-subscribe to all channels on reconnect
        if (currentState == 'CONNECTED') {
          for (final channel in _subscribedChannels) {
            pusher.subscribe(channelName: channel);
            debugPrint("🔄 Re-subscribed to $channel after reconnect");
          }
        }
      },
      onSubscriptionSucceeded: (channelName, data) {
        debugPrint("✅ Subscribed to $channelName");
      },
      onError: (message, code, e) {
        debugPrint("❗ Pusher Error: $message ($code)");
      },
    );

    await pusher.connect();
    _initialized = true;
  }

  // -----------------------------
  // 🚖 Driver New Order Channel
  // -----------------------------
  Future<void> subscribeDriverRecentRide<T>(
      {required String driverId,
      required String event,
      required T Function(Map<String, dynamic>) fromJson,
      required void Function(T) onData}) async {
    final channelName = 'driverNewOrder.$driverId';
    final eventKey = '$channelName:$event';

    // Register callback
    _eventCallbacks[eventKey] = (data) {
      final pretty = data is Map || data is List
          ? const JsonEncoder.withIndent('  ').convert(data)
          : data.toString();
      log("📬 Received event [$eventKey]: $pretty");
      try {
        final parsed = data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
        final model = fromJson(parsed);
        onData(model);
      } catch (e, stack) {
        debugPrint("❌ Error parsing DriverRecentRide model: $e\n$stack\nData: $data");
      }
    };

    // Subscribe only once per channel
    if (!_subscribedChannels.contains(channelName)) {
      try {
        await pusher.subscribe(channelName: channelName);
        _subscribedChannels.add(channelName);
      } catch (e) {
        debugPrint("❌ Subscription error (DriverRecentRide): $e");
      }
    }
  }

  Future<void> unsubscribeDriverRecentRide(String driverId) async {
    final channel = 'driverNewOrder.$driverId';
    await pusher.unsubscribe(channelName: channel);
    _subscribedChannels.remove(channel);
    _eventCallbacks.removeWhere((key, _) => key.startsWith('$channel:'));
    debugPrint('🚫 Unsubscribed from $channel');
  }

  // -----------------------------
  // 🚗 Ride Channel
  // -----------------------------
  Future<void> subscribeToRideEvent<T>({
    required String rideId,
    required String event,
    required T Function(Map<String, dynamic>) fromJson,
    required void Function(T) onData,
  }) async {
    final channelName = 'ride.$rideId';
    final eventKey = '$channelName:$event';

    // Register callback
    _eventCallbacks[eventKey] = (data) {
      final pretty = data is Map || data is List
          ? const JsonEncoder.withIndent('  ').convert(data)
          : data.toString();
      log("📬 Received event [$eventKey]: $pretty");
      try {
        final parsed = data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
        final model = fromJson(parsed);
        onData(model);
      } catch (e, stack) {
        debugPrint("❌ Error parsing Ride model: $e\n$stack\nData: $data");
      }
    };

    // Subscribe only once per channel
    if (!_subscribedChannels.contains(channelName)) {
      try {
        await pusher.subscribe(channelName: channelName);
        _subscribedChannels.add(channelName);
      } catch (e) {
        debugPrint("❌ Subscription error (Ride): $e");
      }
    }
  }

  Future<void> unsubscribeRide(String rideId) async {
    final channel = 'ride.$rideId';
    await pusher.unsubscribe(channelName: channel);
    _subscribedChannels.remove(channel);
    _eventCallbacks.removeWhere((key, _) => key.startsWith('$channel:'));
    debugPrint('🚫 Unsubscribed from $channel');
  }

  // -----------------------------
  // 🧑‍✈️ Driver Channel
  // -----------------------------
  Future<void> subscribeToDriverEvent<T>({
    required String driverId,
    required String event,
    required T Function(Map<String, dynamic>) fromJson,
    required void Function(T) onData,
  }) async {
    final channelName = 'driver.$driverId';
    final eventKey = '$channelName:$event';

    // Register callback
    _eventCallbacks[eventKey] = (data) {
      final pretty = data is Map || data is List
          ? const JsonEncoder.withIndent('  ').convert(data)
          : data.toString();
      log("📬 Received event [$eventKey]: $pretty");
      try {
        final parsed = data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
        final model = fromJson(parsed);
        onData(model);
      } catch (e, stack) {
        debugPrint("❌ Error parsing Driver model: $e\n$stack\nData: $data");
      }
    };

    // Subscribe only once per channel
    if (!_subscribedChannels.contains(channelName)) {
      try {
        await pusher.subscribe(channelName: channelName);
        _subscribedChannels.add(channelName);
      } catch (e) {
        debugPrint("❌ Subscription error (Driver): $e");
      }
    }
  }

  Future<void> unsubscribeDriver(String driverId) async {
    final channel = 'driver.$driverId';
    await pusher.unsubscribe(channelName: channel);
    _subscribedChannels.remove(channel);
    _eventCallbacks.removeWhere((key, _) => key.startsWith('$channel:'));
    debugPrint('🚫 Unsubscribed from $channel');
  }
}
