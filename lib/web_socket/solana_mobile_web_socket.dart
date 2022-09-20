/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show protected;
import 'package:synchronized/synchronized.dart';


/// Solana Mobile Web Socket State
/// ------------------------------------------------------------------------------------------------

enum SolanaMobileWebSocketState {

  connecting(WebSocket.connecting),
  connected(WebSocket.open),
  disconnecting(WebSocket.closing),
  disconnected(WebSocket.closed),
  ;

  /// Maps [WebSocket] status codes to enum variants.
  const SolanaMobileWebSocketState(this.code);

  /// The underlying [WebSocket] status code.
  final int code;

  /// Creates a [SolanaMobileWebSocketState] instance from the provided [WebSocket] status code.
  /// 
  /// The state defaults to [SolanaMobileWebSocketState.disconnected].
  factory SolanaMobileWebSocketState.byCode(final int? code) =>
    values.firstWhere(
      (value) => value.code == code, 
      orElse: () => SolanaMobileWebSocketState.disconnected,
    );
}


/// Solana Mobile Web Socket
/// ------------------------------------------------------------------------------------------------

class SolanaMobileWebSocket {

  /// Manages a single web socket connection.
  SolanaMobileWebSocket({
    final int? maxAttempts,
    final List<int>? backoffSchedule,
    this.protocols,
  }): maxAttempts = maxAttempts ?? 1,
      backoffSchedule = backoffSchedule ?? const [],
      assert(maxAttempts == null || maxAttempts > 0);

  /// The default maximum number of connection attempts per `connect()` call.
  final int maxAttempts;

  /// The default backoff schedule.
  final List<int> backoffSchedule;

  /// The default subprotocols.
  final Iterable<String>? protocols;

  /// Guards critical sections of the connection cycle (connect/disconnect).
  @protected
  final Lock lock = Lock();

  /// The underlying web socket.
  @protected
  WebSocket? socket;

  /// The established connection's timestamp or `null` if not connected.
  DateTime? _connectedAt;
  DateTime? get connectedAt => _connectedAt;

  /// True if [disconnect] has been called after a call to [connect]
  bool _disconnected = false;
  
  /// The callback function triggered when the socket connects.
  @protected
  void Function(WebSocket socket)? onConnect;

  /// The web socket's current connection state.
  SolanaMobileWebSocketState get state => SolanaMobileWebSocketState.byCode(socket?.readyState);

  /// Returns true if the socket is open.
  bool get isConnected => state == SolanaMobileWebSocketState.connected;

  /// Adds listeners to be called within the connect() and disconnect() synchronised execution 
  /// blocks.
  void listen({
    final void Function(WebSocket socket)? onConnect,
  }) {
    this.onConnect = onConnect;
  }

  /// Creates a web socket connection to [uri].
  /// 
  /// The [protocols] argument specifies the subprotocols the client is willing to speak.
  Future<WebSocket> connect(
    final Uri uri, { 
    final Duration? pingInterval,
    final Iterable<String>? protocols,
    final int? maxAttempts,
    final List<int>? backoffSchedule,
    final Duration? timeout, 
    final Duration? lockTimeout, 
  }) => lock.synchronized(
      timeout: lockTimeout,
      () => _connect(
        uri,
        pingInterval: pingInterval, 
        protocols: protocols,
        maxAttempts: maxAttempts,
        backoffSchedule: backoffSchedule,
        timeout: timeout,
      ), 
    );

  /// Creates a web socket connection to [uri].
  /// 
  /// This method must be called inside of [lock.synchronized].
  /// 
  /// The [protocols] argument specifies the subprotocols the client is willing to speak.
  Future<WebSocket> _connect(
    final Uri uri, { 
    final Duration? pingInterval,
    final Iterable<String>? protocols,
    final int? maxAttempts,
    final List<int>? backoffSchedule,
    final Duration? timeout,
  }) async {
    assert(lock.locked);
    
    WebSocket? socket = this.socket;
    if (socket != null && isConnected) {
      return socket;
    }

    _disconnected = false;
    
    for (int i = 0; i < (maxAttempts ?? this.maxAttempts); ++i) {
      try {
        await backoff(i, schedule: backoffSchedule ?? this.backoffSchedule);
        final connect = WebSocket.connect(uri.toString(), protocols: protocols ?? this.protocols);
        socket = await (timeout != null ? connect.timeout(timeout) : connect);
        _connectedAt = DateTime.now().toUtc();
        socket.pingInterval = pingInterval;
        this.socket = socket;
        onConnect?.call(socket);
        return socket;
      } catch(_) {
        if (_disconnected) {
          return Future.error(const WebSocketException('[SolanaMobileWebSocket] disconnected.'));
        }
        /// Try again...
      }
    }

    return Future.error(const WebSocketException('[SolanaMobileWebSocket] failed to connect.'));
  }

  /// Returns a future that completes after `schedule[i]` milliseconds. If [i] is out of range, the 
  /// future completes in [schedule.last] milliseconds or immediately when [schedule] is empty.
  FutureOr<void> backoff(final int i, { required final List<int> schedule }) {
    final int delayMs = i < schedule.length ? schedule[i] : (schedule.isEmpty ? 0 : schedule.last);
    return delayMs > 0 ? Future.delayed(Duration(milliseconds: delayMs)) : null;
  }

  /// Disconnects the web socket connection.
  Future<void> disconnect([
    final int? code, 
    final String? reason,
  ]) {
    _disconnected = true;
    return lock.synchronized(() => _disconnect(code, reason));
  }

  /// Disconnects the web socket connection.
  /// 
  /// This method must be called inside of [lock.synchronized].
  Future<void> _disconnect([final int? code, final String? reason]) async {
    assert(lock.locked);
    final WebSocket? socket = this.socket;
    this.socket = null;
    _connectedAt = null;
    return socket?.close(code, reason) ?? Future.value();
  }

  /// Sends [data] on the web socket connection.
  void send(final dynamic data) {
    final WebSocket? socket = this.socket;
    return socket != null 
      ? socket.add(data) 
      : throw const WebSocketException(
          '[SolanaMobileWebSocket.send()] has been called before connect().',
        );
  }

  /// Sends JSON [data] on the web socket connection.
  void sendJson(final Map<String, dynamic> data) => send(jsonEncode(data).codeUnits);
}