import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:ready_lms/components/offline.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      // Simulate a delay for splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      // Check connectivity
      var connectivityResult =
          await ConnectivityWrapper.instance.isConnected;
      if (connectivityResult) {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        // EasyLoading.showToast("No internet connection");
        // Navigator.pushReplacementNamed(context, Routes.offlineScreen);
      }
    } catch (e) {
      print("Error during splash initialization: $e");
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ref.read(hiveStorageProvider).getTheme()
                  ? 'assets/images/app_name_logo_dark.png'
                  : 'assets/images/app_name_logo_light.png',
              width: 150.h,
              height: 70.h,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
