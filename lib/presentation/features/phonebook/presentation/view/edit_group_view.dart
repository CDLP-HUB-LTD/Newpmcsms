// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/presentation/general_widgets/app_form_field.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class EditGroupView extends ConsumerStatefulWidget {
//   const EditGroupView({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _EditGroupViewState();
// }

// class _EditGroupViewState extends ConsumerState<EditGroupView> {
//   final _nameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Edit Group',
//         centerTitle: true,
//       ),
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             AppFormField(
//               label: 'Name',
//               controller: _nameController,
//             ),
//             const VerticalSpacing(40),
//           ],
//         ),
//       )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_group_request.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/edit_group_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/get_all_groups_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/app_form_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class EditGroupArgs {
  final int groupId;
  final String initialName;
  const EditGroupArgs({required this.groupId, required this.initialName});
}

class EditGroupView extends ConsumerStatefulWidget {
  static const String routeName = '/editGroupView';

  const EditGroupView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditGroupViewState();
}

class _EditGroupViewState extends ConsumerState<EditGroupView> {
  final _nameController = TextEditingController();
  late EditGroupArgs _args;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      _args = args is EditGroupArgs
          ? args
          : const EditGroupArgs(groupId: 0, initialName: '');
      _nameController.text = _args.initialName;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      editGroupNotifier.select((v) => v.state == LoadState.loading),
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Group', centerTitle: true),
      body: PageLoader(
        isLoading: isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                AppFormField(label: 'Name', controller: _nameController),
                const VerticalSpacing(40),
                AppSendButton(
                  isEnabled: !isLoading,
                  onTap: _saveGroup,
                  title: isLoading ? 'Saving...' : 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveGroup() {
    final data = EditGroupRequest(
      groupId: _args.groupId,
      groupName: _nameController.text.trim(),
    );

    ref.read(editGroupNotifier.notifier).editGroup(
          data: data,
          onError: (error) => context.showError(message: error),
          onSuccess: (message) {
            context.showSuccess(message: message);
            Navigator.pop(context);
            ref.read(getAllGroupsNotifier.notifier).getAllGroups();
          },
        );
  }
}
