import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_all_drafts_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_details.dart';

import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:pmcsms/utils/date_format.dart';

class DraftsSection extends ConsumerStatefulWidget {
  const DraftsSection({
    required this.filteredDrafts,
    required this.service,
    super.key,
  });
  final List<AllDraftsData>? filteredDrafts;
  final DraftServiceTab service;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DraftsSectionState();
}

class _DraftsSectionState extends ConsumerState<DraftsSection> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(getAllDraftsNotifier.notifier)
          .getAllDrafts(service: widget.service);
      _initializeDisplayedDrafts();
    });
    super.initState();
  }

  List<AllDraftsData>? displayedDrafts;
  bool isSearching = false;

  @override
  void didUpdateWidget(DraftsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update displayed drafts when filteredDrafts changes
    setState(() {
      isSearching = widget.filteredDrafts != null;
      displayedDrafts = widget.filteredDrafts?.isEmpty ?? true
          ? (isSearching
              ? []
              : ref.read(getAllDraftsNotifier).getAllDraftsResponse?.data)
          : widget.filteredDrafts;
    });
  }

  void _initializeDisplayedDrafts() {
    setState(() {
      displayedDrafts =
          ref.watch(getAllDraftsNotifier).getAllDraftsResponse?.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (isSearching && (displayedDrafts?.isEmpty ?? true))
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.primary8A93A3,
                  ),
                  const VerticalSpacing(10),
                  Text(
                    'Item not found',
                    style: context.textTheme.s14w500.copyWith(
                      color: AppColors.primary8A93A3,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                itemCount: displayedDrafts?.length,
                itemBuilder: (_, index) {
                  final data = displayedDrafts?[index];
                  //final count = displayedDrafts?.length;

                  final formattedDate =
                      formatDateTimeFromString("${data?.dateCreated}");
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DraftDetails(
                                  draftId: "${data?.draftId}",
                                  service: widget.service,
                                  action: 'view',
                                ))),
                    child: Column(
                      children: [
                        DraftWidget(
                          title: '${data?.draftTitle}',
                          message: '${data?.draftMessage}',
                          date: formattedDate,
                        ),
                        const VerticalSpacing(10),
                        // if (index < (count!) - 1)
                        const Divider(
                          color: AppColors.primaryE8E8E8,
                        ),
                        const VerticalSpacing(10),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class DraftWidget extends StatelessWidget {
  const DraftWidget(
      {super.key,
      required this.title,
      required this.message,
      required this.date});
  final String title;
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.textTheme.s14w500.copyWith(
                color: AppColors.primary1C1C1C,
              ),
            ),
            Text(
              date,
              style: context.textTheme.s14w500.copyWith(
                color: AppColors.primary494949,
              ),
            ),
          ],
        ),
        const VerticalSpacing(10),
        Text(
          message,
          style: context.textTheme.s14w400.copyWith(
            color: AppColors.primary1C1C1C,
          ),
        ),
      ],
    );
  }
}
