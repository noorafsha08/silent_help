import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_contact_modal_widget.dart';
import './widgets/contact_card_widget.dart';
import './widgets/empty_state_widget.dart';

class EmergencyContactsManagement extends StatefulWidget {
  const EmergencyContactsManagement({super.key});

  @override
  State<EmergencyContactsManagement> createState() =>
      _EmergencyContactsManagementState();
}

class _EmergencyContactsManagementState
    extends State<EmergencyContactsManagement> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  // Mock data for emergency contacts
  List<Map<String, dynamic>> emergencyContacts = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "relationship": "Family",
      "isVerified": true,
      "isPrimary": true,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVerified": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "phone": "+1 (555) 987-6543",
      "relationship": "Friend",
      "isVerified": false,
      "isPrimary": false,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVerified": null,
    },
    {
      "id": 3,
      "name": "Dr. Emily Chen",
      "phone": "+1 (555) 456-7890",
      "relationship": "Colleague",
      "isVerified": true,
      "isPrimary": false,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVerified": DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Emergency Contacts',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        if (Theme.of(context).platform == TargetPlatform.iOS)
          TextButton(
            onPressed: _showAddContactModal,
            child: Text(
              'Add Contact',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshContacts,
      color: AppTheme.lightTheme.colorScheme.primary,
      child:
          emergencyContacts.isEmpty ? _buildEmptyState() : _buildContactsList(),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: EmptyStateWidget(
          onAddContact: _showAddContactModal,
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return Column(
      children: [
        if (emergencyContacts.length >= 5)
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Maximum 5 contacts reached. Upgrade to premium for unlimited contacts.',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            itemCount: emergencyContacts.length,
            itemBuilder: (context, index) {
              final contact = emergencyContacts[index];
              return ContactCardWidget(
                contact: contact,
                onEdit: () => _editContact(contact),
                onDelete: () => _deleteContact(contact),
                onSetPrimary: () => _setPrimaryContact(contact),
                onSendTest: () => _sendTestAlert(contact),
                onDuplicate: () => _duplicateContact(contact),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton() {
    if (Theme.of(context).platform == TargetPlatform.iOS) return null;

    return FloatingActionButton(
      onPressed: emergencyContacts.length >= 5 ? null : _showAddContactModal,
      backgroundColor: emergencyContacts.length >= 5
          ? AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3)
          : AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
      child: CustomIconWidget(
        iconName: 'add',
        color: emergencyContacts.length >= 5
            ? AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5)
            : AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        size: 24,
      ),
    );
  }

  Future<void> _refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate contact verification update
    for (var contact in emergencyContacts) {
      if (!(contact["isVerified"] as bool)) {
        // Randomly verify some contacts
        if (DateTime.now().millisecond % 2 == 0) {
          contact["isVerified"] = true;
          contact["lastVerified"] = DateTime.now();
        }
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contacts refreshed successfully',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
          behavior: AppTheme.lightTheme.snackBarTheme.behavior,
          shape: AppTheme.lightTheme.snackBarTheme.shape,
        ),
      );
    }
  }

  void _showAddContactModal() {
    if (emergencyContacts.length >= 5) {
      _showUpgradeDialog();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactModalWidget(
        onSave: _addContact,
        existingContacts: emergencyContacts,
      ),
    );
  }

  void _addContact(Map<String, dynamic> newContact) {
    setState(() {
      newContact["id"] = DateTime.now().millisecondsSinceEpoch;
      newContact["isVerified"] = false;
      newContact["isPrimary"] = emergencyContacts.isEmpty;
      newContact["lastVerified"] = null;
      emergencyContacts.add(newContact);
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contact added successfully',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
        behavior: AppTheme.lightTheme.snackBarTheme.behavior,
        shape: AppTheme.lightTheme.snackBarTheme.shape,
      ),
    );
  }

  void _editContact(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactModalWidget(
        contact: contact,
        onSave: (updatedContact) {
          setState(() {
            final index =
                emergencyContacts.indexWhere((c) => c["id"] == contact["id"]);
            if (index != -1) {
              emergencyContacts[index] = {...contact, ...updatedContact};
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Contact updated successfully',
                style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
              ),
              backgroundColor:
                  AppTheme.lightTheme.snackBarTheme.backgroundColor,
              behavior: AppTheme.lightTheme.snackBarTheme.behavior,
              shape: AppTheme.lightTheme.snackBarTheme.shape,
            ),
          );
        },
        existingContacts:
            emergencyContacts.where((c) => c["id"] != contact["id"]).toList(),
      ),
    );
  }

  void _deleteContact(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Delete Contact',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${contact["name"]}? This action cannot be undone.',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                emergencyContacts.removeWhere((c) => c["id"] == contact["id"]);

                // If deleted contact was primary, set first contact as primary
                if (contact["isPrimary"] == true &&
                    emergencyContacts.isNotEmpty) {
                  emergencyContacts[0]["isPrimary"] = true;
                }
              });

              HapticFeedback.lightImpact();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Contact deleted successfully',
                    style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
                  ),
                  backgroundColor:
                      AppTheme.lightTheme.snackBarTheme.backgroundColor,
                  behavior: AppTheme.lightTheme.snackBarTheme.behavior,
                  shape: AppTheme.lightTheme.snackBarTheme.shape,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setPrimaryContact(Map<String, dynamic> contact) {
    setState(() {
      // Remove primary status from all contacts
      for (var c in emergencyContacts) {
        c["isPrimary"] = false;
      }
      // Set selected contact as primary
      contact["isPrimary"] = true;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${contact["name"]} set as primary contact',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
        behavior: AppTheme.lightTheme.snackBarTheme.behavior,
        shape: AppTheme.lightTheme.snackBarTheme.shape,
      ),
    );
  }

  void _sendTestAlert(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Send Test Alert',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Send a test emergency alert to ${contact["name"]} at ${contact["phone"]}?',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              // Simulate sending test alert
              setState(() {
                contact["isVerified"] = true;
                contact["lastVerified"] = DateTime.now();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Test alert sent to ${contact["name"]}',
                    style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
                  ),
                  backgroundColor:
                      AppTheme.lightTheme.snackBarTheme.backgroundColor,
                  behavior: AppTheme.lightTheme.snackBarTheme.behavior,
                  shape: AppTheme.lightTheme.snackBarTheme.shape,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            child: Text(
              'Send',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _duplicateContact(Map<String, dynamic> contact) {
    if (emergencyContacts.length >= 5) {
      _showUpgradeDialog();
      return;
    }

    final duplicatedContact = Map<String, dynamic>.from(contact);
    duplicatedContact["id"] = DateTime.now().millisecondsSinceEpoch;
    duplicatedContact["name"] = "${contact["name"]} (Copy)";
    duplicatedContact["isPrimary"] = false;
    duplicatedContact["isVerified"] = false;
    duplicatedContact["lastVerified"] = null;

    setState(() {
      emergencyContacts.add(duplicatedContact);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contact duplicated successfully',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
        behavior: AppTheme.lightTheme.snackBarTheme.behavior,
        shape: AppTheme.lightTheme.snackBarTheme.shape,
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Upgrade to Premium',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You\'ve reached the maximum of 5 emergency contacts. Upgrade to premium for unlimited contacts and additional features.',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to premium upgrade screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            child: Text(
              'Upgrade Now',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
