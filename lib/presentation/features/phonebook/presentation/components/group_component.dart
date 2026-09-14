import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/utils.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_group_view.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_group_request.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/components/contact_component.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/delete_group_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/get_all_groups_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/view/edit_group_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_search_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class GroupComponent extends ConsumerStatefulWidget {
  const GroupComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupComponentState();
}

class _GroupComponentState extends ConsumerState<GroupComponent> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getAllGroupsNotifier.notifier).getAllGroups();
    });
    super.initState();
  }

  void _groupSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final groupList =
        ref.watch(getAllGroupsNotifier.select((v) => v.data?.data ?? []));

    final searchQuery = ref.watch(searchQueryProvider);
    final filteredList = groupList.where((contact) {
      final matchSearch =
          contact.groupName!.toLowerCase().contains(searchQuery.toLowerCase());

      return matchSearch;
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      child: Stack(
        children: [
          Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                onChanged: _groupSearch,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryF5F7F9,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${groupList.length} Contacts',
                            style: context.textTheme.s14w400.copyWith(
                              color: AppColors.primary1C1C1C,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/download.svg'),
                              const HorizontalSpacing(12),
                              SvgPicture.asset('assets/icons/more_rounded.svg'),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.primaryE8E8E8,
                    ),
                    const VerticalSpacing(20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.47,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredList.length,
                          itemBuilder: (_, index) {
                            final group = filteredList[index];
                            final initials = getInitials(group.groupName ?? '');
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              AppColors.primaryF1BD6C,
                                          child: Text(initials,
                                              style: context.textTheme.s14w600
                                                  .copyWith(
                                                color: AppColors.black,
                                              )),
                                        ),
                                        const HorizontalSpacing(15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              group.groupName ?? '',
                                              style: context.textTheme.s14w500
                                                  .copyWith(
                                                color: AppColors.primary1C1C1C,
                                              ),
                                            ),
                                            const VerticalSpacing(3),
                                            Text(
                                              '${group.totalAddressBooks} Contacts',
                                              style: context.textTheme.s12w400
                                                  .copyWith(
                                                color: AppColors.primary676767,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton(
                                        borderRadius: BorderRadius.circular(8),
                                        elevation: 0.5,
                                        padding: EdgeInsets.zero,
                                        color: AppColors.white,
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              onTap: () {
                                                context.pushNamed(
                                                  EditGroupView.routeName,
                                                  arguments: EditGroupArgs(
                                                    groupId: group.groupId ?? 0,
                                                    initialName:
                                                        group.groupName ?? '',
                                                  ),
                                                );
                                              },
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/edit.svg'),
                                                  const HorizontalSpacing(8),
                                                  Text(
                                                    'Edit group',
                                                    style: context
                                                        .textTheme.s14w500
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary1C1C1C),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                _deleteGroup(
                                                    group.groupId ?? 0);
                                              },
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/delete.svg'),
                                                  const HorizontalSpacing(8),
                                                  Text(
                                                    'Delete group',
                                                    style: context
                                                        .textTheme.s14w500
                                                        .copyWith(
                                                      color: AppColors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ];
                                        })
                                  ],
                                ),
                                const VerticalSpacing(10),
                                const Divider(
                                  color: AppColors.primaryE8E8E8,
                                )
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            right: 0,
            child: GestureDetector(
              onTap: () => context.pushNamed(AddGroupView.routeName),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    color: AppColors.primaryColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _deleteGroup(int groupId) {
    final data = DeleteGroupRequest(
      groupId: groupId,
      process: 'pm_groups',
      action: 'delete_group',
    );

    ref.read(deleteGroupNotifier.notifier).deleteGroup(
        data: data,
        onError: (error) {
          context.showError(message: error);
        },
        onSuccess: (message) {
          context.showSuccess(message: message);
        });
  }
}
