import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/breadcrumb_item.dart';

class Navbar extends StatelessWidget {
  final String? currentLocation;
  final String userName;
  final String? avatarUrl;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const Navbar({
    super.key,
    this.currentLocation,
    required this.userName,
    this.avatarUrl,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          // breadcrumbs
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 14),
                Breadcrumbs(
                  currentLocation: currentLocation,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // right side button
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: onToggleTheme,
                tooltip: isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
              ),

              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {}, // Notification action
                tooltip: "Notifications",
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primary,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Text(
                  userName
                      .split(" ")
                      .map((e) => e.isNotEmpty ? e[0] : '')
                      .join()
                      .toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
