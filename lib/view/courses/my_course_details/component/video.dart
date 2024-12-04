// ignore_for_file: override_on_non_overriding_member

import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends ConsumerStatefulWidget {
  const VideoCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoCardViewState();
}

class _VideoCardViewState extends ConsumerState<VideoCard> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in the background, pause the audio
      ref.read(myCourseDetailsController).videoPlayerController?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      // App is back to the foreground, resume the audio if it was playing before
      ref.read(myCourseDetailsController).videoPlayerController?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loading = ref.watch(myCourseDetailsController).videoLoading;
    VideoPlayerController? videoPlayerController =
        ref.watch(myCourseDetailsController).videoPlayerController;
    ChewieController? chewieController =
        ref.watch(myCourseDetailsController).chewieController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: () {
            if (chewieController != null) {
              if (videoPlayerController!.value.isPlaying) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }
            }

            ref.read(myCourseDetailsController.notifier).updateState();
          },
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Container(
              color: context.color.surface,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (ref
                          .watch(myCourseDetailsController)
                          .currentPlay
                          ?.fileSystem ==
                      FileSystem.audio.name)
                    FadeInImage.assetNetwork(
                      placeholderFit: BoxFit.contain,
                      placeholder: 'assets/images/spinner.gif',
                      image: ref
                          .watch(myCourseDetailsController)
                          .courseDetails!
                          .course
                          .thumbnail,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: loading == false &&
                              chewieController != null &&
                              videoPlayerController?.value != null
                          ? Chewie(controller: chewieController)
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.nav.pushNamed(Routes.courseNew, arguments: {
              'courseId':
                  ref.watch(myCourseDetailsController).courseDetails?.course.id,
              'show': false
            });
          },
          child: Container(
            color: context.color.surface,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
            child: Text(
              ref.watch(myCourseDetailsController).currentPlay!.fileName ??
                  "Demo",
              style: AppTextStyle(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
