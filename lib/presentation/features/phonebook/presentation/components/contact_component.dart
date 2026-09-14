// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/build_context_extension.dart';
// import 'package:pmcsms/core/extensions/overlay_extension.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/core/utils/utils.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_contact_view.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/delete_contact_request.dart';
// import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/delete_contact_notifier.dart';
// import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/get_all_phone_book_notifier.dart';
// import 'package:pmcsms/presentation/features/phonebook/presentation/view/edit_contact_view.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_search_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// final searchQueryProvider = StateProvider<String>((ref) => '');

// class ContactComponent extends ConsumerStatefulWidget {
//   final bool isPickerMode;

//   const ContactComponent({super.key, this.isPickerMode = false});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ContactComponentState();
// }

// class _ContactComponentState extends ConsumerState<ContactComponent> {

//     final _selected = <int, String>{}; // addressId -> phone number

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref.read(getAllContactsNotifier.notifier).getAllContacts(
//             start: 1,
//             length: 50,
//           );
//     });
//     super.initState();
//   }

//   final _searchController = TextEditingController();

//   void _contactSearch(String query) {
//     ref.read(searchQueryProvider.notifier).state = query;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final contactsList =
//         ref.watch(getAllContactsNotifier.select((v) => v.data?.data ?? []));

//     final searchQuery = ref.watch(searchQueryProvider);
//     final filteredList = contactsList.where((contact) {
//       final matchSearch =
//           contact.ownerName!.toLowerCase().contains(searchQuery.toLowerCase());

//       return matchSearch;
//     }).toList();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               CustomSearchBar(
//                 controller: _searchController,
//                 onChanged: _contactSearch,
//               ),
//               const VerticalSpacing(17),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: AppColors.primaryF5F7F9,
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${contactsList.length} Contacts',
//                             style: context.textTheme.s14w400.copyWith(
//                               color: AppColors.primary1C1C1C,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               SvgPicture.asset('assets/icons/download.svg'),
//                               const HorizontalSpacing(12),
//                               SvgPicture.asset('assets/icons/more_rounded.svg'),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     const Divider(
//                       color: AppColors.primaryE8E8E8,
//                     ),
//                     const VerticalSpacing(20),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.47,
//                       child:
//                       ListView.builder(
//                 itemBuilder: (_, index) {
//                   final contact = filteredList[index];
//                   final isSelected = _selected.containsKey(contact.addressId);
//                   return InkWell(
//                     onTap: widget.isPickerMode
//                         ? () => setState(() {
//                               if (isSelected) {
//                                 _selected.remove(contact.addressId);
//                               } else {
//                                 _selected[contact.addressId!] =
//                                     contact.phoneNumber ?? ''; // <-- your real field
//                               }
//                             })
//                         : null,
//                     child: Row(
//                       children: [
//                         if (widget.isPickerMode)
//                           Checkbox(
//                             value: isSelected,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 20,
//                                           backgroundColor:
//                                               AppColors.primaryF1BD6C,
//                                           child: Text(initials,
//                                               style: context.textTheme.s14w600
//                                                   .copyWith(
//                                                 color: AppColors.black,
//                                               )),
//                                         ),
//                                         const HorizontalSpacing(15),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               contact.ownerName ?? '',
//                                               style: context.textTheme.s14w500
//                                                   .copyWith(
//                                                 color: AppColors.primary1C1C1C,
//                                               ),
//                                             ),
//                                             const VerticalSpacing(3),
//                                             Text(
//                                               contact.addressBook ?? '',
//                                               style: context.textTheme.s12w400
//                                                   .copyWith(
//                                                 color: AppColors.primary676767,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     PopupMenuButton(
//                                         borderRadius: BorderRadius.circular(8),
//                                         elevation: 0.5,
//                                         padding: EdgeInsets.zero,
//                                         color: AppColors.white,
//                                         icon: const Icon(Icons.more_vert),
//                                         itemBuilder: (context) {
//                                           return [
//                                             PopupMenuItem(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 1),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   SvgPicture.asset(
//                                                       'assets/icons/edit.svg'),
//                                                   const HorizontalSpacing(8),
//                                                   Text(
//                                                     'Edit Contact',
//                                                     style: context
//                                                         .textTheme.s14w500
//                                                         .copyWith(
//                                                       color: AppColors
//                                                           .primary1C1C1C,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               onTap: () {
//                                                 showModalBottomSheet(
//                                                     context: context,
//                                                     builder: (_) {
//                                                       return const EditContactView();
//                                                     });
//                                               },
//                                             ),
//                                             PopupMenuItem(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 1),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   const Icon(Icons.add),
//                                                   const HorizontalSpacing(8),
//                                                   Text(
//                                                     'Add to group',
//                                                     style: context
//                                                         .textTheme.s14w500
//                                                         .copyWith(
//                                                       color: AppColors
//                                                           .primary1C1C1C,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             PopupMenuItem(
//                                               onTap: () {
//                                                 _deleteContact(
//                                                     contact.addressId!);
//                                               },
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 1),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   SvgPicture.asset(
//                                                       'assets/icons/delete.svg'),
//                                                   const HorizontalSpacing(8),
//                                                   Text(
//                                                     'Delete contact',
//                                                     style: context
//                                                         .textTheme.s14w500
//                                                         .copyWith(
//                                                       color: AppColors.red,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ];
//                                         })
//                                   ],
//                                 ),
//                                 const VerticalSpacing(10),
//                                 const Divider(
//                                   color: AppColors.primaryE8E8E8,
//                                 )
//                               ],
//                             );
//                           }),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 50,
//             right: 0,
//             child: GestureDetector(
//               onTap: () => context.pushNamed(AddContactView.routeName),
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                     color: AppColors.primaryColor, shape: BoxShape.circle),
//                 child: const Icon(
//                   Icons.add,
//                   color: AppColors.white,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _deleteContact(int addressBookId) {
//     final data = DeleteContactRequest(
//       addressBookId: addressBookId,
//       process: 'pm_address_books',
//       action: 'delete_address_book',
//     );

