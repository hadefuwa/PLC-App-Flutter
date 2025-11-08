import 'dart:async';
import 'package:flutter/material.dart';
import '../services/plc_communication_service.dart';

class PLCIOScreen extends StatefulWidget {
  const PLCIOScreen({super.key});

  @override
  State<PLCIOScreen> createState() => _PLCIOScreenState();
}

class _PLCIOScreenState extends State<PLCIOScreen> {
  final _plcService = PLCCommunicationService();
  Timer? _updateTimer;

  // I/O state - 9 inputs (I0.0-I0.7, I1.0) and 8 outputs (Q0.0-Q0.7)
  final List<bool> _inputs = List.filled(9, false);
  final List<bool> _outputs = List.filled(8, false);

  @override
  void initState() {
    super.initState();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      if (_plcService.isConnected) {
        await _updateIO();
      }
    });
  }

  Future<void> _updateIO() async {
    try {
      // Read inputs: I0.0-I0.7 (byte 0) and I1.0 (byte 1, bit 0)
      final inputData = await _plcService.readInputs(0, 2);
      if (inputData != null && mounted) {
        setState(() {
          // I0.0 to I0.7
          for (int i = 0; i < 8; i++) {
            _inputs[i] = (inputData[0] & (1 << i)) != 0;
          }
          // I1.0
          _inputs[8] = (inputData[1] & 1) != 0;
        });
      }

      // Read outputs: Q0.0-Q0.7 (byte 0)
      final outputData = await _plcService.readOutputs(0, 1);
      if (outputData != null && mounted) {
        setState(() {
          for (int i = 0; i < 8; i++) {
            _outputs[i] = (outputData[0] & (1 << i)) != 0;
          }
        });
      }
    } catch (e) {
      // Silently handle errors to avoid spamming logs
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'PLC IO Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _PLCIOTable(inputs: _inputs, outputs: _outputs),
        ],
      ),
    );
  }
}

class _PLCIOTable extends StatelessWidget {
  final List<bool> inputs;
  final List<bool> outputs;

  const _PLCIOTable({required this.inputs, required this.outputs});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: purple.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Inputs Section
          _buildSectionHeader('Inputs (I)', Colors.blue, Icons.arrow_downward, isFirst: true),
          _buildTableHeader(['Address', 'Status']),
          _buildTableRow('I0.0', inputs[0]),
          _buildTableRow('I0.1', inputs[1]),
          _buildTableRow('I0.2', inputs[2]),
          _buildTableRow('I0.3', inputs[3]),
          _buildTableRow('I0.4', inputs[4]),
          _buildTableRow('I0.5', inputs[5]),
          _buildTableRow('I0.6', inputs[6]),
          _buildTableRow('I0.7', inputs[7]),
          _buildTableRow('I1.0', inputs[8]),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2A2A3E), height: 1),
          const SizedBox(height: 8),
          // Outputs Section
          _buildSectionHeader('Outputs (Q)', Colors.green, Icons.arrow_upward),
          _buildTableHeader(['Address', 'Status']),
          _buildTableRow('Q0.0', outputs[0]),
          _buildTableRow('Q0.1', outputs[1]),
          _buildTableRow('Q0.2', outputs[2]),
          _buildTableRow('Q0.3', outputs[3]),
          _buildTableRow('Q0.4', outputs[4]),
          _buildTableRow('Q0.5', outputs[5]),
          _buildTableRow('Q0.6', outputs[6]),
          _buildTableRow('Q0.7', outputs[7]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, IconData icon, {bool isFirst = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              headers[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              headers[1],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String address, bool status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              address,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: status ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    boxShadow: status
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  status ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
