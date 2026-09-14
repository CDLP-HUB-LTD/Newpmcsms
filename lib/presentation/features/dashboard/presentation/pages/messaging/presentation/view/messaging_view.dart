import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/presentation/view/email_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/presentation/view/scheduled_sms_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/presentation/view/sms_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/presentation/view/voice_sms_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/presentation/view/whatsapp_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/presentation/widgets/messaging_options.dart';
import 'package:pmcsms/presentation/features/history/views/history_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_options_button_widget.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class MessagesView extends ConsumerStatefulWidget {
  const MessagesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessagesViewState();
}

class _MessagesViewState extends ConsumerState<MessagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const SizedBox.shrink(),
        title: 'Messaging',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HistoryView.routeName);
              },
              child: SvgPicture.asset('assets/icons/clock.svg'),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                  itemCount: messagingOptions.length,
                  itemBuilder: (_, index) {
                    final data = messagingOptions[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _onTap(index),
                          child: AppOptionsButtonWidget(
                            iconContainerColor: data.iconContainerColor,
                            icon: data.icon,
                            title: data.title,
                            subTitle: data.subTitle,
                            containerColor: data.containerColor,
                          ),
                        ),
                        const VerticalSpacing(24)
                      ],
                    );
                  }))),
    );
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        context.pushNamed<void>(SmsView.routeName);
      // case 1:
      //   context.pushNamed<void>(EmailView.routeName);
      // case 2:
      //   context.pushNamed<void>(VoiceSmsView.routeName);
      // case 3:
      //   context.pushNamed<void>(WhatsappView.routeName);
      case 1:
        context.pushNamed<void>(ScheduledSmsView.routeName);
      case 2:
        context.pushNamed<void>(DraftView.routeName);

      default:
    }
  }
}
