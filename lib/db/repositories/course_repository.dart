import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course_model.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  // Fetch all courses
  Future<List<Course>> getCourses() async {
    try {
      QuerySnapshot snapshot = await coursesCollection.get();
      return snapshot.docs.map((doc) => Course.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load courses');
    }
  }

  // Fetch a course by ID
  Future<Course?> getCourseById(String courseID) async {
    try {
      DocumentSnapshot doc = await coursesCollection.doc(courseID).get();
      if (doc.exists) {
        return Course.fromJson(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load course');
    }
  }

  // Add a new course
  Future<void> addCourse(Course course) async {
    try {
      await coursesCollection.doc(course.courseID).set(course.toJson());
    } catch (e) {
      throw Exception('Failed to add course');
    }
  }

  // Update a course
  Future<void> updateCourse(Course course) async {
    try {
      await coursesCollection.doc(course.courseID).update(course.toJson());
    } catch (e) {
      throw Exception('Failed to update course');
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseID) async {
    try {
      await coursesCollection.doc(courseID).delete();
    } catch (e) {
      throw Exception('Failed to delete course');
    }
  }
}
