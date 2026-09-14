// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class DashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
//   const DashboardAppbar(
//       {super.key, required this.greeting, required this.userName});
//   final String greeting;
//   final String userName;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,

//       title: SizedBox(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Scaffold.of(context).openDrawer();
//               },
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 20,
//                     backgroundImage:
//                         AssetImage('assets/images/user_avatar.png'),
//                   ),
//                   const HorizontalSpacing(8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         greeting,
//                         style: context.textTheme.s12w400.copyWith(
//                             color: AppColors.primary494949, fontSize: 11),
//                       ),
//                       const VerticalSpacing(2),
//                       Text(
//                         userName,
//                         style: context.textTheme.s14w600.copyWith(
//                           color: AppColors.primary191919,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primaryF2F2F2,
//               ),
//               child: SvgPicture.asset('assets/icons/notification.svg'),
//             )
//           ],
//         ),
//       ),
//       // leading: SizedBox.shrink(),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/notification/views/notifications_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class DashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppbar(
      {super.key, required this.greeting, required this.userName});
  final String greeting;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('assets/images/user_avatar.png'),
                  ),
                  const HorizontalSpacing(8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: context.textTheme.s12w400.copyWith(
                            color: AppColors.primary494949, fontSize: 11),
                      ),
                      const VerticalSpacing(2),
                      Text(
                        userName,
                        style: context.textTheme.s14w600.copyWith(
                          color: AppColors.primary191919,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              // NOTE: this icon previously had no gesture handler at all —
              // tapping it did nothing. NotificationsView is currently a
              // placeholder with no backend endpoint; swap the route once
              // one exists.
              onTap: () {
                Navigator.pushNamed(context, NotificationsView.routeName);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryF2F2F2,
                ),
                child: SvgPicture.asset('assets/icons/notification.svg'),
              ),
            )
          ],
        ),
      ),
      // leading: SizedBox.shrink(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
