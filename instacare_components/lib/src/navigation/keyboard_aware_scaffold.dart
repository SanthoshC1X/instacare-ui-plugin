import 'package:flutter/material.dart';

/// A scaffold that automatically handles keyboard visibility:
/// - Wraps body in [SingleChildScrollView] so content scrolls when keyboard appears
/// - Dismisses keyboard on tap outside input fields
/// - Ensures text fields are never hidden behind the keyboard
/// - Maintains [SafeArea] by default
///
/// Use this as a drop-in replacement for [Scaffold] on any screen with text inputs.
class KeyboardAwareScaffold extends StatelessWidget {
  /// The main content of the scaffold.
  final Widget body;

  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// App bar widget.
  final PreferredSizeWidget? appBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// A persistent bottom sheet (e.g., fixed button at the bottom).
  final Widget? bottomSheet;

  /// Padding applied to the scrollable body content.
  final EdgeInsetsGeometry? padding;

  /// Whether to wrap in [SafeArea]. Defaults to true.
  final bool useSafeArea;

  /// Whether the body should be scrollable. Defaults to true.
  /// Set to false if your body already handles its own scrolling (e.g., ListView).
  final bool scrollable;

  /// Whether tapping outside an input field should dismiss the keyboard.
  /// Defaults to true.
  final bool dismissKeyboardOnTap;

  /// Custom scroll physics for the scroll view.
  final ScrollPhysics? physics;

  /// Optional scroll controller.
  final ScrollController? scrollController;

  /// Extra bottom padding added below the content to ensure the last field
  /// is not stuck right above the keyboard. Defaults to 24.
  final double extraBottomPadding;

  const KeyboardAwareScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.padding,
    this.useSafeArea = true,
    this.scrollable = true,
    this.dismissKeyboardOnTap = true,
    this.physics,
    this.scrollController,
    this.extraBottomPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // Wrap in scrollable view
    if (scrollable) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        padding: padding,
        keyboardDismissBehavior: dismissKeyboardOnTap
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
            // Extra padding so last input isn't flush with keyboard
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0
                  ? extraBottomPadding
                  : 0,
            ),
          ],
        ),
      );
    } else if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Wrap in SafeArea
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    // Wrap in GestureDetector for tap-to-dismiss keyboard
    if (dismissKeyboardOnTap) {
      content = GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      body: content,
    );
  }
}
