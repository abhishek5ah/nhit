import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhit_frontend/app/layout.dart';
import 'package:nhit_frontend/app/theme_notifier.dart';
import 'package:nhit_frontend/features/activity/data/activity_log.dart';
import 'package:nhit_frontend/features/activity/data/user_login_history.dart';
import 'package:nhit_frontend/features/activity/screens/activity_logs_page.dart';
import 'package:nhit_frontend/features/activity/screens/login_history_page.dart';
import 'package:nhit_frontend/features/department/data/department_dart.dart';
import 'package:nhit_frontend/features/department/screens/department_list_page.dart';
import 'package:nhit_frontend/features/designation/data/designation_modal.dart';
import 'package:nhit_frontend/features/designation/screens/designation_list_page.dart';
import 'package:nhit_frontend/features/payment_notes/data/approval_rule.dart';
import 'package:nhit_frontend/features/payment_notes/data/payment_note.dart';
import 'package:nhit_frontend/features/payment_notes/screens/approval_rules_page.dart';
import 'package:nhit_frontend/features/payment_notes/screens/payment_notes_list_page.dart';
import 'package:nhit_frontend/features/roles/data/role_list.dart';
import 'package:nhit_frontend/features/roles/screens/role_list_page.dart';
import 'package:nhit_frontend/features/users/data/user_list.dart';
import 'package:nhit_frontend/features/users/screens/add_user_page.dart';
import 'package:nhit_frontend/features/users/screens/user_list_page.dart';
import 'package:nhit_frontend/features/vendors/screens/add_vendor_page.dart';
import 'package:nhit_frontend/features/vendors/screens/vendor_list_page.dart';

import '../features/vendors/data/vendor_list.dart';


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
  initialLocation: '/designation/list',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, themeMode, _) {
            return LayoutPage(
              isDarkMode: themeMode == ThemeMode.dark,
              onToggleTheme: toggleTheme,
              child: child,
            );
          }
      ),
      routes: [
        /// ---------------- ACTIVITY ----------------
        GoRoute(
          path: '/activity',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Activity Pages'),
          routes: [
            GoRoute(
              path: 'logs',
              builder: (context, state) =>
                  ActivityLogTable(activityLogs: activityLogs)
            ),
            GoRoute(
              path: 'login-history',
              builder: (context, state) =>
                  UserLoginHistoryTable(loginHistoryData: userLoginHistoryData)
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
              path: 'list',
              builder: (context, state) =>
                UserListTable(userData: userData),
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) =>
               AddUserPage(),
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
              path: 'list',
              builder: (context, state) =>
                  VendorListTable(vendorData: vendorData),
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) =>
              const AddVendorPage(),
            ),

          ],
        ),

        /// ---------------- EXPENSE APPROVAL ----------------
        // GoRoute(
        //   path: '/expense-approval',
        //   builder: (context, state) =>
        //   const PlaceholderPage(title: 'Expense Approval Home'),
        //   routes: [
        //     GoRoute(
        //       path: 'create',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Create Expense Note'),
        //     ),
        //     GoRoute(
        //       path: 'list',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'All Expense Notes'),
        //     ),
        //     GoRoute(
        //       path: 'rules',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Expense Approval Rules'),
        //     ),
        //   ],
        // ),

        /// ---------------- PAYMENT NOTES ----------------
        GoRoute(
          path: '/payment-notes',
          builder: (context, state) =>
          const PlaceholderPage(title: 'Payment Notes Home'),
          routes: [
            GoRoute(
              path: 'list',
              builder: (context, state) =>
                  PaymentNotesTable(paymentNotes: paymentNoteData)
            ),
            GoRoute(
              path: 'rules',
              builder: (context, state) =>
                  ApprovalRulesTable(approvalRuleData: approvalRuleData)
            ),
          ],
        ),

        /// ---------------- TRAVEL REIMBURSEMENT ----------------
        // GoRoute(
        //   path: '/travel',
        //   builder: (context, state) =>
        //   const PlaceholderPage(title: 'Travel Reimbursement Home'),
        //   routes: [
        //     GoRoute(
        //       path: 'create',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Create Travel Note'),
        //     ),
        //     GoRoute(
        //       path: 'create-all',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Create Travel for All Users'),
        //     ),
        //     GoRoute(
        //       path: 'list',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'All Travel Notes'),
        //     ),
        //   ],
        // ),

        /// ---------------- BANK ----------------
        // GoRoute(
        //   path: '/bank',
        //   builder: (context, state) =>
        //   const PlaceholderPage(title: 'Bank RTGS/NEFT Home'),
        //   routes: [
        //     GoRoute(
        //       path: 'list',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Bank List'),
        //     ),
        //     GoRoute(
        //       path: 'create',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Create Bank Entry'),
        //     ),
        //     GoRoute(
        //       path: 'rules',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Bank Letter Rules'),
        //     ),
        //     GoRoute(
        //       path: 'ratio',
        //       builder: (context, state) =>
        //       const PlaceholderPage(title: 'Bank Ratio Create'),
        //     ),
        //   ],
        // ),

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
                  DesignationTable(designationData: designationData),
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
                  DepartmentTable(departmentData: departmentData)
            ),
          ],
        ),
      ],
    ),
  ],
);
