import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactCardWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;
  final VoidCallback onSendTest;
  final VoidCallback onDuplicate;

  const ContactCardWidget({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
    required this.onSendTest,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Dismissible(
        key: Key(contact["id"].toString()),
        background: _buildSwipeBackground(isLeft: false),
        secondaryBackground: _buildSwipeBackground(isLeft: true),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
            return false;
          } else if (direction == DismissDirection.endToStart) {
            onDelete();
            return false;
          }
          return false;
        },
        child: GestureDetector(
          onLongPress: () => _showContextMenu(context),
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: contact["isPrimary"] == true
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildAvatar(),
                SizedBox(width: 4.w),
                Expanded(child: _buildContactInfo()),
                _buildStatusIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'delete' : 'edit',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Delete' : 'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: contact["avatar"] != null
                ? CustomImageWidget(
                    imageUrl: contact["avatar"] as String,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        (contact["name"] as String).isNotEmpty
                            ? (contact["name"] as String)[0].toUpperCase()
                            : 'C',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        if (contact["isPrimary"] == true)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.cardColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'star',
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                contact["name"] as String,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (contact["isPrimary"] == true)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PRIMARY',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          contact["phone"] as String,
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getRelationshipColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contact["relationship"] as String,
                style: TextStyle(
                  color: _getRelationshipColor(),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (contact["lastVerified"] != null) ...[
              SizedBox(width: 2.w),
              Text(
                'Verified ${_getTimeAgo(contact["lastVerified"] as DateTime)}',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    final bool isVerified = contact["isVerified"] as bool;

    return Column(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: isVerified
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          isVerified ? 'Verified' : 'Unverified',
          style: TextStyle(
            color: isVerified
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.tertiary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getRelationshipColor() {
    switch (contact["relationship"] as String) {
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showContextMenu(BuildContext context) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: 'star',
              title: contact["isPrimary"] == true
                  ? 'Remove Primary'
                  : 'Set as Primary',
              onTap: () {
                Navigator.pop(context);
                onSetPrimary();
              },
            ),
            _buildContextMenuItem(
              icon: 'send',
              title: 'Send Test Alert',
              onTap: () {
                Navigator.pop(context);
                onSendTest();
              },
            ),
            _buildContextMenuItem(
              icon: 'content_copy',
              title: 'Duplicate Contact',
              onTap: () {
                Navigator.pop(context);
                onDuplicate();
              },
            ),
            _buildContextMenuItem(
              icon: 'edit',
              title: 'Edit Contact',
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            _buildContextMenuItem(
              icon: 'delete',
              title: 'Delete Contact',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
