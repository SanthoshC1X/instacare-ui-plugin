import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/color.dart';
import '../theme/typography.dart';

class InstaCareOtpInput extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const InstaCareOtpInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  @override
  State<InstaCareOtpInput> createState() => _ICOtpInputState();
}

class _ICOtpInputState extends State<InstaCareOtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus) {
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        }
      });
      return node;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _handleKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        _notifyChange();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _notifyChange() {
    widget.onChanged?.call(_otpValue);
    if (_otpValue.length == widget.length) {
      widget.onCompleted?.call(_otpValue);
    }
  }

 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return LayoutBuilder(
    builder: (context, constraints) {
      final availableWidth =
          constraints.maxWidth.isFinite ? constraints.maxWidth : screenWidth;

      const spacing = 8.0;
      final totalSpacing = (widget.length - 1) * spacing;

      final cellSize =
          ((availableWidth - totalSpacing - 32) / widget.length)
              .clamp(40.0, 56.0);

      final fontSize = (cellSize * 0.45).clamp(16.0, 24.0);
      final radius = (cellSize * 0.25).clamp(10.0, 14.0);

      return Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(widget.length, (index) {
            return SizedBox(
              width: cellSize,
              height: cellSize,
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) => _handleKeyEvent(index, event),
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: InstaCareTypography.h3.copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.ivory300,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide:
                          const BorderSide(color: AppColors.primary700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide:
                          const BorderSide(color: AppColors.primary700),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: const BorderSide(
                        color: AppColors.primary900,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < widget.length - 1) {
                      _focusNodes[index + 1].requestFocus();
                    }
                    _notifyChange();
                  },
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}
}