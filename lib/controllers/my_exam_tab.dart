import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/exam_list.dart';
import 'package:ready_lms/service/exam_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyExamTabController extends StateNotifier<Exam> {
  final Ref ref;
  MyExamTabController(super.state, this.ref);

  Future<CommonResponse> getMyEnrollExam(
      {bool isRefresh = false,
      required int currentPage,
      int parPage = 10}) async {
    if (isRefresh) {
      state.isLoading = true;
      state.enrollCourseList.clear();
      state = state._update(state);
    }

    bool isSuccess = false;
    bool hasData = false;
    try {
      final response = await ref
          .read(examServiceProvider)
          .enrolledExams(currentPage: currentPage, parPage: parPage);

      if (response.statusCode == 200) {
        isSuccess = true;
        List<dynamic> responseList = response.data['data']['exams'];
        List list =
            responseList.map((data) => ExamListModel.fromJson(data)).toList();

        if (list.isNotEmpty) {
          state.enrollCourseList.addAll(list);
          hasData = true;
        }
        state = state._update(state);
      }

      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: hasData);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(
          isSuccess: isSuccess, message: error.toString(), response: hasData);
    } finally {
      if (mounted) state = state.copyWith(isLoading: false);
    }
  }

  getMyCourseDetails(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final response =
          await ref.read(examServiceProvider).examDetailByID(id: id);
      state = state.copyWith(isLoading: false);

      if (response.statusCode == 200) {
        var data = CourseDetailModel.fromJson(response.data['data']);

        state = state.copyWith(
          isLoading: false,
          enrollCourseList: state.enrollCourseList,
          );
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state.isLoading = false;
      state = state._update(state);
    }
  }

  updateListForReview({required int courseId, required SubmittedReview data}) {
    if (state.enrollCourseList.map((e) => e.id).contains(courseId)) {
      final updatedList = [...state.enrollCourseList];
      int index = updatedList.indexWhere((element) => element.id == courseId);
      updatedList[index].canReview = false;
      updatedList[index].submittedReview = data;
      state = state.copyWith(enrollCourseList: updatedList);
    }
  }
}

class Exam {
  bool isLoading;
  List enrollCourseList;
  Exam({
    this.isLoading = false,
    required this.enrollCourseList,
  });

  Exam copyWith({
    isLoading,
    enrollCourseList,
  }) {
    return Exam(
      isLoading: isLoading ?? this.isLoading,
      enrollCourseList: enrollCourseList ?? this.enrollCourseList,
    );
  }

  Exam _update(Exam state) {
    return Exam(
      isLoading: state.isLoading,
      enrollCourseList: state.enrollCourseList,
    );
  }
}

final myExamTabController =
    StateNotifierProvider.autoDispose<MyExamTabController, Exam>(
        (ref) => MyExamTabController(Exam(enrollCourseList: []), ref));
