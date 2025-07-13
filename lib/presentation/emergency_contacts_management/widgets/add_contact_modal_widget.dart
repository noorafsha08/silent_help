import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddContactModalWidget extends StatefulWidget {
  final Map<String, dynamic>? contact;
  final Function(Map<String, dynamic>) onSave;
  final List<Map<String, dynamic>> existingContacts;

  const AddContactModalWidget({
    super.key,
    this.contact,
    required this.onSave,
    required this.existingContacts,
  });

  @override
  State<AddContactModalWidget> createState() => _AddContactModalWidgetState();
}

class _AddContactModalWidgetState extends State<AddContactModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRelationship = 'Family';
  bool _isLoading = false;
  String? _nameError;
  String? _phoneError;

  final List<String> _relationships = [
    'Family',
    'Friend',
    'Colleague',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!["name"] as String;
      _phoneController.text = widget.contact!["phone"] as String;
      _selectedRelationship = widget.contact!["relationship"] as String;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),
                    _buildNameField(),
                    SizedBox(height: 3.h),
                    _buildPhoneField(),
                    SizedBox(height: 3.h),
                    _buildRelationshipField(),
                    SizedBox(height: 4.h),
                    _buildTestMessageButton(),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.contact != null ? 'Edit Contact' : 'Add Contact',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _isLoading ? null : _saveContact,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter contact name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
                size: 20,
              ),
            ),
            errorText: _nameError,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (value) {
            if (_nameError != null) {
              setState(() {
                _nameError = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Phone Number',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _pickFromContacts,
              icon: CustomIconWidget(
                iconName: 'contacts',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text(
                'Pick from Contacts',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: '+1 (555) 123-4567',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
                size: 20,
              ),
            ),
            errorText: _phoneError,
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\)\s]')),
          ],
          onChanged: (value) {
            if (_phoneError != null) {
              setState(() {
                _phoneError = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildRelationshipField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRelationship,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
                size: 24,
              ),
              items: _relationships.map((String relationship) {
                return DropdownMenuItem<String>(
                  value: relationship,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getRelationshipIcon(relationship),
                        color: _getRelationshipColor(relationship),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        relationship,
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRelationship = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestMessageButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _sendTestMessage,
        icon: CustomIconWidget(
          iconName: 'send',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        label: Text(
          'Send Test Message',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveContact,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      widget.contact != null ? 'Update Contact' : 'Add Contact',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRelationshipIcon(String relationship) {
    switch (relationship) {
      case 'Family':
        return 'family_restroom';
      case 'Friend':
        return 'people';
      case 'Colleague':
        return 'work';
      default:
        return 'person';
    }
  }

  Color _getRelationshipColor(String relationship) {
    switch (relationship) {
      case 'Family':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Friend':
        return const Color(0xFF27AE60);
      case 'Colleague':
        return const Color(0xFFF39C12);
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  void _pickFromContacts() {
    // Simulate contact picker
    final mockContacts = [
      {"name": "John Smith", "phone": "+1 (555) 234-5678"},
      {"name": "Emma Wilson", "phone": "+1 (555) 345-6789"},
      {"name": "David Brown", "phone": "+1 (555) 456-7890"},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Select Contact',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mockContacts.length,
                itemBuilder: (context, index) {
                  final contact = mockContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      child: Text(
                        (contact["name"] as String)[0],
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(
                      contact["name"] as String,
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      contact["phone"] as String,
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _nameController.text = contact["name"] as String;
                        _phoneController.text = contact["phone"] as String;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendTestMessage() {
    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Please enter a phone number first';
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Test Message',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Send a test message to ${_phoneController.text} to verify the number?',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Test message sent to ${_phoneController.text}',
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

  void _saveContact() {
    setState(() {
      _nameError = null;
      _phoneError = null;
    });

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      return;
    }

    // Validate phone
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _phoneError = 'Phone number is required';
      });
      return;
    }

    // Check for duplicate phone numbers
    final existingPhone = widget.existingContacts
        .any((contact) => contact["phone"] == _phoneController.text.trim());

    if (existingPhone) {
      setState(() {
        _phoneError = 'This phone number already exists';
      });
      return;
    }

    // Validate phone format (basic validation)
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(_phoneController.text.trim())) {
      setState(() {
        _phoneError = 'Please enter a valid phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate save delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final contactData = {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "relationship": _selectedRelationship,
        "avatar": null, // Will be generated based on name
      };

      widget.onSave(contactData);
      Navigator.pop(context);
    });
  }
}
