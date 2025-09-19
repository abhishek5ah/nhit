import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/navbar.dart';
import 'package:nhit_frontend/common_widgets/sidebar.dart';

class LayoutPage extends StatefulWidget {
  final Widget child;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LayoutPage({
    super.key,
    required this.child,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  String currentRoute = "/activity";

  void _onItemSelected(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onItemSelected: (route) {
              _onItemSelected(route);
            },
          ),

          // Main content takes remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Navbar(
                  userName: 'Abhishek',
                  currentLocation: currentRoute,
                  isDarkMode: widget.isDarkMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.child,
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
