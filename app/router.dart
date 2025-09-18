import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhit_frontend/app/layout.dart';
import 'package:nhit_frontend/features/activity/screens/activity_logs_page.dart';
import 'package:nhit_frontend/features/roles/screens/role_list_page.dart';

import '../features/roles/data/role_list.dart';

/// Placeholder page for routes not yet implemented
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/roles/add',
  routes: [
    ShellRoute(
      builder: (context, state, child) => LayoutPage(child: child),
      routes: [
        /// ---------------- ACTIVITY ----------------
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityPage(),
          routes: [
            GoRoute(
              path: 'logs',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Activity Logs'),
            ),
            GoRoute(
              path: 'login-history',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Login History'),
            ),
          ],
        ),

        /// ---------------- ROLES ----------------
        GoRoute(
          path: '/roles',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Roles Home'),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) =>
                  RoleListTable(roleData: roleData),
            ),

            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Roles'),
            ),
          ],
        ),

        /// ---------------- USERS ----------------
        GoRoute(
          path: '/users',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Users Home'),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Add User'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Users'),
            ),
          ],
        ),

        /// ---------------- VENDORS ----------------
        GoRoute(
          path: '/vendors',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Vendors Home'),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Add Vendor'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Vendor List'),
            ),
          ],
        ),

        /// ---------------- EXPENSE APPROVAL ----------------
        GoRoute(
          path: '/expense-approval',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Expense Approval Home'),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Expense Note'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Expense Notes'),
            ),
            GoRoute(
              path: 'rules',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Expense Approval Rules'),
            ),
          ],
        ),

        /// ---------------- PAYMENT NOTES ----------------
        GoRoute(
          path: '/payment-notes',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Payment Notes Home'),
          routes: [
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Payment Notes'),
            ),
            GoRoute(
              path: 'rules',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Payment Approval Rules'),
            ),
          ],
        ),

        /// ---------------- TRAVEL REIMBURSEMENT ----------------
        GoRoute(
          path: '/travel',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Travel Reimbursement Home'),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Travel Note'),
            ),
            GoRoute(
              path: 'create-all',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Travel for All Users'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Travel Notes'),
            ),
          ],
        ),

        /// ---------------- BANK ----------------
        GoRoute(
          path: '/bank',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Bank RTGS/NEFT Home'),
          routes: [
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Bank List'),
            ),
            GoRoute(
              path: 'create',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Bank Entry'),
            ),
            GoRoute(
              path: 'rules',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Bank Letter Rules'),
            ),
            GoRoute(
              path: 'ratio',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Bank Ratio Create'),
            ),
          ],
        ),

        /// ---------------- DESIGNATION ----------------
        GoRoute(
          path: '/designation',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Designation Home'),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Designation'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Designations'),
            ),
          ],
        ),

        /// ---------------- DEPARTMENT ----------------
        GoRoute(
          path: '/department',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Department Home'),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) =>
              const PlaceholderPage(title: 'Create Department'),
            ),
            GoRoute(
              path: 'list',
              builder: (context, state) =>
              const PlaceholderPage(title: 'All Departments'),
            ),
          ],
        ),
      ],
    ),
  ],
);
