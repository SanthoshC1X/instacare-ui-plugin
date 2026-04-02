import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showText;
  final double? fontSize;

  const InstaCareLogo({
    super.key,
    this.size = 20.0,
    this.color,
    this.showText = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primary200;

    final double logoHeight = size;
    final double logoWidth = size * (22.22 / 20.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'lib/src/assets_patient/logo.svg',
          package: 'instacare_components',
          width: logoWidth,
          height: logoHeight,
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
        ),
        if (showText) ...[
          const SizedBox(width: 14.78),
          Text(
            'InstaCare',
            style: InstaCareTypography.h2.copyWith(
              color: logoColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ],
    );
  }
}

class InstaCareLogoIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const InstaCareLogoIcon({
    super.key,
    this.size = 20.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primary300;
    final double logoHeight = size;
    final double logoWidth = size * (22.22 / 20.0);

    return SvgPicture.asset(
      'lib/src/assets_patient/logo.svg',
      package: 'instacare_components',
      width: logoWidth,
      height: logoHeight,
      colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
    );
  }
}

class InstaCareLogoText extends StatelessWidget {
  final double? fontSize;
  final Color? color;

  const InstaCareLogoText({
    super.key,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.primary300;

    return Text(
      'InstaCare',
      style: InstaCareTypography.h2.copyWith(
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}
