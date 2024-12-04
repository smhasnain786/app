import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/course_shorts_info.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/courses/new_course/widget/video.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key, required this.model});
  final CourseDetailModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              model.course.video == null
                  ? AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: FadeInImage.assetNetwork(
                        placeholderFit: BoxFit.contain,
                        placeholder: 'assets/images/spinner.gif',
                        image: model.course.thumbnail,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error,
                              color: context.color.primary);
                        },
                      ),
                    )
                  : const VideoCard(),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.course.title,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                16.ph,
                CourseShortsInfo(
                    totalTime:
                        (model.course.totalDuration / 60).toStringAsFixed(0),
                    totalEnrolled: '${model.course.studentCount}',
                    rating: double.tryParse('${model.course.averageRating}')!
                        .toStringAsFixed(1)
                        .toString(),
                    totalRating: '(${model.course.reviewCount})'),
                16.ph,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CourseContaintInfoCard(
                          text:
                              '${model.course.videoCount} ${S.of(context).video}'),
                      CourseContaintInfoCard(
                          text: S.of(context).lifetimeAccess),
                      CourseContaintInfoCard(
                          text:
                              '${model.course.audioCount} ${S.of(context).audioBook}'),
                      CourseContaintInfoCard(
                          text:
                              '${model.course.noteCount} ${S.of(context).notes}'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CourseContaintInfoCard extends StatelessWidget {
  const CourseContaintInfoCard({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.h),
          color: colors(context).scaffoldBackgroundColor),
      child: Text(
        text,
        style: AppTextStyle(context).bodyTextSmall.copyWith(fontSize: 10.sp),
      ),
    );
  }
}
