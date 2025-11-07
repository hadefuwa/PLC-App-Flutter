import 'package:flutter/material.dart';
import '../models/simulator_state.dart';
import '../services/simulator_service.dart';
import '../services/plc_communication_service.dart';
import 'sf_data_stream_log_screen.dart';

class SFSettingsScreen extends StatefulWidget {
  const SFSettingsScreen({super.key});

  @override
  State<SFSettingsScreen> createState() => _SFSettingsScreenState();
}

class _SFSettingsScreenState extends State<SFSettingsScreen> {
  double _speedScaling = 1.0;
  bool _randomFaults = false;
  bool _isLiveMode = false;
  String _plcIpAddress = '192.168.1.100';
  final TextEditingController _ipController = TextEditingController();
  final PLCCommunicationService _plcService = PLCCommunicationService();
  bool _isConnecting = false;
  
  final Map<PartMaterial, double> _materialMix = {
    PartMaterial.steel: 33.0,
    PartMaterial.aluminium: 33.0,
    PartMaterial.plastic: 34.0,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _plcService.initialize();
    setState(() {
      _isLiveMode = _plcService.isLiveMode;
      _plcIpAddress = _plcService.plcIpAddress;
      _ipController.text = _plcIpAddress;
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _handleModeChange(bool isLive) async {
    if (isLive == _isLiveMode) return;

    setState(() {
      _isConnecting = isLive;
    });

    await _plcService.setLiveMode(isLive);
    
    if (isLive) {
      final connected = await _plcService.connect();
      if (!connected) {
        _showMessage('Failed to connect to PLC. Check IP address and try again.');
      }
    }

    setState(() {
      _isLiveMode = isLive;
      _isConnecting = false;
    });
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
    });
    _showMessage('PLC IP address updated');
  }

  @override
  Widget build(BuildContext context) {
    final simulator = SimulatorService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionCard(
              title: 'Mode',
              child: Column(
                children: [
                  _RadioTile(
                    title: 'Simulation',
                    subtitle: 'Run with simulated data',
                    value: false,
                    groupValue: _isLiveMode,
                    onChanged: _isConnecting ? null : (value) => _handleModeChange(false),
                  ),
                  _RadioTile(
                    title: 'Live',
                    subtitle: _isConnecting 
                        ? 'Connecting to PLC...'
                        : _plcService.isConnected
                            ? 'Connected to PLC at $_plcIpAddress'
                            : 'Connect to real hardware via PLC',
                    value: true,
                    groupValue: _isLiveMode,
                    onChanged: _isConnecting ? null : (value) => _handleModeChange(true),
                  ),
                  if (_isLiveMode) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'PLC IP Address',
                        hintText: '192.168.1.100',
                        prefixIcon: const Icon(Icons.settings_ethernet),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: _handleIpChange,
                          tooltip: 'Save IP address',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _handleIpChange(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DataStreamLogScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.list_alt),
                            label: const Text('View Data Stream Log'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            _plcService.isConnected ? Icons.link : Icons.link_off,
                            color: _plcService.isConnected ? Colors.green : Colors.red,
                          ),
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
                          tooltip: _plcService.isConnected
                              ? 'Disconnect from PLC'
                              : 'Connect to PLC',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionCard(
              title: 'Simulator',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Speed Scaling: ${_speedScaling.toStringAsFixed(1)}x',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: _speedScaling,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: '${_speedScaling.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() => _speedScaling = value);
                      simulator.setSpeedScaling(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Material Mix',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _MaterialSlider(
                    label: 'Steel',
                    value: _materialMix[PartMaterial.steel]!,
                    color: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _materialMix[PartMaterial.steel] = value;
                        _updateMaterialMix();
                      });
                      simulator.setMaterialMix({
                        PartMaterial.steel: value / 100,
                        PartMaterial.aluminium: _materialMix[PartMaterial.aluminium]! / 100,
                        PartMaterial.plastic: _materialMix[PartMaterial.plastic]! / 100,
                      });
                    },
                  ),
                  _MaterialSlider(
                    label: 'Aluminium',
                    value: _materialMix[PartMaterial.aluminium]!,
                    color: Colors.lightBlue,
                    onChanged: (value) {
                      setState(() {
                        _materialMix[PartMaterial.aluminium] = value;
                        _updateMaterialMix();
                      });
                      simulator.setMaterialMix({
                        PartMaterial.steel: _materialMix[PartMaterial.steel]! / 100,
                        PartMaterial.aluminium: value / 100,
                        PartMaterial.plastic: _materialMix[PartMaterial.plastic]! / 100,
                      });
                    },
                  ),
                  _MaterialSlider(
                    label: 'Plastic',
                    value: _materialMix[PartMaterial.plastic]!,
                    color: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        _materialMix[PartMaterial.plastic] = value;
                        _updateMaterialMix();
                      });
                      simulator.setMaterialMix({
                        PartMaterial.steel: _materialMix[PartMaterial.steel]! / 100,
                        PartMaterial.aluminium: _materialMix[PartMaterial.aluminium]! / 100,
                        PartMaterial.plastic: value / 100,
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionCard(
              title: 'Faults',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Random Faults'),
                    subtitle: const Text('Randomly inject faults during operation'),
                    value: _randomFaults,
                    onChanged: (value) {
                      setState(() => _randomFaults = value);
                      simulator.setRandomFaults(value);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Inject Fault',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _FaultButton(
                    label: 'E-Stop',
                    icon: Icons.emergency,
                    color: Colors.red,
                    onPressed: () {
                      simulator.injectFault(FaultType.eStop);
                      _showMessage('E-Stop fault injected');
                    },
                  ),
                  const SizedBox(height: 8),
                  _FaultButton(
                    label: 'Sensor Stuck',
                    icon: Icons.sensors_off,
                    color: Colors.orange,
                    onPressed: () {
                      simulator.injectFault(FaultType.sensorStuck);
                      _showMessage('Sensor stuck fault injected');
                    },
                  ),
                  const SizedBox(height: 8),
                  _FaultButton(
                    label: 'Paddle Jam',
                    icon: Icons.warning,
                    color: Colors.amber,
                    onPressed: () {
                      simulator.injectFault(FaultType.paddleJam);
                      _showMessage('Paddle jam fault injected');
                    },
                  ),
                  const SizedBox(height: 8),
                  _FaultButton(
                    label: 'Vacuum Leak',
                    icon: Icons.leak_add,
                    color: Colors.purple,
                    onPressed: () {
                      simulator.injectFault(FaultType.vacuumLeak);
                      _showMessage('Vacuum leak fault injected');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionCard(
              title: 'About',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Smart Factory Control App',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.5',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'A teaching and control companion for the Smart Factory training rig.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quick Help:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _HelpItem(
                    icon: Icons.home,
                    text: 'Home: View status and control the system',
                  ),
                  _HelpItem(
                    icon: Icons.play_arrow,
                    text: 'Run: Configure recipes and manual jog',
                  ),
                  _HelpItem(
                    icon: Icons.cable,
                    text: 'I/O: Monitor and control inputs/outputs',
                  ),
                  _HelpItem(
                    icon: Icons.assignment,
                    text: 'Worksheets: Complete guided learning activities',
                  ),
                  _HelpItem(
                    icon: Icons.analytics,
                    text: 'Analytics: View charts and export data',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMaterialMix() {
    final total = _materialMix.values.reduce((a, b) => a + b);
    if ((total - 100).abs() > 1) {
      // Auto-adjust to keep total at 100
      final factor = 100 / total;
      _materialMix.forEach((key, value) {
        _materialMix[key] = value * factor;
      });
    }
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

  const _SectionCard({required this.title, required this.child});

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?>? onChanged;

  const _RadioTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<bool>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}

class _MaterialSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _MaterialSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FaultButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _FaultButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HelpItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
