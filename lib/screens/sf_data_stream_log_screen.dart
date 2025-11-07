import 'package:flutter/material.dart';
import '../models/data_stream_log.dart';
import '../services/plc_communication_service.dart';
import '../widgets/app_drawer.dart';

class DataStreamLogScreen extends StatefulWidget {
  const DataStreamLogScreen({super.key});

  @override
  State<DataStreamLogScreen> createState() => _DataStreamLogScreenState();
}

class _DataStreamLogScreenState extends State<DataStreamLogScreen> {
  final PLCCommunicationService _plcService = PLCCommunicationService();
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    _plcService.initialize();
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).colorScheme.primary;
    final isConnected = _plcService.isConnected;
    final isLiveMode = _plcService.isLiveMode;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Data Stream Log'),
        actions: [
          // Connection status indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLiveMode
                  ? (isConnected ? Colors.green : Colors.red)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLiveMode
                      ? (isConnected ? Icons.check_circle : Icons.error)
                      : Icons.computer,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  isLiveMode
                      ? (isConnected ? 'Connected' : 'Disconnected')
                      : 'Simulation',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Auto-scroll toggle
          IconButton(
            icon: Icon(
              _autoScroll ? Icons.arrow_downward : Icons.pause,
              color: _autoScroll ? purple : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _autoScroll = !_autoScroll;
              });
            },
            tooltip: _autoScroll ? 'Disable auto-scroll' : 'Enable auto-scroll',
          ),
          // Clear log button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearDialog();
            },
            tooltip: 'Clear log',
          ),
        ],
      ),
      body: StreamBuilder<List<DataStreamLogEntry>>(
        stream: Stream.periodic(
          const Duration(milliseconds: 100),
          (_) => _plcService.getLogHistory(),
        ),
        builder: (context, snapshot) {
          final logs = snapshot.data ?? _plcService.getLogHistory();
          
          // Auto-scroll to bottom when new entries arrive
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_autoScroll) _scrollToBottom();
          });

          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No log entries yet',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLiveMode
                        ? 'Connect to PLC to see data stream'
                        : 'Enable live mode in settings to see PLC communication',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final entry = logs[index];
              return _LogEntryTile(entry: entry);
            },
          );
        },
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Log'),
        content: const Text('Are you sure you want to clear all log entries?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _plcService.clearLogHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final DataStreamLogEntry entry;

  const _LogEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).colorScheme.primary;
    final isTx = entry.direction == 'TX';
    final isError = entry.address == 'ERROR';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? Colors.red.withValues(alpha: 0.1)
            : isTx
                ? purple.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? Colors.red.withValues(alpha: 0.3)
              : isTx
                  ? purple.withValues(alpha: 0.3)
                  : Colors.blue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direction indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isError
                  ? Colors.red
                  : isTx
                      ? purple
                      : Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                entry.direction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Log content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.address,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isError ? Colors.red : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(entry.timestamp),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                if (entry.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

