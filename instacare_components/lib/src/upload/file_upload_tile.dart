import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareFileUploadTile extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  const InstaCareFileUploadTile({
    super.key,
    required this.onTap,
    this.title = 'Click to upload files',
    this.subtitle = 'PDF, PNG, JPEG OR JPG (Max 10 MB)',
  });

  @override
  State<InstaCareFileUploadTile> createState() =>
      _InstaCareFileUploadTileState();
}

class _InstaCareFileUploadTileState extends State<InstaCareFileUploadTile> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: widget.onTap,
      onHighlightChanged: (value) => setState(() => _active = value),
      onHover: (value) => setState(() => _active = value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: _active ? AppColors.primary900 : AppColors.primary700),
        ),
        child: Column(
          children: [
            Icon(Icons.upload_file,
                size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style:
                  InstaCareTypography.r.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: InstaCareTypography.r.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
