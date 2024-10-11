import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '/screens/orders_screen.dart';
import '/screens/users_screen.dart';
import 'screens/course/course_add.dart';
import 'screens/course/course_edit.dart';
import 'screens/course/course_screen.dart';
import 'screens/dashboard_layout.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

bool isAdminLoggedIn = false;

// AppRouter configuration
final GoRouter goRouter = GoRouter(
  // routerNeglect: true,
  initialLocation: '/dashboard',
  routes: [
    // Admin routes with ShellRoute
    ShellRoute(
      builder: (context, state, child) {
        return DashboardLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Dashboard(),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const Login(), // Admin login
            ),
            GoRoute(
              path: 'dashboard',
              pageBuilder: (context, state) {
                getTitle(context, 'Dashboard | Sofol IT Admin');
                return const NoTransitionPage(child: Dashboard());
              },
            ),
            GoRoute(
                path: 'courses',
                pageBuilder: (context, state) {
                  getTitle(context, 'Courses | Sofol IT Admin');
                  return const NoTransitionPage(child: CourseScreen());
                },
                routes: [
                  //add
                  GoRoute(
                    path: 'add-course',
                    pageBuilder: (context, state) {
                      getTitle(context, 'Add Course | Sofol IT Admin');
                      return NoTransitionPage(child: AddCourse());
                    },
                  ),

                  //edit
                  GoRoute(
                    path: 'edit-course/:courseID',
                    pageBuilder: (context, state) {
                      getTitle(context, 'Edit Course | Sofol IT Admin');
                      final String courseID = state.pathParameters['courseID']!;
                      return NoTransitionPage(
                          child: EditCourse(courseID: courseID));
                    },
                  ),
                ]),
            GoRoute(
              path: 'orders',
              pageBuilder: (context, state) {
                getTitle(context, 'Orders | Sofol IT Admin');

                return const NoTransitionPage(child: Orders());
              },
            ),
            GoRoute(
              path: 'users',
              pageBuilder: (context, state) {
                getTitle(context, 'Users | Sofol IT Admin');

                return const NoTransitionPage(child: Users());
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

// Function to set application title in app switcher
getTitle(BuildContext context, String title) {
  return SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
    label: title,
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}
