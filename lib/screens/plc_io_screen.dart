import 'package:flutter/material.dart';

class PLCIOScreen extends StatelessWidget {
  const PLCIOScreen({super.key});

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
          _PLCIOTable(),
        ],
      ),
    );
  }
}

class _PLCIOTable extends StatelessWidget {
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
          _buildTableRow('I0.0', false),
          _buildTableRow('I0.1', false),
          _buildTableRow('I0.2', false),
          _buildTableRow('I0.3', false),
          _buildTableRow('I0.4', false),
          _buildTableRow('I0.5', false),
          _buildTableRow('I0.6', false),
          _buildTableRow('I0.7', false),
          _buildTableRow('I1.0', false),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2A2A3E), height: 1),
          const SizedBox(height: 8),
          // Outputs Section
          _buildSectionHeader('Outputs (Q)', Colors.green, Icons.arrow_upward),
          _buildTableHeader(['Address', 'Status']),
          _buildTableRow('Q0.0', false),
          _buildTableRow('Q0.1', false),
          _buildTableRow('Q0.2', false),
          _buildTableRow('Q0.3', false),
          _buildTableRow('Q0.4', false),
          _buildTableRow('Q0.5', false),
          _buildTableRow('Q0.6', false),
          _buildTableRow('Q0.7', false),
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
