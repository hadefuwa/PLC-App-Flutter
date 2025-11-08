import 'package:flutter/material.dart';
import 'plc_io_screen.dart';
import 'plc_settings_screen.dart';

class PLCMain extends StatefulWidget {
  const PLCMain({super.key});

  @override
  State<PLCMain> createState() => _PLCMainState();
}

class _PLCMainState extends State<PLCMain> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const PLCIOScreen(),
    const PLCSettingsScreen(),
  ];

  static final List<String> _titles = [
    'S7 PLC Companion',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F0F1E),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white.withValues(alpha: 0.6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cable),
            label: 'I/O',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
