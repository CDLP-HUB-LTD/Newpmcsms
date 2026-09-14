// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class ShowMessageOption extends StatelessWidget {
//   const ShowMessageOption({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.4,
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(8),
//           topRight: Radius.circular(8),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Send message as',
//                 style: context.textTheme.s16w500.copyWith(
//                   color: AppColors.black,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: const Icon(
//                   Icons.cancel,
//                   //  color: AppColors.primaryF5F5F5,
//                 ),
//               )
//             ],
//           ),
//           const VerticalSpacing(17),
//           const Divider(
//             color: AppColors.primaryE8E8E8,
//           ),
//           const VerticalSpacing(17),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.2,
//             child: ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: messageOptions.length,
//                 itemBuilder: (_, index) {
//                   final data = messageOptions[index];
//                   return Column(
//                     children: [
//                       Container(
//                         height: 58.h,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryF5F7F9,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 SvgPicture.asset(data['icon']),
//                                 const HorizontalSpacing(12),
//                                 Text(data['option'])
//                               ],
//                             ),
//                             SvgPicture.asset('assets/icons/arrow_right.svg'),
//                           ],
//                         ),
//                       ),
//                       const VerticalSpacing(20)
//                     ],
//                   );
//                 }),
//           )
//         ],
//       ),
//     );
//   }
// }

// final List<Map<String, dynamic>> messageOptions = [
//   {"icon": "assets/icons/sms.svg", "option": "SMS"},
//   {"icon": "assets/icons/mail.svg", "option": "Email"},
// ];
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/presentation/view/email_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/presentation/view/sms_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ShowMessageOption extends StatelessWidget {
  const ShowMessageOption({
    super.key,
    this.draftTitle,
    this.draftMessage,
  });

  /// The draft being sent, so tapping an option can carry it through to
  /// the relevant compose screen. Optional so this sheet can still be
  /// opened generically without a draft in future call sites.
  final String? draftTitle;
  final String? draftMessage;

  void _onOptionSelected(BuildContext context, String option) {
    Navigator.pop(context); // close the sheet first

    switch (option) {
      case 'SMS':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SmsView(
              initialDraftTitle: draftTitle,
              initialDraftMessage: draftMessage,
            ),
          ),
        );
        break;
      case 'Email':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmailView(
              initialDraftTitle: draftTitle,
              initialDraftMessage: draftMessage,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Send message as',
                style: context.textTheme.s16w500.copyWith(
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.cancel,
                  //  color: AppColors.primaryF5F5F5,
                ),
              )
            ],
          ),
          const VerticalSpacing(17),
          const Divider(
            color: AppColors.primaryE8E8E8,
          ),
          const VerticalSpacing(17),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: messageOptions.length,
                itemBuilder: (_, index) {
                  final data = messageOptions[index];
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _onOptionSelected(
                            context, data['option'] as String),
                        child: Container(
                          height: 58.h,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryF5F7F9,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(data['icon']),
                                  const HorizontalSpacing(12),
                                  Text(data['option'])
                                ],
                              ),
                              SvgPicture.asset('assets/icons/arrow_right.svg'),
                            ],
                          ),
                        ),
                      ),
                      const VerticalSpacing(20)
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> messageOptions = [
  {"icon": "assets/icons/sms.svg", "option": "SMS"},
  {"icon": "assets/icons/mail.svg", "option": "Email"},
];
