# InstaCare UI Components Plugin - Complete Documentation & Audit Report

**Version:** 1.1.1
**Total Widgets:** 55 exports (40+ unique widgets)
**Total Dart Code:** ~6,400 lines across 45 files
**Flutter SDK:** >=3.22.0 | Dart SDK: >=3.0.0 <4.0.0

---

## Table of Contents

1. [Current State Assessment](#1-current-state-assessment)
2. [Code Quality Audit](#2-code-quality-audit)
3. [Issues Found & Optimization Recommendations](#3-issues-found--optimization-recommendations)
4. [Widget Catalog](#4-widget-catalog)
5. [Theme System (Colors, Typography, Sizing)](#5-theme-system)
6. [Customizability Reference](#6-customizability-reference)
7. [Package Alternatives Analysis](#7-package-alternatives-analysis)
8. [Dependency Analysis](#8-dependency-analysis)

---

## 1. Current State Assessment

### Overall Rating: 8.5/10

**Strengths:**
- Well-organized folder structure by widget category (buttons, cards, inputs, etc.)
- Consistent naming convention (`InstaCare` prefix)
- Good use of `const` constructors throughout
- Comprehensive color system with semantic tokens
- Custom painters for unique visual identity (leaf patterns, dot textures)
- Generic type support in Dropdown/RadioButtons
- Proper disposal of controllers, focus nodes, and gesture recognizers
- LayoutBuilder used for responsive scaling
- Clean separation of theme tokens from widget code
- Shared `InstaCareInputTheme` eliminates InputDecoration duplication across all input widgets
- Shared `InstaCareFeedbackType` enum unifies feedback/message type enums
- Shared painter classes (`DotTexturePainter`, `LeafPainter`, `LeafBranchPainter`) in `common/painters.dart`
- `InstaCareButton` supports primary, secondary, and danger variants via named constructors
- Strict `analysis_options.yaml` with custom linter rules
- All CustomPainters have `shouldRebuildSemantics => false` for decorative painters
- Decorative `CustomPaint` widgets wrapped with `ExcludeSemantics` for Flutter 3.22+ compatibility

**Weaknesses:**
- Zero unit tests (test files are boilerplate only)
- No widget-level documentation (dartdoc)
- Some inconsistent border radius values across widgets
- No `const` on some widgets that could be `const`

---

## 2. Code Quality Audit

### 2.1 GOOD Practices Found

| Practice | Files | Notes |
|----------|-------|-------|
| `const` constructors | All widgets | Proper use throughout |
| Private constructor for utility classes | `AppColors._()`, `InstaCareTypography._()`, `InstaCareInputTheme._()` | Prevents instantiation |
| Named constructors | `InstaCareButton.secondary`, `InstaCareButton.danger`, `InstaCareTextField.password` | Clean API |
| `WidgetStateProperty` (not deprecated `MaterialStateProperty`) | `button.dart` | Up-to-date API |
| Proper `dispose()` | Carousel, OTP, Dropdown, Stepper, ConsentCheckbox | Controllers/nodes/recognizers cleaned up |
| `WidgetsBindingObserver` | Dropdown, DropdownWithCheckbox | Closes overlay on metrics change |
| `shouldRepaint()` optimization | All CustomPainters | Avoids unnecessary repaints |
| `Clip.antiAlias` | Cards, ServiceCategoryGrid | Smooth rounded corners |
| Responsive scaling with `LayoutBuilder` | Buttons, ServiceCard, Stepper, OTP | Adapts to container size |
| `.clamp()` for sizing | Throughout | Safe responsive values |
| Shared InputDecoration theme | `InstaCareInputTheme.decoration()` | Single source of truth for input styling |
| Shared feedback type enum | `InstaCareFeedbackType` | Unified enum for snackbar, message box |
| Shared painters | `common/painters.dart` | `DotTexturePainter`, `LeafPainter`, `LeafBranchPainter` extracted and reused |
| Configurable validation messages | `phone_input.dart` | `requiredMessage` and `lengthMessage` params |
| `shouldRebuildSemantics => false` | All CustomPainters | Prevents unnecessary semantics rebuilds for decorative painters |
| `ExcludeSemantics` on decorative CustomPaint | service_card, service_category_grid, signature_pad, patient_partner_connect | Flutter 3.22+ compatibility, avoids `hitTestTransform` crash |
| Proper `TapGestureRecognizer` lifecycle | `consent_checkbox.dart` | StatefulWidget with dispose |

### 2.2 Resolved Issues

All issues from the previous audit have been fixed:

| Issue | Status | Resolution |
|-------|--------|------------|
| **Duplicated `_DotTexturePainter`** | Fixed | Extracted to shared `common/painters.dart` as `DotTexturePainter` |
| **Duplicated `_LeafPainter`** | Fixed | Extracted to shared `common/painters.dart` as `LeafPainter` and `LeafBranchPainter` |
| **Duplicated Snackbar/MessageBox enums** | Fixed | Unified into `InstaCareFeedbackType` in `types/feedback_type.dart`; old names kept as deprecated typedefs |
| **Duplicated InputDecoration** | Fixed | Shared `InstaCareInputTheme.decoration()` in `theme/input_theme.dart` used by all 7 input files |
| **`InstaCareDangerButton` duplicates `InstaCareButton`** | Fixed | Added `InstaCareButton.danger()` variant; `InstaCareDangerButton` now delegates to it |
| **FocusNode leak in OTP** | Fixed | Separate `_keyListenerNodes` list created and disposed properly |
| **`Padding(padding: EdgeInsets.all(0))`** | Fixed | Removed unnecessary Padding wrapper in `booking_card.dart` |
| **Plugin registration for pure Dart package** | Fixed | Removed `plugin:` section from `pubspec.yaml` |
| **Typo: `assessts_patient`** | Fixed | Renamed to `assets_patient` in directory, pubspec.yaml, logo.dart, and example |
| **`TapGestureRecognizer` not disposed** | Fixed | `consent_checkbox.dart` converted to StatefulWidget with proper disposal |
| **Hardcoded validation message** | Fixed | Added `requiredMessage` and `lengthMessage` params to `InstaCarePhoneInput` |
| **Typography `p` and `r` are identical** | Fixed | `p` is now an alias (`static final TextStyle p = r`) |
| **`height: 1.0` on all text styles** | Fixed | Removed forced `height: 1.0`; Flutter now uses natural font line height |
| **Emoji in code comments** | Fixed | Removed from `attempts_card.dart` and `card_list_view.dart` |
| **Comments like `// FIX`** | Fixed | Removed from `card_list_view.dart` |
| **No `analysis_options.yaml` rules** | Fixed | Added strict linter rules (25+ rules) |
| **Flutter 3.22+ semantics `hitTestTransform` crash** | Fixed | All CustomPainters have `shouldRebuildSemantics => false`; all decorative `CustomPaint` wrapped with `ExcludeSemantics` |
| **Flutter SDK constraint too low** | Fixed | Updated from `>=3.16.0` to `>=3.22.0` to match semantics API requirements |

### 2.3 Remaining Issues

| Issue | Severity | Files | Description |
|-------|----------|-------|-------------|
| **No unit tests** | Medium | `test/` | Only boilerplate test file exists |
| **No dartdoc comments** | Low | Public APIs | Missing documentation comments on public members |

### 2.4 HEAVY / Performance Concerns

| Widget | Weight | Reason |
|--------|--------|--------|
| `InstaCareServiceCard` | Heavy | CustomPaint with nested loop (dot grid) + leaf painter on every frame |
| `InstaCareServiceCategoryGrid` | Heavy | Same painters (now shared) + shrinkWrap GridView |
| `InstaCareCarousel` | Medium | `Future.delayed` recursion for auto-play (no Timer, can't cancel cleanly) |
| `InstaCareSignaturePad` | Heavy | `shouldRepaint` always returns `true`, repaints every frame during drawing |
| `InstaCareDropdown` / `DropdownWithCheckbox` | Medium | Overlay-based approach is correct but creates `OverlayEntry` on every open |
| `InstaCareOtpInput` | Medium | Creates N `TextEditingController` + 2N `FocusNode` (all properly disposed) |
| `InstaCareVerticalStepper` | Medium | Creates N `AnimationController` instances |

### 2.5 LIGHTWEIGHT / Well-Optimized

| Widget | Notes |
|--------|-------|
| `InstaCarePillChip` | Simple stateless, minimal tree |
| `InstaCareCheckboxField` | Thin wrapper, effective |
| `InstaCareProgressBar` | Uses built-in `LinearProgressIndicator` |
| `InstaCareRatingScale` | Simple icon row |
| `InstaCareStatusBadge` | Minimal container + text |
| `InstaCareHoursSummaryPill` | Theme-aware, minimal |
| `InstaCareFilterPills` | Thin composition over PillChip |
| `InstaCareServicePills` | Thin composition over PillChip |
| `InstaCareMessageBox` | Simple stateless container |
| `InstaCareSearchBar` | Thin wrapper over TextField |
| `KeyboardAwareScaffold` | Smart utility, minimal overhead |

---

## 3. Issues Found & Optimization Recommendations

### All Critical Fixes - COMPLETED

1. **Shared `InputDecoration` helper** - Created `InstaCareInputTheme.decoration()` in `theme/input_theme.dart`. All 7 input widgets now use it.

2. **Merged `InstaCareDangerButton` into `InstaCareButton`** - Added `.danger()` named constructor. `InstaCareDangerButton` kept as backward-compatible delegate.

3. **Extracted shared painters** - Moved to `common/painters.dart` as public classes: `DotTexturePainter`, `LeafPainter`, `LeafBranchPainter`.

4. **Unified message type enums** - Created `InstaCareFeedbackType { info, error, pending, success }` in `types/feedback_type.dart`. Old `InstaCareSnackbarType` and `InstaCareMessageType` kept as deprecated typedefs.

5. **Fixed FocusNode leak in OTP** - Created separate `_keyListenerNodes` list with proper disposal in `dispose()`.

6. **Fixed TapGestureRecognizer leak in ConsentCheckbox** - Converted to `StatefulWidget` with proper recognizer lifecycle management.

7. **Removed plugin registration** - Removed `plugin:` section from `pubspec.yaml`. Package is now correctly a pure Dart package.

8. **Fixed `assessts_patient` typo** - Renamed to `assets_patient` everywhere.

9. **Fixed typography issues** - Removed duplicate `p`/`r` (now alias), removed forced `height: 1.0` from all styles.

10. **Made phone validation configurable** - Added `requiredMessage` and `lengthMessage` params.

11. **Cleaned up comments** - Removed emoji and `// FIX` comments.

12. **Added strict analysis rules** - 25+ linter rules in `analysis_options.yaml`.

13. **Fixed Flutter 3.22+ semantics compatibility** - Added `shouldRebuildSemantics => false` to all CustomPainters. Wrapped all decorative `CustomPaint` widgets with `ExcludeSemantics` to prevent `hitTestTransform` crash.

14. **Updated Flutter SDK constraint** - Bumped minimum from `>=3.16.0` to `>=3.22.0`.

### Remaining Optimization Recommendations

1. **Carousel auto-play**: Replace `Future.delayed` recursion with a `Timer.periodic` that can be cancelled properly.

2. **SignaturePainter**: Implement proper `shouldRepaint` comparison instead of always returning `true`.

3. **Add unit tests**: At least test the theme constants, button states, and form validators.

4. **Add dartdoc comments**: Document all public APIs for generated API docs.

---

## 4. Widget Catalog

### 4.1 Buttons (2 widgets, 3 variants)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareButton` | `buttons/button.dart` | StatelessWidget | Primary variant (default) |
| `InstaCareButton.secondary` | `buttons/button.dart` | StatelessWidget | Outlined secondary variant |
| `InstaCareButton.danger` | `buttons/button.dart` | StatelessWidget | Red danger/destructive action variant |
| `InstaCareDangerButton` | `buttons/danger_button.dart` | StatelessWidget | Backward-compatible delegate to `InstaCareButton.danger` |

**Properties:**
- `text` (required String)
- `onPressed` (VoidCallback?)
- `isLoading` (bool, default: false) - Shows skeleton shimmer
- `size` (ButtonSize, default: medium) - small(40h), medium(48h), large(56h)
- `icon` (IconData?)
- `fullWidth` (bool, default: false)
- `isDisabled` (bool, default: false)

### 4.2 Input Widgets (10 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareTextField` | `inputs/text_field.dart` | StatefulWidget | Text input with label, hint, validation, password toggle |
| `InstaCareTextField.password` | `inputs/text_field.dart` | StatefulWidget | Pre-configured password variant |
| `InstaCarePhoneInput` | `inputs/phone_input.dart` | StatelessWidget | Phone input with country flag & code |
| `InstaCareOtpInput` | `inputs/otp_input.dart` | StatefulWidget | N-digit OTP entry (default: 6) |
| `InstaCareDropdown<T>` | `inputs/dropdown.dart` | StatefulWidget | Generic overlay-based dropdown |
| `InstaCareDropdownWithCheckbox<T>` | `inputs/dropdown_with_checkbox.dart` | StatefulWidget | Multi-select dropdown with checkboxes |
| `InstaCareSearchBar` | `inputs/search_bar.dart` | StatelessWidget | Search input with icon |
| `InstaCareDatePickerField` | `inputs/date_picker_field.dart` | StatelessWidget | Date picker trigger field |
| `InstaCareCheckboxField` | `inputs/checkbox_field.dart` | StatelessWidget | Labeled checkbox |
| `InstaCareConsentCheckbox` | `inputs/consent_checkbox.dart` | StatefulWidget | Checkbox with rich text (link support, proper recognizer disposal) |
| `InstaCareSignaturePad` | `inputs/signature_pad.dart` | StatefulWidget | Tap-to-open signature drawing pad |

### 4.3 Card Widgets (10 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareCard` | `cards/card.dart` | StatelessWidget | Base card container |
| `InstaCareBookingCard` | `cards/booking_card.dart` | StatelessWidget | Patient booking info card |
| `InstaCareCheckboxCard` | `cards/checkbox_card.dart` | StatelessWidget | Selectable card with checkbox |
| `InstaCareAttemptsCard` | `cards/attempts_card.dart` | StatelessWidget | Assessment attempts tracker (3 states) |
| `InstaCareIncomeTile` | `cards/income_tile.dart` | StatelessWidget | Income display with redeem button |
| `InstaCareServiceCard` | `cards/service_card.dart` | StatelessWidget | Service card with decorative leaf pattern |
| `InstaCareServiceCategoryGrid` | `cards/service_category_grid.dart` | StatelessWidget | 2-column grid of service categories |
| `InstaCareServiceListTile` | `cards/service_list_tile.dart` | StatelessWidget | Service items list with images |
| `InstaCareCardListView` | `cards/card_list_view.dart` | StatelessWidget | Card + title/body list layout |
| `InstaCarePatientPartnerConnect` | `cards/patient_partner_connect.dart` | StatelessWidget | Patient-partner connection visualizer |

### 4.4 Navigation Widgets (4 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareBottomAppNavBar` | `navigation/bottom_app_nav_bar.dart` | StatelessWidget | Bottom navigation bar |
| `InstaCareTopHeaderTitle` | `navigation/top_header_title.dart` | StatelessWidget | AppBar header (implements PreferredSizeWidget) |
| `InstaCareWelcomeHeader` | `navigation/welcome_header.dart` | StatelessWidget | User greeting with search |
| `KeyboardAwareScaffold` | `navigation/keyboard_aware_scaffold.dart` | StatelessWidget | Scaffold with keyboard handling |

### 4.5 Selection Widgets (6 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCarePillChip` | `selection/pill_chip.dart` | StatelessWidget | Single toggle pill |
| `InstaCareFilterPills` | `selection/filter_pills.dart` | StatelessWidget | Multi-select filter pills |
| `InstaCareServicePills` | `selection/service_pills.dart` | StatelessWidget | Single-select service pills |
| `InstaCareRadioButtons<T>` | `selection/radio_buttons.dart` | StatelessWidget | Radio option group |
| `InstaCareRatingScale` | `selection/rating_scale.dart` | StatelessWidget | 1-5 star rating |
| `InstaCareMcqOptionSelector` | `selection/mcq_option_selector.dart` | StatelessWidget | MCQ with prev/next buttons |

### 4.6 Feedback & Dialog Widgets (4 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareSnackbar.show()` | `dialogs/snackbar.dart` | Static method | Animated top notification (4 types via `InstaCareFeedbackType`) |
| `showInstaCareConfirmationDialog()` | `dialogs/confirmation_dialog.dart` | Function | Confirmation popup dialog |
| `InstaCareMessageBox` | `feedback/message_box.dart` | StatelessWidget | Inline message with icon (4 types via `InstaCareFeedbackType`) |
| `InstaCareProgressBar` | `feedback/progress_bar.dart` | StatelessWidget | Linear progress with percentage |

### 4.7 Animation Widgets (3 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareSkeletonLoading` | `animation/skeleton_loading.dart` | StatefulWidget | Shimmer placeholder |
| `InstaCareCarousel` | `animation/carousel.dart` | StatefulWidget | Auto-play image carousel with indicators |
| `InstaCareMarkdown` | `animation/markdown.dart` | StatelessWidget | Styled markdown renderer |

### 4.8 Status & Badge Widgets (3 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareStatusBadge` | `badges/status_badge.dart` | StatelessWidget | Enum-based status badge |
| `InstaCareHoursSummaryPill` | `pills/hours_summary_pill.dart` | StatelessWidget | Themed text pill |
| `InstaCareAppointmentStatusPills` | `pills/appointment_status_pills.dart` | StatelessWidget | Status badge selection row |

### 4.9 Other Widgets (5 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareVerticalStepper` | `steps/stepper.dart` | StatefulWidget | Animated step indicator |
| `InstaCareFileUploadTile` | `upload/file_upload_tile.dart` | StatefulWidget | Upload area with hover state |
| `InstaCareLogo` | `common/logo.dart` | StatelessWidget | SVG logo + text |
| `InstaCareLogoIcon` | `common/logo.dart` | StatelessWidget | SVG logo only |
| `InstaCareLogoText` | `common/logo.dart` | StatelessWidget | Text only |
| `InstaCareNetworkImage` | `common/network_image.dart` | StatelessWidget | Image loader with shimmer/error |

### 4.10 Theme, Types & Utility (7 exports)

| Export | File | Description |
|--------|------|-------------|
| `AppColors` | `theme/color.dart` | Full color palette (90+ constants) |
| `InstaCareTypography` | `theme/typography.dart` | Text styles (h1-h5, p/body/r, m, s, sm, xs) |
| `InstaCareInputTheme` | `theme/input_theme.dart` | Shared InputDecoration factory for all input widgets |
| `InstaCareHeading` | `theme/heading.dart` | Header helper widgets |
| `ButtonSize` | `types/button_size.dart` | Enum: small, medium, large |
| `InstaCareFeedbackType` | `types/feedback_type.dart` | Enum: info, error, pending, success |
| `DotTexturePainter` / `LeafPainter` / `LeafBranchPainter` | `common/painters.dart` | Shared decorative painters |

---

## 5. Theme System

### 5.1 Color Palette

| Category | Shades | Base Color | Usage |
|----------|--------|------------|-------|
| **Primary** | 50-900 | `#34513A` (Dark Green) | Main brand, buttons, borders |
| **Secondary** | 50-900 | `#DC9251` (Orange) | Accents, secondary actions |
| **Natural** | 50-900 | `#A58E74` (Brown) | Earthy backgrounds |
| **Ivory** | 50-900 | `#FFEFCD` (Warm Cream) | Input fill colors, warm backgrounds |
| **Gray** | 50-900 | `#000000-#F8F8F8` | Text, borders, disabled states |
| **Error** | 50-900 | `#FB0000` (Red) | Error states, destructive actions |
| **Success** | 50-900 | `#00C400` (Green) | Success feedback |
| **Semantic** | info/warning/error/success/completed | Various | Background + foreground pairs |
| **Service Card** | 4 colors | `#6F8572` | Card-specific defaults |

**All colors are `static const` and NOT changeable at runtime.** To override, consuming apps must pass color parameters to individual widgets.

### 5.2 Typography

| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| `h1` | Crimson Pro | 24 | SemiBold (600) | Page titles |
| `h2` | Crimson Pro | 20 | Medium (500) | Section titles |
| `h3` | Crimson Pro | 18 | Medium (500) | Section inner titles |
| `h4` | Crimson Pro | 14 | SemiBold (600) | Small titles |
| `h5` | Figtree | 20 | Medium (500) | Alternate heading |
| `r` | Figtree | 14 | Regular (400) | Body/one-liner regular |
| `p`/`body` | (alias for `r`) | 14 | Regular (400) | Body text aliases |
| `m` | Figtree | 14 | Medium (500) | One-liner medium |
| `s` | Figtree | 12 | Regular (400) | Small regular |
| `sm` | Figtree | 12 | Medium (500) | Small medium |
| `xs` | Figtree | 10 | Medium (500) | Extra small |

**Notes:**
- `p` and `body` are aliases for `r` (no duplication)
- No forced `height` value - Flutter uses the font's natural line height for proper multiline rendering
- Typography is `static final` via `google_fonts`. NOT changeable at runtime unless you use `.copyWith()` on individual widgets.

### 5.3 Input Theme

All input widgets share a common decoration via `InstaCareInputTheme.decoration()`:

| Property | Default Value | Overridable? |
|----------|--------------|--------------|
| Fill color | `AppColors.ivory300` | Yes (via `fillColor` param) |
| Border color | `AppColors.primary700` | Yes (via `borderColor` param) |
| Focused border color | `AppColors.primary900` | Yes (via `focusedBorderColor` param) |
| Error border color | `AppColors.error700` | No (consistent error styling) |
| Border radius | `8.0` | Yes (via `radius` param) |
| Content padding | `h:16, v:14` | No (consistent spacing) |

### 5.4 Standard Sizing

| Element | Size | Changeable? |
|---------|------|-------------|
| Button small | height: 40 | Via `ButtonSize` enum |
| Button medium | height: 48 | Via `ButtonSize` enum |
| Button large | height: 56 | Via `ButtonSize` enum |
| Input field padding | h:16, v:14 | No (via `InstaCareInputTheme`) |
| Input border radius | 8 | Yes (TextField via `borderRadius`, InputTheme via `radius`) |
| Card border radius | 12 | No (hardcoded) |
| Pill border radius | 999 | No (hardcoded) |
| Status badge padding | h:12, v:7 | No (hardcoded) |
| Bottom nav bar | kToolbarHeight | No (system default) |
| Signature pad height | 250 (default) | Yes (via `height` param) |
| Carousel height | 200 (default) | Yes (via `height` param) |
| OTP cell size | 40-56 (responsive) | No (auto-calculated) |
| Stepper circle | 26-38 (responsive) | No (auto-calculated) |

---

## 6. Customizability Reference

### What CAN be changed when using these widgets:

| Widget | Customizable Properties |
|--------|------------------------|
| `InstaCareButton` | text, size, icon, fullWidth, isLoading, isDisabled; variant via constructor (primary/secondary/danger) |
| `InstaCareTextField` | label, hint, fillColor, borderColor, focusedBorderColor, hintColor, labelColor, borderRadius, errorText, validator, prefixIcon, suffixIcon |
| `InstaCarePhoneInput` | countryCode, countryIsoCode, maxDigits, errorText, validator, requiredMessage, lengthMessage |
| `InstaCareDropdown` | label, hint, items, itemLabel, initiallyExpanded |
| `InstaCareCard` | backgroundColor, elevation, padding, onTap |
| `InstaCareServiceCard` | backgroundColor, titleColor, bodyColor, accentColor |
| `InstaCareCheckboxCard` | backgroundColor, selectedBackgroundColor, borderColor, selectedBorderColor |
| `InstaCareBottomAppNavBar` | backgroundColor, selectedItemColor, unselectedItemColor, topBorderColor, showShadow |
| `InstaCareCarousel` | height, autoPlayDuration, autoPlay, showIndicators, indicatorActiveColor, indicatorInactiveColor, viewportFraction |
| `InstaCareSignaturePad` | height, strokeColor, strokeWidth, backgroundColor, borderColor, all labels |
| `InstaCareNetworkImage` | width, height, fit, borderRadius, placeholder, errorWidget, fadeInDuration, backgroundColor, imageBuilder |
| `InstaCareSkeletonLoading` | width, height, borderRadius, baseColor, highlightColor, duration |
| `InstaCareLogo` | size, color, showText, fontSize |
| `InstaCareMarkdown` | padding, styleSheet (merge), onTapLink, selectable, maxImageHeight |
| `InstaCareInputTheme.decoration()` | fillColor, borderColor, focusedBorderColor, radius, hintText, hintStyle, prefixIcon, suffixIcon, errorText, counterText |

### What CANNOT be changed (hardcoded):

- Card border radius (always 12)
- Pill/badge border radius (always 999)
- Booking card layout and spacing
- Service card leaf/dot pattern
- Snackbar animation duration (300ms)
- Confirmation dialog background (gray100)
- OTP cell border radius and colors
- Typography font families (Crimson Pro / Figtree)
- Progress bar height (10)
- Rating scale icon (star)

---

## 7. Package Alternatives Analysis

### Widgets Where Existing Packages Could Replace:

| Widget | Alternative Package | Verdict | Reason |
|--------|-------------------|---------|--------|
| `InstaCareOtpInput` | `pinput` or `otp_text_field` | **Keep custom** | Your OTP widget is well-integrated with the design system. Pinput would require heavy theming to match. |
| `InstaCareCarousel` | `carousel_slider` or `smooth_page_indicator` | **Consider replacing** | `carousel_slider` handles edge cases (infinite scroll, gesture conflicts) better. Your auto-play uses recursive Future.delayed which is a known anti-pattern. |
| `InstaCareMarkdown` | Already uses `flutter_markdown` | **Keep as-is** | It's a well-done themed wrapper. Good pattern. |
| `InstaCareSkeletonLoading` | `shimmer` or `skeletonizer` | **Keep custom** | Your shimmer is lightweight (65 lines). The `shimmer` package adds 300+ lines for the same effect. |
| `InstaCareSignaturePad` | `signature` or `hand_signature` | **Consider for complex needs** | Your implementation works for basic signatures. If you need undo/redo, pressure sensitivity, or SVG export, use `signature` package. For current scope, keep custom. |
| `InstaCareDropdown` | `dropdown_button2` | **Keep custom** | Your overlay-based dropdown gives you full control over positioning and styling. The package would fight your design tokens. |
| `InstaCarePhoneInput` | `intl_phone_field` | **Keep custom** | Your version is simpler and lighter. `intl_phone_field` adds 200KB+ for country selector you don't need. |
| `InstaCareProgressBar` | Built-in `LinearProgressIndicator` | **Keep as-is** | It's already a thin wrapper. No benefit from a package. |
| `InstaCareRatingScale` | `flutter_rating_bar` | **Keep custom** | Your implementation is 33 lines. The package is overkill for star-only rating. |
| `InstaCareVerticalStepper` | `easy_stepper` or `im_stepper` | **Keep custom** | Your horizontal animated stepper is unique to your design. Packages would need heavy customization. |
| `KeyboardAwareScaffold` | `keyboard_dismisser` | **Keep custom** | Your version combines multiple concerns (scroll, dismiss, safe area) elegantly. |
| `InstaCareNetworkImage` | `cached_network_image` | **Augment, don't replace** | Your widget already has an `imageBuilder` slot for injecting `CachedNetworkImage`. Smart design. |

### Summary: Keep 90% custom. Only consider replacing `InstaCareCarousel` with `carousel_slider` for reliability.

**Why custom is better for this plugin:**
1. **Design consistency** - Every widget uses `AppColors`, `InstaCareTypography`, and shared design tokens. Third-party packages would need extensive theming to match.
2. **Bundle size** - Each package adds dependency weight. Your custom widgets are lean (avg. ~100 lines each).
3. **Healthcare domain** - Widgets like `BookingCard`, `AttemptsCard`, `PatientPartnerConnect` are domain-specific. No package exists for these.
4. **Control** - You control the API surface. No risk of breaking changes from upstream packages.

---

## 8. Dependency Analysis

| Package | Version | Size Impact | Necessary? |
|---------|---------|-------------|------------|
| `google_fonts` | ^8.0.2 | Medium (~network font loading) | **Yes** - Core to design system |
| `flutter_svg` | ^2.0.10+1 | Small | **Yes** - Used for logo asset |
| `country_flags` | ^2.2.0 | Small | **Yes** - Used in PhoneInput |
| `flutter_markdown` | ^0.7.7+1 | Medium | **Yes** - Core of Markdown widget |
| `markdown` | ^7.3.0 | Small | **Yes** - Required by flutter_markdown for ExtensionSet |
| `flutter_lints` | ^4.0.0 | Dev only | **Yes** - Linting with custom strict rules |

**Total external dependencies: 5 (reasonable for a UI library)**

No unnecessary or bloated dependencies detected. All serve a clear purpose.

---

## Appendix A: File Structure

```
lib/
  instacare_components.dart          # Main barrel export (55 exports)
  instacare_components_web.dart      # Web platform (empty)
  src/
    animation/
      carousel.dart                  # 137 lines
      markdown.dart                  # 214 lines
      skeleton_loading.dart          # 65 lines
    badges/
      status_badge.dart              # 58 lines
    buttons/
      button.dart                    # ~260 lines (primary + secondary + danger variants)
      danger_button.dart             # ~42 lines (backward-compat delegate)
    cards/
      attempts_card.dart             # ~220 lines
      booking_card.dart              # ~275 lines
      card.dart                      # 39 lines
      card_list_view.dart            # 73 lines
      checkbox_card.dart             # 90 lines
      income_tile.dart               # 63 lines
      patient_partner_connect.dart   # 136 lines
      service_card.dart              # ~137 lines (painters extracted)
      service_category_grid.dart     # ~266 lines (painters extracted)
      service_list_tile.dart         # 188 lines
    common/
      logo.dart                      # 101 lines
      network_image.dart             # 101 lines
      painters.dart                  # ~195 lines (DotTexturePainter, LeafPainter, LeafBranchPainter)
    dialogs/
      confirmation_dialog.dart       # 148 lines
      snackbar.dart                  # ~215 lines (uses InstaCareFeedbackType)
    feedback/
      message_box.dart               # ~96 lines (uses InstaCareFeedbackType)
      progress_bar.dart              # 46 lines
    inputs/
      checkbox_field.dart            # 44 lines
      consent_checkbox.dart          # ~105 lines (StatefulWidget with proper disposal)
      date_picker_field.dart         # ~65 lines (uses InstaCareInputTheme)
      dropdown.dart                  # ~235 lines (uses InstaCareInputTheme)
      dropdown_with_checkbox.dart    # ~295 lines (uses InstaCareInputTheme)
      otp_input.dart                 # ~170 lines (FocusNode leak fixed)
      phone_input.dart               # ~130 lines (uses InstaCareInputTheme, configurable messages)
      search_bar.dart                # ~40 lines (uses InstaCareInputTheme)
      signature_pad.dart             # 411 lines
      text_field.dart                # ~145 lines (uses InstaCareInputTheme)
    navigation/
      bottom_app_nav_bar.dart        # 82 lines
      keyboard_aware_scaffold.dart   # 125 lines
      top_header_title.dart          # 34 lines
      welcome_header.dart            # ~70 lines (uses InstaCareInputTheme)
    pills/
      appointment_status_pills.dart  # 55 lines
      hours_summary_pill.dart        # 29 lines
    selection/
      filter_pills.dart              # 31 lines
      mcq_option_selector.dart       # 126 lines
      pill_chip.dart                 # 45 lines
      radio_buttons.dart             # 86 lines
      rating_scale.dart              # 33 lines
      service_pills.dart             # 31 lines
    steps/
      stepper.dart                   # 212 lines
    theme/
      color.dart                     # 136 lines
      heading.dart                   # 48 lines
      input_theme.dart               # ~60 lines (shared InputDecoration factory)
      typography.dart                # ~95 lines (p/body as aliases for r, no forced height)
    types/
      button_size.dart               # 14 lines
      feedback_type.dart             # 1 line (InstaCareFeedbackType enum)
    upload/
      file_upload_tile.dart          # 61 lines
    assets_patient/                  # Assets (SVG, PNG) - renamed from assessts_patient
      logo.svg, caretaker.png/svg, liveincare.png/svg,
      nursing.png/svg, physiotheraphy.png/svg
```

---

## Appendix B: Priority Action Items

### All Critical & Should-Fix Items - COMPLETED

| # | Item | Status |
|---|------|--------|
| 1 | Fix `FocusNode` leak in `InstaCareOtpInput` | Done |
| 2 | Fix `TapGestureRecognizer` leak in `InstaCareConsentCheckbox` | Done |
| 3 | Remove plugin platform registration from `pubspec.yaml` | Done |
| 4 | Rename `assessts_patient` to `assets_patient` | Done |
| 5 | Extract shared `InputDecoration` helper | Done |
| 6 | Merge `InstaCareDangerButton` into `InstaCareButton.danger()` | Done |
| 7 | Extract shared painters to `common/painters.dart` | Done |
| 8 | Unify message type enums into `InstaCareFeedbackType` | Done |
| 9 | Fix typography `height: 1.0` issue | Done |
| 10 | Remove duplicate `p`/`r` typography styles | Done |
| 11 | Clean up emoji comments in code | Done |
| 12 | Add strict `analysis_options.yaml` rules | Done |
| 13 | Make phone validation messages configurable | Done |
| 14 | Remove unnecessary `Padding(EdgeInsets.all(0))` | Done |
| 15 | Fix Flutter 3.22+ semantics `hitTestTransform` crash | Done |
| 16 | Update Flutter SDK constraint to `>=3.22.0` | Done |

### Remaining Nice to Have (Future versions)

| # | Item | Priority |
|---|------|----------|
| 1 | Fix Carousel auto-play (use Timer instead of recursive Future.delayed) | Medium |
| 2 | Fix SignaturePainter shouldRepaint | Medium |
| 3 | Add unit tests | Medium |
| 4 | Add dartdoc comments to all public APIs | Low |
