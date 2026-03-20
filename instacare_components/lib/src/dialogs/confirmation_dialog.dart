import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

Future<bool> showInstaCareConfirmationDialog({
  required BuildContext context,
  required String title,
  required String body,
  String confirmText = 'Remove',
  String cancelText = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          // 🔹 Adaptive values
          final radius = (width * 0.04).clamp(8.0, 14.0);
          final horizontalPadding =
              (width * 0.06).clamp(16.0, 24.0);
          final verticalPadding =
              (width * 0.05).clamp(18.0, 24.0);
          final titleSize = (width * 0.055).clamp(18.0, 22.0);
          final bodySize = (width * 0.045).clamp(14.0, 16.0);
          final buttonHeight =
              (width * 0.14).clamp(46.0, 56.0);

          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding:
                EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                verticalPadding,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ───── Title ─────
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: InstaCareTypography.h2.copyWith(
                      fontSize: titleSize,
                      color: AppColors.primary800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ───── Body ─────
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: InstaCareTypography.body.copyWith(
                      fontSize: bodySize,
                      color: AppColors.gray500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ───── Actions ─────
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.gray200,
                              foregroundColor: AppColors.primary800,
                              side: const BorderSide(
                                color: AppColors.primary800,
                                width: 1.6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(radius),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pop(false),
                            child: Text(
                              cancelText,
                              style:
                                  InstaCareTypography.h3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary900,
                              foregroundColor:
                                  AppColors.baseWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(radius),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pop(true),
                            child: Text(
                              confirmText,
                              style:
                                  InstaCareTypography.h3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  return result ?? false;
}
