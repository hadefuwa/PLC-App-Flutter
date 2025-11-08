import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/plc_communication_service.dart';

class PLCSettingsScreen extends StatefulWidget {
  const PLCSettingsScreen({super.key});

  @override
  State<PLCSettingsScreen> createState() => _PLCSettingsScreenState();
}

class _PLCSettingsScreenState extends State<PLCSettingsScreen> {
  String _plcIpAddress = '192.168.0.1';
  String? _selectedIpPreset;
  int _rack = 0;
  int _slot = 1;
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _rackController = TextEditingController();
  final TextEditingController _slotController = TextEditingController();
  final PLCCommunicationService _plcService = PLCCommunicationService();
  bool _isConnecting = false;

  static const List<String> _ipPresets = [
    '192.168.0.1',
    '192.168.1.1',
    '192.168.7.2',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _plcService.initialize();
    setState(() {
      _plcIpAddress = _plcService.plcIpAddress;
      _rack = _plcService.rack;
      _slot = _plcService.slot;
      _ipController.text = _plcIpAddress;
      _rackController.text = _rack.toString();
      _slotController.text = _slot.toString();

      // Determine if current IP matches a preset
      if (_ipPresets.contains(_plcIpAddress)) {
        _selectedIpPreset = _plcIpAddress;
      } else {
        _selectedIpPreset = null; // Custom IP
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _rackController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  Future<void> _handleIpChange() async {
    final newIp = _ipController.text.trim();
    if (newIp.isEmpty || newIp == _plcIpAddress) return;

    // Basic IP validation
    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!ipRegex.hasMatch(newIp)) {
      _showMessage('Invalid IP address format');
      _ipController.text = _plcIpAddress;
      return;
    }

    await _plcService.setPlcIpAddress(newIp);
    setState(() {
      _plcIpAddress = newIp;
      // Update preset selection if it matches
      if (_ipPresets.contains(newIp)) {
        _selectedIpPreset = newIp;
      } else {
        _selectedIpPreset = null; // Custom IP
      }
    });
    _showMessage('PLC IP address updated');
  }

  Future<void> _handleIpPresetChange(String? preset) async {
    setState(() {
      _selectedIpPreset = preset;
      if (preset != null) {
        // Preset selected, update IP
        _plcIpAddress = preset;
        _ipController.text = preset;
      }
      // If null (Custom), keep current IP in text field
    });

    if (preset != null) {
      await _plcService.setPlcIpAddress(preset);
      _showMessage('PLC IP address updated to $preset');
    }
  }

  Future<void> _handleRackSlotChange() async {
    final rack = int.tryParse(_rackController.text.trim()) ?? 0;
    final slot = int.tryParse(_slotController.text.trim()) ?? 1;

    if (rack < 0 || rack > 7) {
      _showMessage('Rack must be between 0 and 7');
      _rackController.text = _rack.toString();
      return;
    }

    if (slot < 0 || slot > 31) {
      _showMessage('Slot must be between 0 and 31');
      _slotController.text = _slot.toString();
      return;
    }

    await _plcService.setRackSlot(rack, slot);
    setState(() {
      _rack = rack;
      _slot = slot;
    });
    _showMessage('Rack/Slot updated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionCard(
              title: 'PLC Connection',
              icon: Icons.settings_ethernet,
              child: Column(
                children: [
                  // Connection Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _plcService.isConnected
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _plcService.isConnected ? Colors.green : Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _plcService.isConnected ? Icons.link : Icons.link_off,
                          color: _plcService.isConnected ? Colors.green : Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _plcService.isConnected ? 'Connected' : 'Disconnected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _plcService.isConnected ? Colors.green : Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isConnecting
                                    ? 'Connecting to PLC...'
                                    : _plcService.isConnected
                                        ? 'Connected to $_plcIpAddress'
                                        : 'Not connected',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // IP Preset Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedIpPreset,
                    decoration: InputDecoration(
                      labelText: 'PLC IP Address Preset',
                      prefixIcon: const Icon(Icons.list),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                    ),
                    items: [
                      ..._ipPresets.map((ip) => DropdownMenuItem(
                        value: ip,
                        child: Text(ip),
                      )),
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Custom'),
                      ),
                    ],
                    onChanged: _handleIpPresetChange,
                  ),
                  // Custom IP Text Field (only shown when Custom is selected)
                  if (_selectedIpPreset == null) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'Custom PLC IP Address',
                        hintText: '192.168.0.1',
                        prefixIcon: const Icon(Icons.settings_ethernet),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: _handleIpChange,
                          tooltip: 'Save IP address',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _handleIpChange(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _rackController,
                          decoration: InputDecoration(
                            labelText: 'Rack',
                            hintText: '0',
                            prefixIcon: const Icon(Icons.grid_view),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _handleRackSlotChange(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _slotController,
                          decoration: InputDecoration(
                            labelText: 'Slot',
                            hintText: '1',
                            prefixIcon: const Icon(Icons.view_module),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: _handleRackSlotChange,
                              tooltip: 'Save rack/slot',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _handleRackSlotChange(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _isConnecting
                        ? null
                        : () async {
                            if (_plcService.isConnected) {
                              _plcService.disconnect();
                              _showMessage('Disconnected from PLC');
                            } else {
                              setState(() => _isConnecting = true);
                              final connected = await _plcService.connect();
                              setState(() => _isConnecting = false);
                              if (connected) {
                                _showMessage('Connected to PLC');
                              } else {
                                _showMessage('Failed to connect. Check IP address.');
                              }
                            }
                            setState(() {});
                          },
                    icon: Icon(
                      _plcService.isConnected ? Icons.link_off : Icons.link,
                    ),
                    label: Text(
                      _plcService.isConnected ? 'Disconnect' : 'Connect',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _plcService.isConnected
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionCard(
              title: 'About',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'S7 PLC Companion',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'A companion app for connecting to and controlling Siemens S7 PLCs.',
                  ),
                  const SizedBox(height: 24),
                  // Creator Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Created by',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hamed Adefuwa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse('https://www.youtube.com/channel/UCiu6Ka0kL_f_GILnbSm-5Rg');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'YouTube Channel',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const _SectionCard({
    required this.title,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
