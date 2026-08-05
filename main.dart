// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pmcsms/core/navigation/router.dart';
// import 'package:pmcsms/presentation/general_widgets/app_overlay.dart';

// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _controller = OverLayController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//         designSize: const Size(362, 800),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, c) {
//           return GestureDetector(
//             behavior: HitTestBehavior.translucent,
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child: Directionality(
//               textDirection: TextDirection.ltr,
//               child: AppOverLay(
//                 controller: _controller,
//                 child: MaterialApp(
//                   // theme: AppThemes.darkTheme(),
//                   debugShowCheckedModeBanner: false,
//                   routes: AppRouter.routes,
//                   initialRoute: '/',
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/navigation/router.dart';
import 'package:pmcsms/presentation/general_widgets/app_overlay.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = OverLayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(362, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, c) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AppOverLay(
            controller: _controller,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: AppRouter.routes,
              initialRoute: '/',
            ),
          ),
        );
      },
    );
  }
}