//     ref.read(deleteContactNotifier.notifier).deleteContact(
//         data: data,
//         onError: (error) {
//           context.showError(message: error);
//         },
//         onSuccess: (message) {
//           context.showSuccess(message: message);
//           ref.read(getAllContactsNotifier.notifier).getAllContacts();
//         });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/utils.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_contact_view.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_contact_request.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/delete_contact_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/get_all_phone_book_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/view/edit_contact_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_search_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class ContactComponent extends ConsumerStatefulWidget {
  final bool isPickerMode;

  const ContactComponent({super.key, this.isPickerMode = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactComponentState();
}

class _ContactComponentState extends ConsumerState<ContactComponent> {
  // addressId -> phone number, for whatever the user has checked in
  // picker mode. A Map (not a Set<int>) so we don't have to go back to
  // the full contact list to build the final List<String> to pop.
  final Map<int, String> _selected = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getAllContactsNotifier.notifier).getAllContacts(
            start: 1,
            length: 50,
          );
    });
    super.initState();
  }

  final _searchController = TextEditingController();

  void _contactSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  void _toggleSelected(int addressId, String phoneNumber) {
    setState(() {
      if (_selected.containsKey(addressId)) {
        _selected.remove(addressId);
      } else {
        _selected[addressId] = phoneNumber;
      }
    });
  }

  void _confirmSelection() {
    if (_selected.isEmpty) return;
    Navigator.pop(context, _selected.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    final contactsList =
        ref.watch(getAllContactsNotifier.select((v) => v.data?.data ?? []));

    final searchQuery = ref.watch(searchQueryProvider);
    final filteredList = contactsList.where((contact) {
      final matchSearch =
          contact.ownerName!.toLowerCase().contains(searchQuery.toLowerCase());

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
                onChanged: _contactSearch,
              ),
              const VerticalSpacing(17),
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
                            widget.isPickerMode
                                ? '${_selected.length} selected'
                                : '${contactsList.length} Contacts',
                            style: context.textTheme.s14w400.copyWith(
                              color: AppColors.primary1C1C1C,
                            ),
                          ),
                          if (!widget.isPickerMode)
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/download.svg'),
                                const HorizontalSpacing(12),
                                SvgPicture.asset(
                                    'assets/icons/more_rounded.svg'),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.primaryE8E8E8,
                    ),
                    const VerticalSpacing(20),
                    SizedBox(
                      // Leave room at the bottom for the "Add selected"
                      // button in picker mode so it doesn't cover the
                      // last row.
                      height: MediaQuery.of(context).size.height *
                          (widget.isPickerMode ? 0.40 : 0.47),
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredList.length,
                          itemBuilder: (_, index) {
                            final contact = filteredList[index];
                            final initials =
                                getInitials(contact.ownerName ?? '');

                            // TODO: swap `contact.phoneNumber` for your
                            // actual field name on the contact model
                            // (e.g. contact.phone, contact.msisdn, etc).
                            final phoneNumber = contact.addressBook ?? '';
                            final isSelected = widget.isPickerMode &&
                                contact.addressId != null &&
                                _selected.containsKey(contact.addressId);

                            return Column(
                              children: [
                                InkWell(
                                  onTap: widget.isPickerMode
                                      ? () {
                                          if (contact.addressId == null) {
                                            return;
                                          }
                                          _toggleSelected(
                                              contact.addressId!, phoneNumber);
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          if (widget.isPickerMode)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Checkbox(
                                                value: isSelected,
                                                activeColor:
                                                    AppColors.primaryColor,
                                                onChanged: (_) {
                                                  if (contact.addressId ==
                                                      null) {
                                                    return;
                                                  }
                                                  _toggleSelected(
                                                      contact.addressId!,
                                                      phoneNumber);
                                                },
                                              ),
                                            ),
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
                                                contact.ownerName ?? '',
                                                style: context.textTheme.s14w500
                                                    .copyWith(
                                                  color:
                                                      AppColors.primary1C1C1C,
                                                ),
                                              ),
                                              const VerticalSpacing(3),
                                              Text(
                                                contact.addressBook ?? '',
                                                style: context.textTheme.s12w400
                                                    .copyWith(
                                                  color:
                                                      AppColors.primary676767,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Edit / Add to group / Delete don't
                                      // make sense while picking recipients
                                      // for an SMS, so hide the menu there.
                                      if (!widget.isPickerMode)
                                        PopupMenuButton(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            elevation: 0.5,
                                            padding: EdgeInsets.zero,
                                            color: AppColors.white,
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/edit.svg'),
                                                      const HorizontalSpacing(
                                                          8),
                                                      Text(
                                                        'Edit Contact',
                                                        style: context
                                                            .textTheme.s14w500
                                                            .copyWith(
                                                          color: AppColors
                                                              .primary1C1C1C,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (_) {
                                                          return const EditContactView();
                                                        });
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.add),
                                                      const HorizontalSpacing(
                                                          8),
                                                      Text(
                                                        'Add to group',
                                                        style: context
                                                            .textTheme.s14w500
                                                            .copyWith(
                                                          color: AppColors
                                                              .primary1C1C1C,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  onTap: () {
                                                    _deleteContact(
                                                        contact.addressId!);
                                                  },
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/delete.svg'),
                                                      const HorizontalSpacing(
                                                          8),
                                                      Text(
                                                        'Delete contact',
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
                                            }),
                                    ],
                                  ),
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
          if (widget.isPickerMode)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selected.isEmpty ? null : _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected.isEmpty
                        ? AppColors.primaryColor.withOpacity(0.4)
                        : AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    _selected.isEmpty
                        ? 'Select recipients'
                        : 'Add ${_selected.length} recipient${_selected.length == 1 ? '' : 's'}',
                    style: context.textTheme.s14w600
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
            )
          else
            Positioned(
              bottom: 50,
              right: 0,
              child: GestureDetector(
                onTap: () => context.pushNamed(AddContactView.routeName),
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
            ),
        ],
      ),
    );
  }

  void _deleteContact(int addressBookId) {
    final data = DeleteContactRequest(
      addressBookId: addressBookId,
      process: 'pm_address_books',
      action: 'delete_address_book',
    );

    ref.read(deleteContactNotifier.notifier).deleteContact(
        data: data,
        onError: (error) {
          context.showError(message: error);
        },
        onSuccess: (message) {
          context.showSuccess(message: message);
          ref.read(getAllContactsNotifier.notifier).getAllContacts();
        });
  }
}
