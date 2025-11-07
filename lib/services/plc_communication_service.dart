import 'dart:async';
import 'dart:io';
import '../models/data_stream_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PLCCommunicationService {
  static final PLCCommunicationService _instance = PLCCommunicationService._internal();
  factory PLCCommunicationService() => _instance;
  PLCCommunicationService._internal();

  static const String _prefKeyPlcIp = 'plc_ip_address';
  static const String _prefKeyLiveMode = 'live_mode_enabled';
  
  String? _plcIpAddress;
  bool _isLiveMode = false;
  Socket? _socket;
  Timer? _connectionTimer;
  bool _isConnected = false;

  final _logController = StreamController<DataStreamLogEntry>.broadcast();
  Stream<DataStreamLogEntry> get logStream => _logController.stream;

  final List<DataStreamLogEntry> _logHistory = [];
  static const int _maxLogEntries = 1000;

  // Initialize and load settings
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _plcIpAddress = prefs.getString(_prefKeyPlcIp) ?? '192.168.1.100';
    _isLiveMode = prefs.getBool(_prefKeyLiveMode) ?? false;
  }

  // Get PLC IP address
  String get plcIpAddress => _plcIpAddress ?? '192.168.1.100';

  // Set PLC IP address
  Future<void> setPlcIpAddress(String ip) async {
    _plcIpAddress = ip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyPlcIp, ip);
    _logDataStream('TX', 'SETTINGS', 'IP_ADDRESS', 'IP address set to $ip');
    
    // Reconnect if in live mode
    if (_isLiveMode && _isConnected) {
      disconnect();
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
      disconnect();
    }
  }

  // Connect to PLC
  Future<bool> connect() async {
    if (!_isLiveMode || _plcIpAddress == null) {
      return false;
    }

    try {
      _logDataStream('TX', 'CONNECTION', 'CONNECT', 'Connecting to PLC at $_plcIpAddress...');
      
      // Attempt TCP connection (Modbus TCP typically uses port 502)
      _socket = await Socket.connect(
        _plcIpAddress!,
        502,
        timeout: const Duration(seconds: 5),
      );

      _isConnected = true;
      _logDataStream('RX', 'CONNECTION', 'CONNECTED', 'Successfully connected to PLC');

      // Set up data listener
      _socket!.listen(
        (data) {
          _handleReceivedData(data);
        },
        onError: (error) {
          _logDataStream('RX', 'ERROR', 'SOCKET_ERROR', error.toString());
          _isConnected = false;
        },
        onDone: () {
          _logDataStream('RX', 'CONNECTION', 'DISCONNECTED', 'PLC connection closed');
          _isConnected = false;
        },
      );

      // Start periodic status check
      _startPeriodicStatusCheck();

      return true;
    } catch (e) {
      _logDataStream('RX', 'ERROR', 'CONNECTION_FAILED', e.toString());
      _isConnected = false;
      return false;
    }
  }

  // Disconnect from PLC
  void disconnect() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
    
    if (_socket != null) {
      _logDataStream('TX', 'CONNECTION', 'DISCONNECT', 'Disconnecting from PLC...');
      _socket!.close();
      _socket = null;
      _isConnected = false;
    }
  }

  // Read from PLC (Modbus read)
  Future<Map<String, dynamic>?> readHoldingRegisters(int startAddress, int quantity) async {
    if (!_isConnected || _socket == null) {
      _logDataStream('TX', 'ERROR', 'READ', 'Not connected to PLC');
      return null;
    }

    try {
      // Modbus TCP read holding registers request
      // Transaction ID (2 bytes), Protocol ID (2 bytes), Length (2 bytes)
      // Unit ID (1 byte), Function Code (1 byte), Start Address (2 bytes), Quantity (2 bytes)
      final transactionId = [0x00, 0x01];
      final protocolId = [0x00, 0x00];
      final length = [0x00, 0x06];
      final unitId = [0x01];
      final functionCode = [0x03]; // Read Holding Registers
      final startAddr = [
        (startAddress >> 8) & 0xFF,
        startAddress & 0xFF,
      ];
      final qty = [
        (quantity >> 8) & 0xFF,
        quantity & 0xFF,
      ];

      final request = [
        ...transactionId,
        ...protocolId,
        ...length,
        ...unitId,
        ...functionCode,
        ...startAddr,
        ...qty,
      ];

      _logDataStream(
        'TX',
        'MODBUS',
        'READ_HOLDING',
        'Reading $quantity registers from address $startAddress',
      );

      _socket!.add(request);
      await _socket!.flush();

      // Response will be handled in _handleReceivedData
      return {'status': 'sent'};
    } catch (e) {
      _logDataStream('TX', 'ERROR', 'READ', e.toString());
      return null;
    }
  }

  // Write to PLC (Modbus write)
  Future<bool> writeSingleRegister(int address, int value) async {
    if (!_isConnected || _socket == null) {
      _logDataStream('TX', 'ERROR', 'WRITE', 'Not connected to PLC');
      return false;
    }

    try {
      // Modbus TCP write single register request
      final transactionId = [0x00, 0x02];
      final protocolId = [0x00, 0x00];
      final length = [0x00, 0x06];
      final unitId = [0x01];
      final functionCode = [0x06]; // Write Single Register
      final addr = [
        (address >> 8) & 0xFF,
        address & 0xFF,
      ];
      final val = [
        (value >> 8) & 0xFF,
        value & 0xFF,
      ];

      final request = [
        ...transactionId,
        ...protocolId,
        ...length,
        ...unitId,
        ...functionCode,
        ...addr,
        ...val,
      ];

      _logDataStream(
        'TX',
        'MODBUS',
        'WRITE_SINGLE',
        'Writing value $value to address $address',
      );

      _socket!.add(request);
      await _socket!.flush();

      return true;
    } catch (e) {
      _logDataStream('TX', 'ERROR', 'WRITE', e.toString());
      return false;
    }
  }

  // Handle received data from PLC
  void _handleReceivedData(List<int> data) {
    if (data.isEmpty) return;

    // Parse Modbus TCP response
    final hexString = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    _logDataStream(
      'RX',
      'MODBUS',
      'RESPONSE',
      'Received ${data.length} bytes: $hexString',
    );

    // Here you would parse the Modbus response and update simulator state
    // For now, we just log it
  }

  // Start periodic status check
  void _startPeriodicStatusCheck() {
    _connectionTimer?.cancel();
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_isConnected && _isLiveMode) {
          // Read input status (example: holding registers 0-10)
          readHoldingRegisters(0, 10);
        }
      },
    );
  }

  // Log data stream entry
  void _logDataStream(String direction, String address, String value, [String? description]) {
    final entry = DataStreamLogEntry(
      timestamp: DateTime.now(),
      direction: direction,
      address: address,
      value: value,
      description: description,
    );

    _logHistory.add(entry);
    
    // Keep only last N entries
    if (_logHistory.length > _maxLogEntries) {
      _logHistory.removeAt(0);
    }

    _logController.add(entry);
  }

  // Get log history
  List<DataStreamLogEntry> getLogHistory({int? limit}) {
    if (limit == null) return List.from(_logHistory);
    return _logHistory.length > limit
        ? _logHistory.sublist(_logHistory.length - limit)
        : List.from(_logHistory);
  }

  // Clear log history
  void clearLogHistory() {
    _logHistory.clear();
    _logDataStream('TX', 'LOG', 'CLEAR', 'Log history cleared');
  }

  // Check connection status
  bool get isConnected => _isConnected;

  void dispose() {
    disconnect();
    _logController.close();
  }
}

