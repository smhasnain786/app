import 'package:ready_lms/model/course_detail.dart';

class ExamListModel {
  ExamListModel({
    required this.id,
    required this.userId,
    required this.examId,
    required this.progress,
    required this.examPrice,
    required this.discountAmount,
    required this.lastActivity,
    required this.isCertificateDownloaded,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.exam,
    // required this.total_duration,
  });

  late final int id;
  late final int userId;
  late final int examId;
  late final int progress;
  late final int examPrice;
  late final int discountAmount;
  late final String lastActivity;
  late final bool isCertificateDownloaded;
  late final String? deletedAt;
  late final String createdAt;
  late final String updatedAt;
  late final Exam exam;

  ExamListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    examId = json['exam_id'];
    progress = json['progress'];
    examPrice = json['exam_price'];
    discountAmount = json['discount_amount'];
    lastActivity = json['last_activity'];
    isCertificateDownloaded = json['is_certificate_downloaded'] == 1;
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    exam = Exam.fromJson(json['exam']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['exam_id'] = examId;
    data['progress'] = progress;
    data['exam_price'] = examPrice;
    data['discount_amount'] = discountAmount;
    data['last_activity'] = lastActivity;
    data['is_certificate_downloaded'] = isCertificateDownloaded ? 1 : 0;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['exam'] = exam.toJson();
    return data;
  }
}

class Exam {
  Exam({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.categoryId,
    required this.totalMarks,
    required this.totalDuration,
    required this.totalQuestions,
    required this.isPaid,
    required this.price,
    required this.active,
    required this.passingMarks,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String name;
  late final String slug;
  late final String description;
  late final int categoryId;
  late final String totalMarks;
  late final String totalDuration;
  late final String totalQuestions;
  late final bool isPaid;
  late final double price;
  late final bool active;
  late final double passingMarks;
  late final String createdAt;
  late final String updatedAt;

  Exam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    categoryId = json['category_id'];
    totalMarks = json['total_marks'];
    totalDuration = json['total_duration'];
    totalQuestions = json['total_questions'];
    isPaid = json['is_paid'] == 1;
    price = json['price'];
    active = json['active'] == 1;
    passingMarks = json['passing_marks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['total_marks'] = totalMarks;
    data['total_duration'] = totalDuration;
    data['total_questions'] = totalQuestions;
    data['is_paid'] = isPaid ? 1 : 0;
    data['price'] = price;
    data['active'] = active ? 1 : 0;
    data['passing_marks'] = passingMarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}