import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'course_datatable.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              const Text(
                'Courses',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              //
              OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).go('/courses/add-course');
                },
                child: const Text('Add Course'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Replace the horizontal list with the data table
        const CourseDataTable(),
      ],
    );
  }
}
