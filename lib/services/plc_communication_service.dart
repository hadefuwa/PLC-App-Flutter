import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import '../models/data_stream_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_snap7/dart_snap7.dart';

class PLCCommunicationService {
  static final PLCCommunicationService _instance = PLCCommunicationService._internal();
  factory PLCCommunicationService() => _instance;
  PLCCommunicationService._internal();

  static const String _prefKeyPlcIp = 'plc_ip_address';
  static const String _prefKeyLiveMode = 'live_mode_enabled';
  static const String _prefKeyRack = 'plc_rack';
  static const String _prefKeySlot = 'plc_slot';

  String? _plcIpAddress;
  int _rack = 0;
  int _slot = 1;
  bool _isLiveMode = true;
  AsyncClient? _client;
  Timer? _connectionTimer;
  bool _isConnected = false;
  String _lastError = '';

  // Connection retry settings
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  DateTime? _lastConnectionAttempt;
  static const Duration _connectionAttemptInterval = Duration(seconds: 5);

  final _logController = StreamController<DataStreamLogEntry>.broadcast();
  Stream<DataStreamLogEntry> get logStream => _logController.stream;

  final List<DataStreamLogEntry> _logHistory = [];
  static const int _maxLogEntries = 1000;

  // Initialize and load settings
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _plcIpAddress = prefs.getString(_prefKeyPlcIp) ?? '192.168.0.99';
    _rack = prefs.getInt(_prefKeyRack) ?? 0;
    _slot = prefs.getInt(_prefKeySlot) ?? 1;
    _isLiveMode = prefs.getBool(_prefKeyLiveMode) ?? true;
  }

  // Get PLC IP address
  String get plcIpAddress => _plcIpAddress ?? '192.168.0.99';

  // Get rack
  int get rack => _rack;

  // Get slot
  int get slot => _slot;

  // Set PLC IP address
  Future<void> setPlcIpAddress(String ip) async {
    _plcIpAddress = ip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyPlcIp, ip);
    _logDataStream('TX', 'SETTINGS', 'IP_ADDRESS', 'IP address set to $ip');

    // Reconnect if in live mode
    if (_isLiveMode && _isConnected) {
      await disconnect();
      await connect();
    }
  }

  // Set rack and slot
  Future<void> setRackSlot(int rack, int slot) async {
    _rack = rack;
    _slot = slot;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyRack, rack);
    await prefs.setInt(_prefKeySlot, slot);
    _logDataStream('TX', 'SETTINGS', 'RACK_SLOT', 'Rack: $rack, Slot: $slot');

    // Reconnect if in live mode
    if (_isLiveMode && _isConnected) {
      await disconnect();
      await connect();
    }
  }

  // Check if live mode is enabled
  bool get isLiveMode => _isLiveMode;

  // Set live mode
  Future<void> setLiveMode(bool enabled) async {
    _isLiveMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyLiveMode, enabled);

    if (enabled) {
      _logDataStream('TX', 'SETTINGS', 'MODE', 'Live mode enabled');
      await connect();
    } else {
      _logDataStream('TX', 'SETTINGS', 'MODE', 'Simulation mode enabled');
      await disconnect();
    }
  }

  // Connect to PLC using dart_snap7
  Future<bool> connect() async {
    // Check if running on iOS
    if (Platform.isIOS) {
      _lastError = 'PLC connection is only supported on Android devices';
      _logDataStream('TX', 'ERROR', 'PLATFORM_NOT_SUPPORTED',
        '⚠️ PLC connection is only supported on Android. iOS support requires additional native library setup.');
      _isConnected = false;
      return false;
    }

    if (!_isLiveMode || _plcIpAddress == null) {
      return false;
    }

    try {
      final currentTime = DateTime.now();

      // Don't attempt connection too frequently
      if (_lastConnectionAttempt != null &&
          currentTime.difference(_lastConnectionAttempt!) < _connectionAttemptInterval) {
        return _isConnected;
      }

      _lastConnectionAttempt = currentTime;

      // Check if already connected
      if (_isConnected && _client != null) {
        return true;
      }

      _logDataStream('TX', 'CONNECTION', 'CONNECT',
        'Connecting to S7-1200 at $_plcIpAddress (Rack: $_rack, Slot: $_slot) using dart_snap7...');

      // Try to connect with retries
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        try {
          // Cleanup any existing client
          if (_client != null) {
            try {
              await _client!.disconnect();
              await _client!.destroy();
            } catch (e) {
              _logDataStream('RX', 'DEBUG', 'CLEANUP', 'Error cleaning up old client: $e');
            }
            _client = null;
          }

          // Create new AsyncClient
          _client = AsyncClient();

          _logDataStream('TX', 'SNAP7', 'INIT', 'Initializing Snap7 client (attempt ${attempt + 1}/$_maxRetries)');
          await _client!.init();

          _logDataStream('TX', 'SNAP7', 'CONNECT', 'Connecting to PLC...');
          await _client!.connect(_plcIpAddress!, _rack, _slot);

          _isConnected = true;
          _lastError = '';
          _logDataStream('RX', 'CONNECTION', 'CONNECTED',
            'Successfully connected to S7-1200 using dart_snap7!');

          // Start periodic status check
          _startPeriodicStatusCheck();
          return true;

        } catch (e) {
          _lastError = 'Connection error: $e';
          _logDataStream('RX', 'ERROR', 'CONNECTION_FAILED',
            '$e (attempt ${attempt + 1}/$_maxRetries)');

          // Cleanup on failure
          if (_client != null) {
            try {
              await _client!.disconnect();
              await _client!.destroy();
            } catch (cleanupError) {
              _logDataStream('RX', 'DEBUG', 'CLEANUP_ERROR', 'Error during cleanup: $cleanupError');
            }
            _client = null;
          }
        }

        // Wait before retry
        if (attempt < _maxRetries - 1) {
          await Future.delayed(_retryDelay);
        }
      }

      _isConnected = false;
      return false;
    } catch (e) {
      _lastError = 'Connection error: $e';
      _logDataStream('RX', 'ERROR', 'CONNECTION_FAILED', e.toString());
      if (_client != null) {
        try {
          await _client!.disconnect();
          await _client!.destroy();
        } catch (cleanupError) {
          // Ignore cleanup errors
        }
        _client = null;
      }
      _isConnected = false;
      return false;
    }
  }

  // Disconnect from PLC
  Future<void> disconnect() async {
    _connectionTimer?.cancel();
    _connectionTimer = null;

    if (_client != null) {
      _logDataStream('TX', 'CONNECTION', 'DISCONNECT', 'Disconnecting from PLC...');
      try {
        await _client!.disconnect();
        await _client!.destroy();
      } catch (e) {
        _logDataStream('RX', 'ERROR', 'DISCONNECT', 'Error during disconnect: $e');
      }
      _client = null;
      _isConnected = false;
    }
  }

  // Read data block bytes
  Future<Uint8List?> readDataBlock(int dbNumber, int start, int size) async {
    if (!_isConnected || _client == null) {
      _logDataStream('TX', 'ERROR', 'READ', 'Not connected to PLC');
      return null;
    }

    try {
      _logDataStream('TX', 'S7', 'READ_DB',
        'Reading DB$dbNumber from byte $start, size $size bytes');

      final data = await _client!.readDataBlock(dbNumber, start, size);

      _logDataStream('RX', 'S7', 'READ_DB',
        'Read ${data.length} bytes: ${_hexDump(data)}');

      return data;
    } catch (e) {
      _lastError = 'Error reading DB$dbNumber: $e';
      _logDataStream('RX', 'ERROR', 'READ_DB', _lastError);
      return null;
    }
  }

  // Write data block bytes
  Future<bool> writeDataBlock(int dbNumber, int start, Uint8List data) async {
    if (!_isConnected || _client == null) {
      _logDataStream('TX', 'ERROR', 'WRITE', 'Not connected to PLC');
      return false;
    }

    try {
      _logDataStream('TX', 'S7', 'WRITE_DB',
        'Writing DB$dbNumber at byte $start, ${data.length} bytes: ${_hexDump(data)}');

      await _client!.writeDataBlock(dbNumber, start, data);

      _logDataStream('RX', 'S7', 'WRITE_DB', 'Write successful');
      return true;
    } catch (e) {
      _lastError = 'Error writing DB$dbNumber: $e';
      _logDataStream('RX', 'ERROR', 'WRITE_DB', _lastError);
      return false;
    }
  }

  // Read Merkers (M memory)
  Future<Uint8List?> readMerkers(int start, int size) async {
    if (!_isConnected || _client == null) {
      _logDataStream('TX', 'ERROR', 'READ', 'Not connected to PLC');
      return null;
    }

    try {
      _logDataStream('TX', 'S7', 'READ_MERKERS',
        'Reading Merkers from M$start, size $size bytes');

      final data = await _client!.readMerkers(start, size);

      _logDataStream('RX', 'S7', 'READ_MERKERS',
        'Read ${data.length} bytes: ${_hexDump(data)}');

      return data;
    } catch (e) {
      _lastError = 'Error reading Merkers: $e';
      _logDataStream('RX', 'ERROR', 'READ_MERKERS', _lastError);
      return null;
    }
  }

  // Write Merkers (M memory)
  Future<bool> writeMerkers(int start, Uint8List data) async {
    if (!_isConnected || _client == null) {
      _logDataStream('TX', 'ERROR', 'WRITE', 'Not connected to PLC');
      return false;
    }

    try {
      _logDataStream('TX', 'S7', 'WRITE_MERKERS',
        'Writing Merkers at M$start, ${data.length} bytes: ${_hexDump(data)}');

      await _client!.writeMerkers(start, data);

      _logDataStream('RX', 'S7', 'WRITE_MERKERS', 'Write successful');
      return true;
    } catch (e) {
      _lastError = 'Error writing Merkers: $e';
      _logDataStream('RX', 'ERROR', 'WRITE_MERKERS', _lastError);
      return false;
    }
  }

  // Read REAL (float) value from data block
  Future<double?> readDbReal(int dbNumber, int offset) async {
    try {
      final data = await readDataBlock(dbNumber, offset, 4);
      if (data == null || data.length < 4) {
        _lastError = 'Error reading DB$dbNumber.DBD$offset: Invalid data';
        return null;
      }

      final byteData = ByteData.view(data.buffer);
      return byteData.getFloat32(0, Endian.big);
    } catch (e) {
      _lastError = 'Error reading DB$dbNumber.DBD$offset: $e';
      _logDataStream('RX', 'ERROR', 'READ_REAL', _lastError);
      return null;
    }
  }

  // Write REAL (float) value to data block
  Future<bool> writeDbReal(int dbNumber, int offset, double value) async {
    try {
      final byteData = ByteData(4);
      byteData.setFloat32(0, value, Endian.big);
      final data = byteData.buffer.asUint8List();

      return await writeDataBlock(dbNumber, offset, data);
    } catch (e) {
      _lastError = 'Error writing DB$dbNumber.DBD$offset: $e';
      _logDataStream('TX', 'ERROR', 'WRITE_REAL', _lastError);
      return false;
    }
  }

  // Read BOOL value from data block
  Future<bool?> readDbBool(int dbNumber, int byteOffset, int bitOffset) async {
    try {
      if (bitOffset < 0 || bitOffset > 7) {
        _lastError = 'Bit offset must be between 0 and 7';
        return null;
      }

      final data = await readDataBlock(dbNumber, byteOffset, 1);
      if (data == null || data.isEmpty) {
        _lastError = 'Error reading DB$dbNumber.DBX$byteOffset.$bitOffset: Invalid data';
        return null;
      }

      return data[0].getBit(bitOffset);
    } catch (e) {
      _lastError = 'Error reading DB$dbNumber.DBX$byteOffset.$bitOffset: $e';
      _logDataStream('RX', 'ERROR', 'READ_BOOL', _lastError);
      return null;
    }
  }

  // Write BOOL value to data block
  Future<bool> writeDbBool(int dbNumber, int byteOffset, int bitOffset, bool value) async {
    try {
      if (bitOffset < 0 || bitOffset > 7) {
        _lastError = 'Bit offset must be between 0 and 7';
        return false;
      }

      // Read current byte
      final currentData = await readDataBlock(dbNumber, byteOffset, 1);
      if (currentData == null || currentData.isEmpty) {
        _lastError = 'Error reading DB$dbNumber.DBX$byteOffset.$bitOffset for write';
        return false;
      }

      // Modify bit
      final byteValue = currentData[0].setBit(bitOffset, value);

      // Write back
      return await writeDataBlock(dbNumber, byteOffset, Uint8List.fromList([byteValue]));
    } catch (e) {
      _lastError = 'Error writing DB$dbNumber.DBX$byteOffset.$bitOffset: $e';
      _logDataStream('TX', 'ERROR', 'WRITE_BOOL', _lastError);
      return false;
    }
  }

  // Read INT value from data block
  Future<int?> readDbInt(int dbNumber, int offset) async {
    try {
      final data = await readDataBlock(dbNumber, offset, 2);
      if (data == null || data.length < 2) {
        _lastError = 'Error reading DB$dbNumber.DBW$offset: Invalid data';
        return null;
      }

      final byteData = ByteData.view(data.buffer);
      return byteData.getInt16(0, Endian.big);
    } catch (e) {
      _lastError = 'Error reading DB$dbNumber.DBW$offset: $e';
      _logDataStream('RX', 'ERROR', 'READ_INT', _lastError);
      return null;
    }
  }

  // Write INT value to data block
  Future<bool> writeDbInt(int dbNumber, int offset, int value) async {
    try {
      final byteData = ByteData(2);
      byteData.setInt16(0, value, Endian.big);
      final data = byteData.buffer.asUint8List();

      return await writeDataBlock(dbNumber, offset, data);
    } catch (e) {
      _lastError = 'Error writing DB$dbNumber.DBW$offset: $e';
      _logDataStream('TX', 'ERROR', 'WRITE_INT', _lastError);
      return false;
    }
  }

  // Read Merker bit
  Future<bool?> readMBit(int byteOffset, int bitOffset) async {
    try {
      if (bitOffset < 0 || bitOffset > 7) {
        _lastError = 'Bit offset must be between 0 and 7';
        return null;
      }

      final data = await readMerkers(byteOffset, 1);
      if (data == null || data.isEmpty) {
        _lastError = 'Error reading M$byteOffset.$bitOffset: Invalid data';
        return null;
      }

      return data[0].getBit(bitOffset);
    } catch (e) {
      _lastError = 'Error reading M$byteOffset.$bitOffset: $e';
      _logDataStream('RX', 'ERROR', 'READ_M_BIT', _lastError);
      return null;
    }
  }

  // Write Merker bit
  Future<bool> writeMBit(int byteOffset, int bitOffset, bool value) async {
    try {
      if (bitOffset < 0 || bitOffset > 7) {
        _lastError = 'Bit offset must be between 0 and 7';
        return false;
      }

      // Read current byte
      final currentData = await readMerkers(byteOffset, 1);
      if (currentData == null || currentData.isEmpty) {
        _lastError = 'Error reading M$byteOffset.$bitOffset for write';
        return false;
      }

      // Modify bit
      final byteValue = currentData[0].setBit(bitOffset, value);

      // Write back
      return await writeMerkers(byteOffset, Uint8List.fromList([byteValue]));
    } catch (e) {
      _lastError = 'Error writing M$byteOffset.$bitOffset: $e';
      _logDataStream('TX', 'ERROR', 'WRITE_M_BIT', _lastError);
      return false;
    }
  }

  // Start periodic status check
  void _startPeriodicStatusCheck() {
    _connectionTimer?.cancel();
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) async {
        if (_isConnected && _isLiveMode && _client != null) {
          try {
            // Example: read DB1 first 10 bytes as a heartbeat
            await readDataBlock(1, 0, 10);
          } catch (e) {
            _logDataStream('RX', 'ERROR', 'HEARTBEAT', 'Heartbeat failed: $e');
          }
        }
      },
    );
  }

  // Helper to create hex dump for debugging
  String _hexDump(Uint8List data, {int maxBytes = 32}) {
    final bytes = data.length > maxBytes ? data.sublist(0, maxBytes) : data;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');
    return data.length > maxBytes ? '$hex... (${data.length} total)' : hex;
  }

  // Log data stream entry
  void _logDataStream(String direction, String category, String type, String message) {
    final entry = DataStreamLogEntry(
      timestamp: DateTime.now(),
      direction: direction,
      address: '$category.$type',
      value: message,
      description: null,
    );

    _logHistory.add(entry);

    // Keep only last N entries
    if (_logHistory.length > _maxLogEntries) {
      _logHistory.removeAt(0);
    }

    _logController.add(entry);
  }

  // Get log history
  List<DataStreamLogEntry> getLogHistory() {
    return List.unmodifiable(_logHistory);
  }

  // Clear log history
  void clearLogHistory() {
    _logHistory.clear();
    _logDataStream('TX', 'LOG', 'CLEAR', 'Log history cleared');
  }

  // Check connection status
  bool get isConnected => _isConnected;

  // Get last error message
  String get lastError => _lastError;

  // Get connection status info
  Map<String, dynamic> getStatus() {
    return {
      'connected': _isConnected,
      'ip': _plcIpAddress ?? '192.168.0.99',
      'rack': _rack,
      'slot': _slot,
      'lastError': _lastError,
      'liveMode': _isLiveMode,
    };
  }

  void dispose() {
    disconnect();
    _logController.close();
  }
}

// Extension for bit manipulation
extension BitMap on int {
  bool getBit(int pos) {
    final x = this >> pos;
    return x & 1 == 1;
  }

  int setBit(int pos, bool bit) {
    final x = 1 << pos;
    if (bit) {
      return this | x;
    }
    return getBit(pos) ? this ^ x : this;
  }
}
