import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/components/contact_component.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/components/group_component.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';

class PhonebookView extends ConsumerStatefulWidget {
  const PhonebookView({super.key, this.isPickerMode = false});
  static const String routeName = '/phonebookView';

  /// When true, this screen is used to pick recipients (e.g. from
  /// SmsView's "Add recipients from phone book") rather than to manage
  /// contacts. Only the Contacts tab makes sense for picking individual
  /// phone numbers — Groups is skipped entirely, since there's no
  /// group->members expansion to turn a group pick into a recipient list.
  /// Pops with a `List<String>` of selected phone numbers, or nothing if
  /// the user backs out without selecting.
  final bool isPickerMode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhonebookViewState();
}

class _PhonebookViewState extends ConsumerState<PhonebookView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPickerMode) {
      return Scaffold(
        appBar: const CustomAppBar(
          backgroundColor: AppColors.white,
          title: 'Select recipients',
        ),
        body: ContactComponent(isPickerMode: true),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: AppColors.white,
        title: 'Phone Book',
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.09,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TabBar(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(4)),
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                    labelColor: AppColors.white,
                    labelStyle: context.textTheme.s12w400,
                    tabs: [
                      Text('Contacts', style: context.textTheme.s12w400),
                      Text('Groups', style: context.textTheme.s12w400),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ContactComponent(),
                GroupComponent(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
