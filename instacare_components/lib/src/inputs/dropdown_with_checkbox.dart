import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareDropdownWithCheckbox<T> extends StatefulWidget {
  final List<T> items;
  final Set<T> selectedItems;
  final ValueChanged<Set<T>> onChanged;
  final String Function(T)? itemLabel;
  final String? hint;
  final String? label;
  final bool initiallyExpanded;

  const InstaCareDropdownWithCheckbox({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.itemLabel,
    this.hint,
    this.label,
    this.initiallyExpanded = false,
  });

  @override
  State<InstaCareDropdownWithCheckbox<T>> createState() =>
      _ICDropdownWithCheckboxState<T>();
}

class _ICDropdownWithCheckboxState<T>
    extends State<InstaCareDropdownWithCheckbox<T>>
    with WidgetsBindingObserver {
  bool _expanded = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.initiallyExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_expanded) {
      _removeOverlay();
    }
  }

  @override
  void didUpdateWidget(covariant InstaCareDropdownWithCheckbox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild overlay when selectedItems change so checkboxes update
    if (_expanded && _overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _toggleDropdown() {
    if (_expanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _expanded = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _expanded = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final triggerSize = renderBox.size;
    final triggerOffset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    const maxDropdownHeight = 220.0;
    final spaceBelow =
        screenSize.height - triggerOffset.dy - triggerSize.height - 8;
    final spaceAbove = triggerOffset.dy - 8;

    final showBelow =
        spaceBelow >= maxDropdownHeight || spaceBelow >= spaceAbove;
    final availableHeight = showBelow
        ? spaceBelow.clamp(0.0, maxDropdownHeight)
        : spaceAbove.clamp(0.0, maxDropdownHeight);

    return OverlayEntry(
      builder: (context) {
        final selected = widget.selectedItems;

        return Stack(
          children: [
            // Tap-outside barrier
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),
            // Dropdown list
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: showBelow
                  ? Offset(0, triggerSize.height + 8)
                  : Offset(0, -availableHeight - 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                shadowColor: Colors.black26,
                child: Container(
                  width: triggerSize.width,
                  constraints: BoxConstraints(maxHeight: availableHeight),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary700),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isChecked = selected.contains(item);
                          final label = widget.itemLabel?.call(item) ??
                              item.toString();

                          return InkWell(
                            onTap: () {
                              final next = Set<T>.from(selected);
                              isChecked
                                  ? next.remove(item)
                                  : next.add(item);
                              widget.onChanged(next);
                            },
                            child: Container(
                              color: isChecked
                                  ? AppColors.gray200
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Checkbox(
                                      value: isChecked,
                                      onChanged: (_) {
                                        final next =
                                            Set<T>.from(selected);
                                        isChecked
                                            ? next.remove(item)
                                            : next.add(item);
                                        widget.onChanged(next);
                                      },
                                      side: const BorderSide(
                                        color: AppColors.primary700,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap,
                                      visualDensity:
                                          const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      label,
                                      style: InstaCareTypography.r
                                          .copyWith(
                                        color: AppColors.gray800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedItems;

    final selectedLabels = selected
        .map((e) => widget.itemLabel?.call(e) ?? e.toString())
        .toList();

    final String displayText;
    if (selectedLabels.isEmpty) {
      displayText = widget.hint ?? '';
    } else if (selectedLabels.length <= 2) {
      displayText = selectedLabels.join(', ');
    } else {
      displayText =
          '${selectedLabels.take(2).join(', ')} +${selectedLabels.length - 2} more';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: InstaCareTypography.r.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            key: _triggerKey,
            borderRadius: BorderRadius.circular(8),
            onTap: _toggleDropdown,
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.ivory300,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.gray600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary900,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: InstaCareTypography.r.copyWith(
                  color: selectedLabels.isNotEmpty
                      ? AppColors.gray800
                      : AppColors.gray400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
