// ignore_for_file: override_on_non_overriding_member
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ref.read(courseController).videoPlayerController?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      // App is back to the foreground, resume the audio if it was playing before
      ref.read(courseController).videoPlayerController?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loading = ref.watch(courseController).videoLoading;
    VideoPlayerController? videoPlayerController =
        ref.watch(courseController).videoPlayerController;
    ChewieController? chewieController =
        ref.watch(courseController).chewieController;
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

            ref.read(courseController.notifier).updateState();
          },
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Container(
              color: context.color.surface,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
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
      ],
    );
  }
}
