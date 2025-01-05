import 'dart:convert';


class ExamDetailModel {
  final Exams exam;

  ExamDetailModel({required this.exam});

  factory ExamDetailModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailModel(
      exam: Exams.fromJson(json['exam']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam': exam.toJson(),
    };
  }
}

class Exams {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int categoryId;
  final String totalMarks;
  final String totalDuration;
  final String totalQuestions;
  final bool isPaid;
  final double price;
  final bool active;
  final double passingMarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exams({
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

  factory Exams.fromJson(Map<String, dynamic> json) {
    return Exams(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      categoryId: json['category_id'],
      totalMarks: json['total_marks'],
      totalDuration: json['total_duration'],
      totalQuestions: json['total_questions'],
      isPaid: json['is_paid'] == 1,
      price: (json['price'] as num).toDouble(),
      active: json['active'] == 1,
      passingMarks: (json['passing_marks'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'category_id': categoryId,
      'total_marks': totalMarks,
      'total_duration': totalDuration,
      'total_questions': totalQuestions,
      'is_paid': isPaid ? 1 : 0,
      'price': price,
      'active': active ? 1 : 0,
      'passing_marks': passingMarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}