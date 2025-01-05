import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/exam_list.dart';
import 'package:ready_lms/model/exam_details.dart';
import 'package:ready_lms/service/exam_service.dart';

class MyExamDetailsController extends StateNotifier<MyExamDetails> {
  final Ref ref;

  MyExamDetailsController(super.state, this.ref);

  Future<void> getExamDetails(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref
          .read(examServiceProvider)
          .examDetailByID(id: id);
      state = state.copyWith(isLoading: false);

      if (response.statusCode == 200) {
        var data = ExamDetailModel.fromJson(response.data['data']);

        // Extract the `Exam` object
        state = state.copyWith(
          exam: data.exam,
          isLoading: false,
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

    void disposeController() {
    // Perform cleanup if necessary
    state = MyExamDetails(); // Reset to default state
    debugPrint("Controller disposed and state reset");
  }
}


class MyExamDetails {
  bool isLoading;
  String? name, errorMessage;
  Exams? exam; // Updated from List? exma to Exam?

  MyExamDetails({
    this.isLoading = false,
    this.name,
    this.errorMessage,
    this.exam,
  });

  MyExamDetails copyWith({
    bool? isLoading,
    String? name,
    String? errorMessage,
    Exams? exam,
  }) {
    return MyExamDetails(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      errorMessage: errorMessage ?? this.errorMessage,
      exam: exam ?? this.exam,
    );
  }
}


final myExamDetailsController =
    StateNotifierProvider.autoDispose<MyExamDetailsController, MyExamDetails>(
        (ref) => MyExamDetailsController(
              MyExamDetails(isLoading: false),
              ref,
            ));
