import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/hive_mode/hive_cart_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/global_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.appSettingsBox);
  Hive.registerAdapter(HiveCartModelAdapter());
  await Hive.openBox<HiveCartModel>(AppHSC.cartBox);
  if (!kDebugMode) {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Locale resolveLocal({required String langCode}) {
    return Locale(langCode);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 800), // XD Design Sizes
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
          builder: (context, appSettingsBox, _) {
            final isDark = appSettingsBox.get(AppHSC.isDarkTheme,
                defaultValue: false) as bool;
            final selectedLocal =
                appSettingsBox.get(AppHSC.appLocal) as String?;
            if (selectedLocal == null) {
              appSettingsBox.put(AppHSC.appLocal, 'en');
            }

            return ConnectivityAppWrapper(
              app: MaterialApp(
                navigatorKey: ApGlobalFunctions.navigatorKey,
                scaffoldMessengerKey: ApGlobalFunctions.getSnackbarKey(),
                title: 'Exam up',
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FormBuilderLocalizations.delegate,
                ],
                locale: resolveLocal(langCode: selectedLocal ?? 'en'),
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                  if (selectedLocal == '') {
                    appSettingsBox.put(
                      AppHSC.appLocal,
                      deviceLocal?.languageCode,
                    );
                  }
                  for (final locale in supportedLocales) {
                    if (locale.languageCode == deviceLocal!.languageCode) {
                      return deviceLocal;
                    }
                  }
                  return supportedLocales.first;
                },
                supportedLocales: S.delegate.supportedLocales,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: getAppTheme(
                  context: context,
                  isDarkTheme: false,
                ),
                darkTheme: getAppTheme(
                  context: context,
                  isDarkTheme: true,
                ),
                onGenerateRoute: generatedRoutes,
                initialRoute: Routes.splash,
                builder: EasyLoading.init(),
              ),
            );
          },
        );
      },
    );
  }
}
