import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareMarkdown extends StatelessWidget {
  const InstaCareMarkdown({
    super.key,
    required this.data,
    this.padding,
    this.styleSheet,
    this.onTapLink,
    this.selectable = false,
    this.imageDirectory,
    this.maxImageHeight = 240,
  });

  /// Markdown content
  final String data;

  /// Outer padding
  final EdgeInsetsGeometry? padding;

  /// Optional style overrides
  final MarkdownStyleSheet? styleSheet;

  /// Link handler
  final void Function(String text, String? href, String title)? onTapLink;

  /// Enable text selection
  final bool selectable;

  /// Base directory for local images
  final String? imageDirectory;

  /// Max height for images
  final double maxImageHeight;

  // ---------------------------------------------------------------------------
  // MARKDOWN STYLES
  // ---------------------------------------------------------------------------

  MarkdownStyleSheet _buildStyle(BuildContext context) {
    final body = InstaCareTypography.body.copyWith(
      color: AppColors.gray800,
      height: 1.5,
    );

    return MarkdownStyleSheet(
      p: body,
      pPadding: const EdgeInsets.only(bottom: 8),

      h1: InstaCareTypography.h1.copyWith(color: AppColors.primary800),
      h1Padding: const EdgeInsets.only(bottom: 12),

      h2: InstaCareTypography.h2.copyWith(color: AppColors.primary800),
      h2Padding: const EdgeInsets.only(bottom: 10),

      h3: InstaCareTypography.h3.copyWith(color: AppColors.primary700),
      h3Padding: const EdgeInsets.only(bottom: 8),

      h4: InstaCareTypography.m.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.primary700,
      ),
      h4Padding: const EdgeInsets.only(bottom: 6),

      h5: InstaCareTypography.sm.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.primary700,
      ),
      h5Padding: const EdgeInsets.only(bottom: 4),

      h6: InstaCareTypography.sm.copyWith(color: AppColors.gray600),
      h6Padding: const EdgeInsets.only(bottom: 4),

      em: body.copyWith(fontStyle: FontStyle.italic),
      strong: body.copyWith(fontWeight: FontWeight.w700),
      del: body.copyWith(decoration: TextDecoration.lineThrough),

      a: InstaCareTypography.m.copyWith(
        color: AppColors.infoFg,
        decoration: TextDecoration.underline,
      ),

      code: InstaCareTypography.m.copyWith(
        color: AppColors.primary900,
        backgroundColor: AppColors.primary50,
      ),

      blockquote: body.copyWith(color: AppColors.gray600),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      blockquoteDecoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: AppColors.primary500, width: 4),
        ),
      ),

      listIndent: 26,
      listBulletPadding: const EdgeInsets.only(right: 8, top: 2),
      listBullet: body.copyWith(color: AppColors.primary800),

      checkbox: body.copyWith(color: AppColors.primary800),

      tableHead: InstaCareTypography.m.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.gray800,
      ),
      tableBody: body,
      tableBorder: TableBorder.all(color: AppColors.primary200),
      tableCellsPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      tableColumnWidth: const IntrinsicColumnWidth(),

      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary200),
      ),

      horizontalRuleDecoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.primary200, width: 1)),
      ),
    ).merge(styleSheet);
  }

  // ---------------------------------------------------------------------------
  // CUSTOM BUILDERS
  // ---------------------------------------------------------------------------

  Widget _buildImage(MarkdownImageConfig config) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        config.uri.toString(),
        height: config.height ?? maxImageHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Text(
            config.alt ?? 'Image unavailable',
            style: InstaCareTypography.s.copyWith(color: AppColors.gray600),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 2),
      child: Icon(
        value
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
        size: 18,
        color: value ? AppColors.successFg : AppColors.gray500,
      ),
    );
  }

  Widget _buildBullet(MarkdownBulletParameters params) {
    if (params.style == BulletStyle.orderedList) {
      return Text(
        '${params.index + 1}.',
        style: InstaCareTypography.m.copyWith(color: AppColors.primary800),
      );
    }

    final size = params.nestLevel == 0 ? 7.0 : 6.0;
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary600,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: MarkdownBody(
        data: data,
        selectable: selectable,
        imageDirectory: imageDirectory,
        extensionSet: md.ExtensionSet.gitHubFlavored,
        onTapLink: onTapLink,
        styleSheet: _buildStyle(context),
        sizedImageBuilder: _buildImage,
        checkboxBuilder: _buildCheckbox,
        bulletBuilder: _buildBullet,
        softLineBreak: true,
      ),
    );
  }
}