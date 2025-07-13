import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhraseInputWidget extends StatefulWidget {
  final String secretPhrase;
  final Function(String) onPhraseChanged;
  final VoidCallback? onNext;

  const PhraseInputWidget({
    super.key,
    required this.secretPhrase,
    required this.onPhraseChanged,
    this.onNext,
  });

  @override
  State<PhraseInputWidget> createState() => _PhraseInputWidgetState();
}

class _PhraseInputWidgetState extends State<PhraseInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSecurityWarning = false;

  final List<String> _commonPhrases = [
    'help me',
    'emergency',
    'call police',
    'help',
    'stop',
    'no',
  ];

  final List<Map<String, String>> _securityTips = [
    {
      'icon': 'security',
      'tip': 'Use a phrase only you would say naturally',
    },
    {
      'icon': 'volume_up',
      'tip': 'Choose something you can say clearly under stress',
    },
    {
      'icon': 'visibility_off',
      'tip': 'Avoid common words others might say accidentally',
    },
    {
      'icon': 'timer',
      'tip': 'Keep it between 5-20 characters for best recognition',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.secretPhrase;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final phrase = _controller.text.toLowerCase().trim();
    widget.onPhraseChanged(_controller.text);

    setState(() {
      _showSecurityWarning =
          _commonPhrases.any((common) => phrase.contains(common.toLowerCase()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'record_voice_over',
                      size: 12.w,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Create Your Secret Phrase',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'This phrase will activate your emergency alert when spoken',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Secret Phrase',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter your secret phrase...',
              suffixText: '${_controller.text.length}/20',
              suffixStyle: AppTheme.lightTheme.textTheme.labelSmall,
              errorText: _controller.text.length > 20
                  ? 'Phrase too long'
                  : _controller.text.isNotEmpty && _controller.text.length < 5
                      ? 'Phrase too short (minimum 5 characters)'
                      : null,
            ),
            maxLength: 20,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) {
              if (widget.onNext != null) {
                widget.onNext!();
              }
            },
          ),
          if (_showSecurityWarning) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'This phrase contains common words that might trigger accidentally. Consider using something more unique.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 4.h),
          Text(
            'Security Tips',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          ...List.generate(_securityTips.length, (index) {
            final tip = _securityTips[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: tip['icon']!,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      tip['tip']!,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
