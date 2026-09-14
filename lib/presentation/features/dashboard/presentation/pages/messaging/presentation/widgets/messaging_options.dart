import 'package:flutter/material.dart';
import 'package:pmcsms/core/theme/app_colors.dart';

class MessagingOption {
  final String icon;
  final String title;
  final String subTitle;
  final Color iconContainerColor;
  final Color containerColor;

  MessagingOption({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.iconContainerColor,
    required this.containerColor,
  });
}

final List<MessagingOption> messagingOptions = [
  MessagingOption(
    icon: 'assets/icons/sms.svg',
    title: 'SMS',
    subTitle: 'Send messages to recipients phone number',
    iconContainerColor: AppColors.primaryFFFDE6,
    containerColor: AppColors.primaryF5F7F9,
  ),
  // MessagingOption(
  //   iconContainerColor: AppColors.primaryE6F8FE,
  //   icon: 'assets/icons/email.svg',
  //   title: 'Email',
  //   subTitle: 'Send messages to recipients phone number',
  //   containerColor: AppColors.primaryF5F7F9,
  // ),
  // MessagingOption(
  //   iconContainerColor: AppColors.primaryFDE6FF,
  //   icon: 'assets/icons/voice_sms.svg',
  //   title: 'Voice SMS',
  //   subTitle: 'Send messages to recipients phone number',
  //   containerColor: AppColors.primaryF5F7F9,
  // ),
  // MessagingOption(
  //   iconContainerColor: AppColors.primaryE6FEEB,
  //   icon: 'assets/icons/whatsapp.svg',
  //   title: 'Whatsapp',
  //   subTitle: 'Send messages to recipients phone number',
  //   containerColor: AppColors.primaryF5F7F9,
  // ),
  MessagingOption(
    iconContainerColor: AppColors.primaryFEE6EE,
    icon: 'assets/icons/scheduled_message.svg',
    title: 'Scheduled Messages',
    subTitle: 'Send messages to recipients phone number',
    containerColor: AppColors.primaryF5F7F9,
  ),
  MessagingOption(
    iconContainerColor: AppColors.primaryECE7FE,
    icon: 'assets/icons/draft.svg',
    title: 'Draft',
    subTitle: 'Send messages to recipients phone number',
    containerColor: AppColors.primaryF5F7F9,
  ),
];
