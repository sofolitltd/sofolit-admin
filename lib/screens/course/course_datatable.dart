import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../db/controllers/course_controller.dart';

class CourseDataTable extends StatelessWidget {
  const CourseDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController courseController =
        Get.put(CourseController()); // Get the controller instance

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        // Use Obx to listen for changes
        if (courseController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (courseController.courses.isEmpty) {
          return const Center(child: Text('No courses available'));
        }

        return Expanded(
          child: Scrollbar(
            interactive: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    border: TableBorder.all(),
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Slug')),
                      DataColumn(label: Text('Batch')),
                      DataColumn(label: Text('Seats')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Enroll Start')),
                      DataColumn(label: Text('Enroll End')),
                      DataColumn(label: Text('Class Start Date')),
                      DataColumn(label: Text('Active')),
                      DataColumn(label: Text('Actions')), // Column for actions
                    ],
                    rows: courseController.courses.map((course) {
                      return DataRow(
                        cells: [
                          DataCell(Text(course.title)),
                          DataCell(Text(course.slug)),
                          DataCell(Text(course.batch)),
                          DataCell(Text('${course.seats}')),
                          DataCell(Text('৳ ${course.price}')),
                          DataCell(Text('${course.discount}%')),
                          DataCell(Text(course.enrollStart
                              .toLocal()
                              .toString()
                              .split(' ')[0])),
                          DataCell(Text(course.enrollEnd
                              .toLocal()
                              .toString()
                              .split(' ')[0])),
                          DataCell(Text(course.classStartDate
                              .toLocal()
                              .toString()
                              .split(' ')[0])),
                          DataCell(Icon(
                              course.active ? Icons.check : Icons.close,
                              color:
                                  course.active ? Colors.green : Colors.red)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit functionality
                                  context.go(
                                    '/courses/edit-course/${course.courseID}', // Include the courseID in the URL
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Implement delete functionality
                                  showDeleteConfirmationDialog(
                                    context,
                                    course.courseID!,
                                    courseController,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {
                                  final String url =
                                      'https://sofolit.web.app/courses/${course.slug}'; // Create the URL
                                  Share.share(
                                      'Check out this course: $url'); // Share the URL with a message
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

//

void showDeleteConfirmationDialog(
    BuildContext context, String courseID, CourseController courseController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // Implement delete functionality
              courseController.deleteCourse(courseID);
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
