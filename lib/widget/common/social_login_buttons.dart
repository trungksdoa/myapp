import 'package:flutter/material.dart';
import 'package:myapp/widget/index.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final bool enabled;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: enabled ? onGooglePressed : null,
                icon: Icon(
                  Icons.g_mobiledata,
                  color: enabled ? Colors.red : Colors.grey,
                ),
                label: CustomText.body(text: 'Google'),
                style: OutlinedButton.styleFrom(
                  padding: AppPadding.verticalMD,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: enabled
                        ? Colors.grey.shade300
                        : Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalLG,
            Expanded(
              child: OutlinedButton.icon(
                onPressed: enabled ? onFacebookPressed : null,
                icon: Icon(
                  Icons.facebook,
                  color: enabled ? Colors.blue : Colors.grey,
                ),
                label: CustomText.body(text: 'Facebook'),
                style: OutlinedButton.styleFrom(
                  padding: AppPadding.verticalMD,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: enabled
                        ? Colors.grey.shade300
                        : Colors.grey.shade200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
