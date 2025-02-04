import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/my_exam_tab.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/exam_list.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/custom_dot.dart';
import 'package:ready_lms/components/rate_now_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyExamTabScreen extends ConsumerStatefulWidget {
  const MyExamTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyExamViewState();
}

class _MyExamViewState extends ConsumerState<MyExamTabScreen> {
  ScrollController scrollController = ScrollController();
  bool hasMoreData = true;
  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!ref.read(hiveStorageProvider).isGuest()) init(isRefresh: true);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (hasMoreData) init();
      }
    });
  }

  Future<void> init({bool isRefresh = false}) async {
    await ref
        .read(myExamTabController.notifier)
        .getMyEnrollExam(isRefresh: isRefresh, currentPage: currentPage)
        .then((value) {
      if (value.isSuccess) {
        if (value.response) {
          currentPage++;
        }
        hasMoreData = value.response;
        if (!hasMoreData) {
          setState(() {});
        }
      }
    });
  }

  Widget loginWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        30.ph,
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(S.of(context).loginForGetCourse,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).bodyTextSmall),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppButton(
            title: S.of(context).pleaseLogin,
            titleColor: context.color.surface,
            onTap: () {
              context.nav.pushNamed(Routes.authHomeScreen);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(myExamTabController).isLoading;
    List enrollCourseList =
        ref.watch(myExamTabController).enrollCourseList;
        
    return Scaffold(
        appBar:
            ApGlobalFunctions.cAppBar(header: Text(S.of(context).myExamsTab)),
        body: ref.read(hiveStorageProvider).isGuest()
            ? loginWidget()
            : RefreshIndicator(
                onRefresh: () async {
                  hasMoreData = true;
                  currentPage = 1;
                  init(isRefresh: true);
                },
                child: isLoading
                    ? const ShimmerWidget()
                    : !isLoading && enrollCourseList.isEmpty
                        ? ApGlobalFunctions.noItemFound(context: context)
                        : SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                16.ph,
                                ...List.generate(
                                    enrollCourseList.length,
                                    (index) => MyCourseCard(
                                          model: enrollCourseList[index],
                                          canReview: false,
                                          onTap: () {
                                            context.nav.pushNamed(
                                                Routes.myExamDetails,
                                                arguments:
                                                    enrollCourseList[index].exam.id);
                                          },
                                        ))
                              ],
                            ),
                          ),
              ));
  }
}

class MyCourseCard extends StatefulWidget {
  const MyCourseCard(
      {super.key,
      required this.onTap,
      required this.canReview,
      required this.model});
  final VoidCallback onTap;
  final ExamListModel model;
  final bool canReview;

  @override
  State<MyCourseCard> createState() => _MyCourseCardState();
}

class _MyCourseCardState extends State<MyCourseCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: AppComponents.defaultBorderRadiusSmall,
            color: context.color.surface),
        padding: EdgeInsets.all(
          16.h,
        ),
        margin: EdgeInsets.only(bottom: 12.h, left: 16.h, right: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.ph,
            Text(
              widget.model.exam.name,
              style: AppTextStyle(context).bodyTextSmall.copyWith(),
            ),
            8.ph,
            Row(
              children: [
                Container(
                  width: 16.h,
                  height: 16.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                ),
                6.pw,
             
                12.pw,
                const CustomDot(),
                12.pw,
                Text(
                  '${(widget.model.progress)} Mins',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 12.sp, color: context.color.inverseSurface),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/svg/ic_right_arrow.svg',
                  color: colors(context).hintTextColor,
                  width: 16.h,
                  height: 16.h,
                )
              ],
            ),
            if (widget.canReview)
              Consumer(builder: (context, ref, _) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0.h),
                  child: RateNowCard(
                    textColor: colors(context).titleTextColor,
                    backgroundColor: colors(context).scaffoldBackgroundColor,
                    courseId: widget.model.id,
                    onReviewed: (data) {
                      ref
                          .read(myExamTabController.notifier)
                          .updateListForReview(
                              courseId: widget.model.id, data: data);
                    },
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
