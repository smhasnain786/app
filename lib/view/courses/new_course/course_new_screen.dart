import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/custom_header_appbar.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/controllers/favourites_tab.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/courses/new_course/widget/couse_details.dart';

import 'widget/about_tab.dart';
import 'widget/lessons_tab.dart';
import 'widget/reviews_tab.dart';

class CourseNewScreen extends ConsumerStatefulWidget {
  const CourseNewScreen(
      {super.key,
      required this.courseId,
      this.isShowBottomNavigationBar = true});
  final int courseId;
  final bool isShowBottomNavigationBar;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseNewViewState();
}

class _CourseNewViewState extends ConsumerState<CourseNewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Future<void> init() async {
    ref.read(courseController.notifier).getNewCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(courseController).courseDetails;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the height to zero
        child: AppBar(
          elevation:
              0, // Optional: Set elevation to zero for a completely flat look
          automaticallyImplyLeading: false, // Optional: Hide the back button
        ),
      ),
      body: Column(
        children: [
          CustomHeaderAppBar(
            title: S.of(context).courseDetails,
            widget: GestureDetector(
              onTap: () {
                if (model != null) {
                  ref
                      .read(favouriteTabController.notifier)
                      .favouriteUpdate(id: model.course.id)
                      .then((value) {
                    if (value.isSuccess) {
                      if (value.response == true) {
                        ref
                            .read(favouriteTabController.notifier)
                            .addFavouriteOnList(model);
                      }
                      if (value.response == false) {
                        ref
                            .read(favouriteTabController.notifier)
                            .removeFavouriteOnList(model.course.id);
                      }
                      ref.read(courseController.notifier).updateFavouriteItem();
                    }
                  });
                }
              },
              child: SvgPicture.asset(
                ref.watch(courseController).isFavourite &&
                        !ref.watch(courseController).isLoading
                    ? 'assets/svg/ic_heart.svg'
                    : 'assets/svg/ic_inactive_heart.svg',
                width: 24.h,
                height: 24.h,
              ),
            ),
          ),
          Expanded(
            child: ref.watch(courseController).isLoading || model == null
                ? const ShimmerWidget()
                : DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              CourseDetails(
                                model: model,
                              )
                            ]),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(
                              child: Container(
                                color: context.color.surface,
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        S.of(context).about,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        S.of(context).lessons,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        S.of(context).reviews,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          const AboutTab(),
                          const LessonsTab(),
                          ReviewsTab(model: model)
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: !widget.isShowBottomNavigationBar
          ? null
          : Container(
              width: double.infinity,
              color: context.color.surface,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppConstants.currencySymbol}${model == null ? 0 : model.course.price}',
                        style: AppTextStyle(context).subTitle,
                      ),
                      4.pw,
                      Text(
                        '${AppConstants.currencySymbol}${model == null ? 0 : model.course.regularPrice}',
                        style: AppTextStyle(context).buttonText.copyWith(
                              color: colors(context).hintTextColor,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: colors(context).hintTextColor,
                            ),
                      ),
                      const Spacer(),
                      AppButton(
                        title: S.of(context).enrolNow,
                        titleColor: context.color.surface,
                        textPaddingHorizontal: 16.h,
                        textPaddingVertical: 12.h,
                        onTap: () {
                          if (model != null) {
                            context.nav.pushNamed(Routes.checkOutScreen,
                                arguments: widget.courseId);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
