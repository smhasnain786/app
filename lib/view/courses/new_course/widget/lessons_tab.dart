import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LessonsTab extends ConsumerWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //  List<Chapters> ref.read(courseController).courseDetails.chapters;
    return SingleChildScrollView(
      child: Column(
        children: [
          24.ph,
          ...List.generate(
              ref.read(courseController).courseDetails!.chapters.length,
              (index) => LessonCard(
                    model: ref
                        .read(courseController)
                        .courseDetails!
                        .chapters[index],
                    index: index,
                  )),
          20.ph
        ],
      ),
    );
  }
}

class LessonCard extends ConsumerStatefulWidget {
  const LessonCard({super.key, required this.model, required this.index});
  final Chapters model;
  final int index;

  @override
  ConsumerState<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<LessonCard> {
  final isExpand = StateProvider<bool>((ref) {
    return false;
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall,
          border: Border.all(
              color: ref.watch(isExpand)
                  ? colors(context).primaryColor!.withOpacity(0.4)
                  : Colors.transparent)),
      child: Column(
        children: [
          12.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/ic_lock.svg',
                  width: 12.h,
                  height: 12.h,
                  color: context.color.onSurface,
                ),
                8.pw,
                Text(
                  '${S.of(context).cClass} ${widget.index + 1}',
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontSize: 10.sp),
                ),
                const Spacer(),
                Text(
                  ApGlobalFunctions.toHourMinute(
                      time: widget.model.totalDuration, context: context),
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 10.sp, color: colors(context).hintTextColor),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
                onExpansionChanged: (value) =>
                    ref.watch(isExpand.notifier).state = value,
                iconColor: colors(context).hintTextColor,
                collapsedIconColor: colors(context).hintTextColor,
                title: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.model.title,
                              style: AppTextStyle(context)
                                  .bodyText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                tilePadding: EdgeInsets.only(right: 12.h),
                children: [
                  ...List.generate(
                      widget.model.contents.length,
                      (index) => LessonItemCard(
                            isBottom: index == widget.model.contents.length - 1
                                ? true
                                : false,
                            model: widget.model.contents[index],
                          )),
                  12.ph
                ]),
          ),
        ],
      ),
    );
  }
}

class LessonItemCard extends ConsumerWidget {
  const LessonItemCard({
    super.key,
    this.isBottom = false,
    required this.model,
  });
  final bool? isBottom;
  final Contents model;

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        if (ref.read(courseController).courseDetails!.course.isEnrolled) {
          EasyLoading.showInfo(S.of(context).backToCourseDec);
        } else {
          enrolNowDialog(context: context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: isBottom! ? 0 : 8.h),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: isBottom!
                      ? BorderSide.none
                      : BorderSide(
                          color: colors(context).hintTextColor!.withOpacity(.2),
                        ))),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: isBottom! ? 0 : 8.h, left: 12.h, right: 12.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    color: colors(context).hintTextColor!.withOpacity(.1),
                  ),
                  padding: EdgeInsets.all(6.h),
                  child: SvgPicture.asset(
                    ApGlobalFunctions.getFileIcon(model.type),
                    height: 16.h,
                    width: 16.h,
                    color: context.color.inverseSurface,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Text(
                    model.title,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 12.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  enrolNowDialog({
    required BuildContext context,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).enrolDes,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyText.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              20.ph,
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: AppOutlineButton(
                        title: S.of(context).cancel,
                        width: double.infinity,
                        buttonColor: context.color.surface,
                        titleColor: AppStaticColor.redColor,
                        textPaddingVertical: 16.h,
                        borderRadius: 12.r,
                        onTap: () => context.nav.pop(),
                      )),
                      12.pw,
                      Expanded(child: Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: S.of(context).enrolNow,
                          width: double.infinity,
                          titleColor: context.color.surface,
                          textPaddingVertical: 16.h,
                          onTap: () async {
                            context.nav.pop();
                            context.nav.pushNamed(Routes.checkOutScreen,
                                arguments: ref
                                    .read(courseController)
                                    .courseDetails!
                                    .course
                                    .id);
                          },
                        );
                      })),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
