import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Common Breadcrumbs Widget
/// Use inside AppBar or below it to show navigation path
class Breadcrumbs extends StatelessWidget {
  final String? currentLocation;
  final TextStyle? textStyle;

  const Breadcrumbs({super.key, this.currentLocation, this.textStyle});

  List<_Breadcrumb> _generateBreadcrumbs(BuildContext context) {
    final location =
        currentLocation ??
            GoRouterState.of(context).uri.toString().split('?')[0];

    final segments = location.split('/').where((s) => s.isNotEmpty).toList();

    List<_Breadcrumb> crumbs = [];
    String path = '';

    String normalizePath(String inputPath) {
      final segs = inputPath.split('/');
      if (segs.length > 2) {
        if (segs[1] == 'finance') {
          if (segs[2] == 'invoices') return '/finance/invoices';
          if (segs[2] == 'expense') return '/finance/expense';
        }
      }
      return inputPath;
    }

    for (var i = 0; i < segments.length; i++) {
      path += "/${segments[i]}";
      final normalizedPath = normalizePath(path);
      crumbs.add(
        _Breadcrumb(
          title: routeLabels[normalizedPath] ??
              segments[i][0].toUpperCase() + segments[i].substring(1),
          href: normalizedPath,
        ),
      );
    }

    if (crumbs.isEmpty) {
      crumbs.add(_Breadcrumb(title: "Dashboard", href: "/dashboard"));
    }

    return crumbs;
  }

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = _generateBreadcrumbs(context);

    final defaultLinkStyle = textStyle ??
        TextStyle(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
        );

    final defaultActiveStyle = textStyle?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ) ??
        TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: List.generate(breadcrumbs.length, (index) {
        final crumb = breadcrumbs[index];
        final isLast = index == breadcrumbs.length - 1;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isLast)
              InkWell(
                onTap: () => context.go(crumb.href),
                child: Text(crumb.title, style: defaultLinkStyle),
              )
            else
              Text(crumb.title, style: defaultActiveStyle),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _Breadcrumb {
  final String title;
  final String href;

  _Breadcrumb({required this.title, required this.href});
}

/// ✅ Define all route labels based on NHIT folder structure
const Map<String, String> routeLabels = {
  '/dashboard': 'Dashboard',
  '/roles': 'Roles',
  '/users': 'Users',
  '/vendors': 'Vendors',
  '/activity': 'Activity',
  '/expense ': 'Expense Approval Form',
  '/payment': 'Payment',
  '/travel': 'Travel Reimbursement',
  '/bank': 'Bank RTGS/NEFT',
  '/designation': 'Designation',
  '/department': 'Departments',
};
