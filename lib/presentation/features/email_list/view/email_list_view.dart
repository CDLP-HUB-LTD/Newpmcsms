// lib/presentation/features/email_list/presentation/view/email_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_contact_view.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
import 'package:pmcsms/presentation/features/email_list/view/add_to_group_view.dart';
import 'package:pmcsms/presentation/features/email_list/view/delete_contact_dialogue.dart';
import 'package:pmcsms/presentation/features/email_list/view/edit_contact_view.dart';
import 'package:pmcsms/presentation/features/email_list/view/group_views.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Which top-level tab of the Email List is showing.
enum _EmailListTab { contacts, groups }

class EmailListView extends ConsumerStatefulWidget {
  const EmailListView({super.key});
  static const String routeName = '/emailList';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailListViewState();
}

class _EmailListViewState extends ConsumerState<EmailListView> {
  final _searchController = TextEditingController();

  _EmailListTab _tab = _EmailListTab.contacts;
  bool _isManageMode = false;

  // TODO: replace with real contacts from a provider, e.g.
  // ref.watch(emailContactsNotifier.select((v) => v.contacts))
  final List<EmailContact> _contacts = [
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
    const EmailContact(
        id: '1', name: 'Boluwatife Ogunwale', email: 'boluwatifeO@gmail.com'),
  ];

  final Set<int> _selectedIndexes = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Email List'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopTabs(),
              const VerticalSpacing(16),
              _buildSearchField(),
              const VerticalSpacing(16),
              Expanded(
                child: _tab == _EmailListTab.contacts
                    ? _buildContactsList()
                    : const GroupsView(),
                // ? _buildContactsList()
                //  : _buildGroupsPlaceholder(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _tab == _EmailListTab.contacts
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              elevation: 0,
              onPressed: () {
                context.pushNamed(AddContactView.routeName);
              },
              child: const Icon(Icons.add, color: AppColors.white),
            )
          : null,
    );
  }

  // ── TOP TABS: "Contacts" | "Groups" ─────────────────────────────────────
  Widget _buildTopTabs() {
    return Row(
      children: [
        _buildTabButton('Contacts', _tab == _EmailListTab.contacts),
        const SizedBox(width: 8),
        _buildTabButton('Groups', _tab == _EmailListTab.groups),
      ],
    );
  }

  Widget _buildTabButton(String label, bool selected) {
    return InkWell(
      onTap: () => setState(() {
        _tab =
            label == 'Groups' ? _EmailListTab.groups : _EmailListTab.contacts;
      }),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: context.textTheme.s14w500.copyWith(
            color: selected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // ── SEARCH FIELD ─────────────────────────────────────────────────────────
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: AppColors.primaryF5F7F9,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  // ── CONTACTS LIST ────────────────────────────────────────────────────────
  Widget _buildContactsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: _isManageMode
            ? Border.all(color: AppColors.primaryColor, width: 1.5)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_contacts.length} Contacts',
                style: context.textTheme.s14w600,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.download_outlined, size: 20),
                    onPressed: _showExportSheet,
                  ),
                  IconButton(
                    icon: Icon(
                      _isManageMode
                          ? Icons.remove_circle
                          : Icons.remove_circle_outline,
                      size: 20,
                    ),
                    onPressed: () => setState(() {
                      _isManageMode = !_isManageMode;
                      if (!_isManageMode) _selectedIndexes.clear();
                    }),
                  ),
                ],
              ),
            ],
          ),
          if (_isManageMode) ...[
            const VerticalSpacing(4),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => setState(() {
                  if (_selectedIndexes.length == _contacts.length) {
                    _selectedIndexes.clear();
                  } else {
                    _selectedIndexes
                      ..clear()
                      ..addAll(List.generate(_contacts.length, (i) => i));
                  }
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryE6E6E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Select all', style: context.textTheme.s12w400),
                      const SizedBox(width: 6),
                      Icon(
                        _selectedIndexes.length == _contacts.length
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const VerticalSpacing(8),
          Expanded(
            child: ListView.separated(
              itemCount: _contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final contact = _contacts[index];
                return _ContactListTile(
                  contact: contact,
                  index: index,
                  isManageMode: _isManageMode,
                  isSelected: _selectedIndexes.contains(index),
                  onSelectToggle: () => setState(() {
                    if (_selectedIndexes.contains(index)) {
                      _selectedIndexes.remove(index);
                    } else {
                      _selectedIndexes.add(index);
                    }
                  }),
                  onEdit: () async {
                    final updated = await Navigator.push<EmailContact>(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditContactView(contact: contact)),
                    );
                    // TODO: if updated != null, refresh via your contacts notifier
                  },
                  onAddToGroup: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddToGroupView(contact: contact)),
                    );
                  },
                  onDelete: () async {
                    final confirmed = await showDeleteContactDialog(context,
                        contactName: contact.name);
                    if (confirmed == true) {
                      // TODO: ref.read(contactsNotifier.notifier).delete(contact.id)
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsPlaceholder() {
    // TODO: implement the Groups tab (group list, group details, add group)
    return Center(
      child: Text(
        'Groups coming soon',
        style: context.textTheme.s14w400.copyWith(color: Colors.grey[600]),
      ),
    );
  }

  void _showExportSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Export contacts as', style: context.textTheme.s16w600),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const VerticalSpacing(12),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('CSV'),
                onTap: () {
                  // TODO: export contacts as CSV
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('PDF'),
                onTap: () {
                  // TODO: export contacts as PDF
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed duplicate EmailContact class. Use the one from the imported model.

class _ContactListTile extends StatelessWidget {
  const _ContactListTile({
    required this.contact,
    required this.index,
    required this.isManageMode,
    required this.isSelected,
    required this.onSelectToggle,
    required this.onEdit,
    required this.onAddToGroup,
    required this.onDelete,
  });

  final EmailContact contact;
  final int index;
  final bool isManageMode;
  final bool isSelected;
  final VoidCallback onSelectToggle;
  final VoidCallback onEdit;
  final VoidCallback onAddToGroup;
  final VoidCallback onDelete;

  static const _avatarColors = [
    AppColors.primaryF9BC1F,
    AppColors.primaryE6E6E6,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    final initials =
        contact.name.trim().isEmpty ? '?' : contact.name.trim().substring(0, 2);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: isManageMode ? onSelectToggle : null,
      leading: CircleAvatar(
        backgroundColor: _avatarColors[index % _avatarColors.length],
        child: Text(initials, style: const TextStyle(color: Colors.white)),
      ),
      title: Text(contact.name, style: context.textTheme.s14w500),
      subtitle: Text(contact.email, style: context.textTheme.s12w400),
      trailing: isManageMode
          ? Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: AppColors.primaryColor,
            )
          : PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'group':
                    onAddToGroup();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Edit contact'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'group',
                  child: Row(
                    children: [
                      Icon(Icons.group_add_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Add to group'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Delete contact',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
