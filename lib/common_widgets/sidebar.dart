import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatefulWidget {
  final Function(String route) onItemSelected;

  const Sidebar({super.key, required this.onItemSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool isExpanded = true;
  static const double expandedWidth = 280;
  static const double collapsedWidth = 64;
  late AnimationController _controller;
  late Animation<double> widthAnim;

  /// Sidebar items with children
  final List<_SidebarItem> items = [
    _SidebarItem(
      Icons.admin_panel_settings,
      "Roles",
      "/roles",
      children: [
        _SidebarSubItem("Roles", "/roles/add"),
        _SidebarSubItem("All New", "/roles/list"),
      ],
    ),
    _SidebarItem(
      Icons.group,
      "Users",
      "/users",
      children: [
        _SidebarSubItem("User", "/users/list"),
        _SidebarSubItem("Add New", "/users/add"),
      ],
    ),
    _SidebarItem(
      Icons.business,
      "Vendors",
      "/vendors",
      children: [
        _SidebarSubItem(" List", "/vendors/list"),
        _SidebarSubItem("Add Vendors", "/vendors/add"),
      ],
    ),
    _SidebarItem(
      Icons.access_time,
      "Activity",
      "/activity",
      children: [
        _SidebarSubItem("Activity Logs", "/activity/logs"),
        _SidebarSubItem("Login History", "/activity/login-history"),
      ],
    ),
    // _SidebarItem(
    //   Icons.request_page,
    //   "Expense Approval",
    //   "/expense-approval",
    //   children: [
    //     _SidebarSubItem("Create Note", "/expense-approval/create"),
    //     _SidebarSubItem("All Notes", "/expense-approval/list"),
    //     _SidebarSubItem("Approval Rules", "/expense-approval/rules"),
    //   ],
    // ),
    _SidebarItem(
      Icons.payment,
      "Payment Notes",
      "/payment-notes",
      children: [
        _SidebarSubItem("All Payment Notes", "/payment-notes/list"),
        _SidebarSubItem("Approval Rules", "/payment-notes/rules"),
      ],
    ),
    // _SidebarItem(
    //   Icons.card_travel,
    //   "Travel Reimbursement",
    //   "/travel",
    //   children: [
    //     _SidebarSubItem("Create", "/travel/create"),
    //     _SidebarSubItem("Create For All", "/travel/create-all"),
    //     _SidebarSubItem("All Notes", "/travel/list"),
    //   ],
    // ),
    // _SidebarItem(
    //   Icons.account_balance,
    //   "Bank RTGS/NEFT",
    //   "/bank",
    //   children: [
    //     _SidebarSubItem("List", "/bank/list"),
    //     _SidebarSubItem("Create", "/bank/create"),
    //     _SidebarSubItem("Bank Letter Rules", "/bank/rules"),
    //     _SidebarSubItem("Ratio Create", "/bank/ratio"),
    //   ],
    // ),
    _SidebarItem(
      Icons.work,
      "Designation",
      "/designation",
      children: [
        _SidebarSubItem("Create", "/designation/create"),
        _SidebarSubItem("All Designations", "/designation/list"),
      ],
    ),
    _SidebarItem(
      Icons.apartment,
      "Department",
      "/department",
      children: [
        _SidebarSubItem("Create", "/department/create"),
        _SidebarSubItem("All Departments", "/department/list"),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    widthAnim = Tween<double>(
      begin: expandedWidth,
      end: collapsedWidth,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleSidebar() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Keeps track of which menu is expanded
  final Set<int> expandedMenus = {};

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final currentLocation = GoRouterState.of(context).uri.toString();

    // Replace part of build method rendering Sidebar’s main container:
    return AnimatedBuilder(
      animation: widthAnim,
      builder: (context, child) {
        return Material(
          elevation: 4,
          color: colors.surface,
          child: Container(
            width: widthAnim.value,
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline, width: 0.25),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isExpanded
                              ? Icons.arrow_back_ios_new_rounded
                              : Icons.menu,
                          color: colors.onSurface,
                          size: 22,
                        ),
                        onPressed: toggleSidebar,
                        splashRadius: 22,
                      ),
                      if (isExpanded) const SizedBox(width: 10),
                      if (isExpanded)
                        Flexible(
                          child: Text(
                            "NHIT",
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final item = items[idx];
                      final isMenuExpanded = expandedMenus.contains(idx);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SidebarTile(
                            icon: item.icon,
                            label: item.label,
                            route: item.route,
                            collapsed: !isExpanded,
                            isActive: currentLocation.startsWith(item.route),
                            onTap: () {
                              if (item.children.isNotEmpty) {
                                setState(() {
                                  if (isMenuExpanded) {
                                    expandedMenus.remove(idx);
                                  } else {
                                    expandedMenus.add(idx);
                                  }
                                });
                              } else {
                                widget.onItemSelected(item.route);
                                context.go(item.route);
                              }
                            },
                            showExpandIcon: item.children.isNotEmpty,
                            expanded: isMenuExpanded,
                          ),
                          if (isExpanded && isMenuExpanded)
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.children
                                    .map(
                                      (sub) => ListTile(
                                        dense: true,
                                        title: Text(
                                          sub.label,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                currentLocation.startsWith(
                                                  sub.route,
                                                )
                                                ? colors.primary
                                                : colors.onSurface,
                                          ),
                                        ),
                                        onTap: () {
                                          widget.onItemSelected(sub.route);
                                          context.go(sub.route);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  final String route;
  final List<_SidebarSubItem> children;

  _SidebarItem(this.icon, this.label, this.route, {this.children = const []});
}

class _SidebarSubItem {
  final String label;
  final String route;

  _SidebarSubItem(this.label, this.route);
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool collapsed;
  final bool isActive;
  final VoidCallback onTap;
  final bool showExpandIcon;
  final bool expanded;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.route,
    required this.collapsed,
    required this.isActive,
    required this.onTap,
    this.showExpandIcon = false,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: isActive ? colors.surfaceVariant : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 10 : 18,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? colors.primary : colors.onSurface,
                size: 22,
              ),
              if (!collapsed) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? colors.primary : colors.onSurface,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showExpandIcon)
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
