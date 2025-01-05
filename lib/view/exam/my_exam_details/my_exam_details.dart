import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/controllers/my_exam_details.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/hive_service.dart';
class MyExamDetails extends ConsumerStatefulWidget {
  const MyExamDetails({super.key, required this.examID});
  final int examID;

  @override
  ConsumerState<MyExamDetails> createState() => _MyExamDetailsState();
}

class _MyExamDetailsState extends ConsumerState<MyExamDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myExamDetailsController.notifier).getExamDetails(widget.examID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final examDetailsState = ref.watch(myExamDetailsController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          examDetailsState.exam?.name ?? 'Exam Details',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18.sp),
        ),
        leading: IconButton(
          onPressed: () {
            ref.read(myExamDetailsController.notifier).disposeController();
            context.nav.pop();
          },
          icon: SvgPicture.asset(
            'assets/svg/ic_arrow_left.svg',
            width: 24.h,
            height: 24.h,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: examDetailsState.isLoading || examDetailsState.exam == null
          ? const ShimmerWidget()
          : Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            'https://via.placeholder.com/250',
                            width: 250.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        examDetailsState.exam!.name,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        examDetailsState.exam!.description,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 20.h),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailTile(
                            label: 'Questions',
                            value: '${examDetailsState.exam!.totalQuestions}',
                          ),
                          DetailTile(
                            label: 'Total Marks',
                            value: '${examDetailsState.exam!.totalMarks}',
                          ),
                          DetailTile(
                            label: 'Passing %',
                            value: '${examDetailsState.exam!.passingMarks}%',
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 20.h),
                      Text(
                        'Duration: ${examDetailsState.exam!.totalDuration} minutes',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                             context.nav.popAndPushNamed(
                                Routes.webViewScreen,
                                arguments: (AppConstants.url)+'interface/exams/${examDetailsState.exam!.slug}/instructions/${ ref.read(hiveStorageProvider).getAuthToken()}',
                              );
                          },
                          child: Text(
                            'Start Exam',
                            style: TextStyle(fontSize: 16.sp),
                            selectionColor: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final String label;
  final String value;

  const DetailTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
