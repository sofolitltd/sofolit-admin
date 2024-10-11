import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool isCollapsed = false;
  bool isManuallyCollapsed = false; // New flag for manual collapse

  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": Icons.dashboard,
      "text": "Dashboard",
      "route": "/dashboard",
    },
    {
      "icon": Icons.school,
      "text": "Courses",
      "route": "/courses",
    },
    {
      "icon": Icons.payments,
      "text": "Orders",
      "route": "/orders",
    },
    {
      "icon": Icons.people_alt,
      "text": "Users",
      "route": "/users",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Check the screen width
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Automatically collapse sidebar if the screen width is less than 600
    if (screenWidth < 600 && !isManuallyCollapsed) {
      isCollapsed = true; // Auto-collapse for small screens
    } else if (screenWidth >= 600 && !isManuallyCollapsed) {
      isCollapsed = false; // Auto-expand for large screens
    }

    return Scaffold(
      body: Row(
        children: [
          // Collapsible Sidebar
          Container(
            width: isCollapsed ? 60 : 200,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.ac_unit,
                        size: 22,
                      ),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 8),
                        const Text(
                          'Sofol IT Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                //
                ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  shrinkWrap: true,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    String currentRoute = GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .fullPath;

                    bool isSelected = false;

                    // Exact match for the / route (Dashboard)
                    if (menuItems[index]["route"] == '/') {
                      isSelected = currentRoute == '/'; // Only match exactly /
                    }
                    // For sub routes, check if the current route starts with the base path
                    else {
                      isSelected =
                          currentRoute.startsWith(menuItems[index]["route"]) &&
                              currentRoute != '/'; // Ensure it's not exactly /
                    }

                    return GestureDetector(
                      onTap: () {
                        context.go(menuItems[index]["route"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              menuItems[index]["icon"],
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            if (!isCollapsed) ...[
                              const SizedBox(width: 8),
                              Text(
                                menuItems[index]["text"],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                const Spacer(),

                // Collapse Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isManuallyCollapsed = !isManuallyCollapsed;
                      isCollapsed = !isCollapsed;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(isCollapsed ? Icons.menu_open : Icons.menu),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 8),
                          Text(isCollapsed ? '' : 'Collapse'),
                        ]
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // log out
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isCollapsed ? 1 : 8,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      // Clear login state and navigate to login screen
                      // final prefs = await SharedPreferences.getInstance();
                      // await prefs
                      //     .clear(); // Clear all stored preferences (including 'isLoggedIn' and 'userName')

                      // Navigate to login screen
                      context.go('/login');
                    },
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 22,
                          ),
                        ),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Signout from app',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 24,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
