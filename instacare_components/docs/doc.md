# InstaCare UI Components Plugin — Codebase Audit Report

**Version:** 1.1.1 | **Date:** 2026-03-25
**Total Widgets:** ~40 unique widgets | **Total Dart Files:** 45
**Flutter SDK:** >=3.16.0 | **Dart SDK:** >=3.0.0 <4.0.0

---

## 1. Overall Assessment: 8/10

### Strengths
- Well-organized folder structure by widget category
- Consistent `InstaCare` prefix naming convention
- Good `const` constructor usage throughout
- Comprehensive color system with semantic tokens
- Custom painters for unique visual identity (leaf patterns, dot textures)
- Generic type support in Dropdown/RadioButtons
- Proper disposal of controllers, focus nodes in most widgets
- `LayoutBuilder` used for responsive scaling
- Clean separation of theme tokens from widget code

### Weaknesses
- Zero unit tests (test files are boilerplate only)
- Missing accessibility support (no `Semantics` labels)
- No widget-level dartdoc documentation
- Some inconsistent border radius values across widgets

---

## 2. Bugs Fixed (This Audit)

| # | Issue | File | Severity | Fix |
|---|-------|------|----------|-----|
| 1 | `FocusNode()` created inside `build()` — leaked every rebuild | `otp_input.dart:110` | **Critical** | Created `_keyListenerNodes` list in `initState()`, disposed in `dispose()` |
| 2 | `Future.delayed` recursion for autoplay — uncancellable | `carousel.dart:51` | **High** | Replaced with `Timer.periodic` + cancel in `dispose()` |
| 3 | `height: 1.0` on all 11 typography styles — breaks multiline text | `typography.dart` | **High** | Removed `height: 1.0` from all styles, Flutter uses natural font line height |
| 4 | `p` and `r` were separate identical `GoogleFonts.figtree()` definitions | `typography.dart` | **Medium** | `p` and `body` are now aliases for `r` |
| 5 | `Padding(padding: EdgeInsets.all(0))` — no-op wrapper | `booking_card.dart:157` | **Low** | Removed unnecessary `Padding` wrapper |
| 6 | Directory typo `assessts_patient` | `lib/src/` + `pubspec.yaml` + `logo.dart` | **Medium** | Renamed to `assets_patient` everywhere |
| 7 | Plugin section in `pubspec.yaml` for a pure Dart package | `pubspec.yaml:23-31` | **Medium** | Removed `plugin:` section entirely |
| 8 | Card border uses `backgroundColor` fallback instead of dedicated color | `card.dart:27` | **Medium** | Border now always uses `AppColors.primary700` |

---

## 3. Widget Performance Classification

### Heavy (watch for performance)

| Widget | File | Why |
|--------|------|-----|
| `InstaCareServiceCard` | `cards/service_card.dart` | CustomPaint with nested loop (dot grid) + leaf painter. Painters are private, duplicated if `ServiceCategoryGrid` existed |
| `InstaCareCarousel` | `animation/carousel.dart` | Auto-play with Timer + PageView animation (now properly cancellable) |
| `InstaCareOtpInput` | `inputs/otp_input.dart` | Creates N `TextEditingController` + 2N `FocusNode` (all properly disposed now) |
| `InstaCareVerticalStepper` | `steps/stepper.dart` | Creates N `AnimationController` instances (properly disposed) |

### Medium

| Widget | File | Why |
|--------|------|-----|
| `InstaCareDropdown` | `inputs/dropdown.dart` | Overlay-based, creates `OverlayEntry` on every open. Proper cleanup via `WidgetsBindingObserver` |
| `InstaCareDropdownWithCheckbox` | `inputs/dropdown_with_checkbox.dart` | Same overlay pattern, multi-select variant |
| `InstaCareBookingCard` | `cards/booking_card.dart` | ~275 lines, network image loading, multiple sections |
| `InstaCareMarkdown` | `animation/markdown.dart` | ~214 lines, custom styling with flutter_markdown |
| `InstaCareAttemptsCard` | `cards/attempts_card.dart` | ~220 lines, conditional rendering for 3 states |

### Lightweight (well-optimized)

| Widget | File | Notes |
|--------|------|-------|
| `InstaCarePillChip` | `selection/pill_chip.dart` | Simple stateless, minimal tree |
| `InstaCareCheckboxField` | `inputs/checkbox_field.dart` | Thin wrapper |
| `InstaCareProgressBar` | `feedback/progress_bar.dart` | Uses built-in `LinearProgressIndicator` |
| `InstaCareRatingScale` | `selection/rating_scale.dart` | Simple icon row |
| `InstaCareStatusBadge` | `badges/status_badge.dart` | Minimal container + text |
| `InstaCareHoursSummaryPill` | `pills/hours_summary_pill.dart` | Theme-aware, minimal |
| `InstaCareFilterPills` | `selection/filter_pills.dart` | Thin composition over PillChip |
| `InstaCareServicePills` | `selection/service_pills.dart` | Thin composition over PillChip |
| `InstaCareMessageBox` | `feedback/message_box.dart` | Simple stateless container |
| `InstaCareSearchBar` | `inputs/search_bar.dart` | Thin wrapper over TextField |
| `KeyboardAwareScaffold` | `navigation/keyboard_aware_scaffold.dart` | Smart utility, minimal overhead |
| `InstaCareCard` | `cards/card.dart` | Simple card container |
| `InstaCareIncomeTile` | `cards/income_tile.dart` | Composition-based |
| `InstaCareCardListView` | `cards/card_list_view.dart` | Simple list layout |

---

## 4. Good Practices Found

| Practice | Files | Notes |
|----------|-------|-------|
| `const` constructors | All widgets | Proper use throughout |
| Private constructor for utility classes | `AppColors._()`, `InstaCareTypography._()` | Prevents instantiation |
| Named constructors | `InstaCareButton.secondary`, `InstaCareTextField.password` | Clean API |
| `WidgetStateProperty` (not deprecated `MaterialStateProperty`) | `button.dart` | Up-to-date API |
| Proper `dispose()` | Carousel, OTP, Dropdown, Stepper | Controllers/nodes cleaned up |
| `WidgetsBindingObserver` | Dropdown, DropdownWithCheckbox | Closes overlay on metrics change |
| `shouldRepaint()` optimization | All CustomPainters | Avoids unnecessary repaints |
| `Clip.antiAlias` | Cards, ServiceCard | Smooth rounded corners |
| Responsive scaling with `LayoutBuilder` | Buttons, ServiceCard, Stepper, OTP | Adapts to container size |
| `.clamp()` for sizing | Throughout | Safe responsive values |

---

## 5. Bad Practices Found

| Issue | Files | Impact |
|-------|-------|--------|
| No `Semantics` widgets | All interactive widgets | Screen readers can't describe UI elements |
| No unit tests | `test/` directory | Only boilerplate test file exists |
| No dartdoc comments | All public APIs | Missing documentation for consumers |
| Duplicate painters (`_DotTexturePainter`, `_LeafPainter`) | `service_card.dart` | Private classes, can't be reused if grid widget is added later |
| Duplicate `InputDecoration` | All input widgets | Each input builds its own `InputDecoration` instead of sharing a theme helper |
| Duplicate enums for message types | `snackbar.dart` vs `message_box.dart` | `InstaCareSnackbarType` and `InstaCareMessageType` are identical enums |

---

## 6. Remaining Issues — Prioritized

### Fix Now (before next release)
| # | Issue | File | Effort |
|---|-------|------|--------|
| 1 | Extract shared `InputDecoration` helper | Create `theme/input_theme.dart` | Medium |
| 2 | Unify `SnackbarType`/`MessageType` enums | Create `types/feedback_type.dart` | Low |
| 3 | Extract shared painters | Create `common/painters.dart` | Medium |

### Fix Later (next sprint)
| # | Issue | File | Effort |
|---|-------|------|--------|
| 4 | Add `Semantics` labels to all interactive widgets | All widgets | High |
| 5 | Add unit tests for theme constants, button states, validators | `test/` | High |
| 6 | Add dartdoc comments to all public APIs | All files | Medium |

### Good to Have (future)
| # | Issue | Notes |
|---|-------|-------|
| 7 | Replace `carousel_slider` package for edge cases (infinite scroll, gesture conflicts) | Current implementation works but package handles more edge cases |
| 8 | Add `borderColor` parameter to `InstaCareCard` | Currently hardcoded to `AppColors.primary700` |
| 9 | Add `borderRadius` parameter to card widgets | Currently hardcoded to `12` |

---

## 7. Complete Widget Catalog

### 7.1 Buttons (1 widget, 2 variants)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareButton` | `buttons/button.dart` | StatelessWidget | Primary variant (default) |
| `InstaCareButton.secondary` | `buttons/button.dart` | StatelessWidget | Outlined secondary variant |

**Properties:** `text`, `onPressed`, `isLoading` (skeleton shimmer), `size` (ButtonSize enum: small/medium/large), `icon`, `fullWidth`, `isDisabled`

### 7.2 Input Widgets (8 widgets)

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

### 7.3 Card Widgets (7 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareCard` | `cards/card.dart` | StatelessWidget | Base card container |
| `InstaCareBookingCard` | `cards/booking_card.dart` | StatelessWidget | Patient booking info card |
| `InstaCareCheckboxCard` | `cards/checkbox_card.dart` | StatelessWidget | Selectable card with checkbox |
| `InstaCareAttemptsCard` | `cards/attempts_card.dart` | StatelessWidget | Assessment attempts tracker (3 states) |
| `InstaCareIncomeTile` | `cards/income_tile.dart` | StatelessWidget | Income display with redeem button |
| `InstaCareServiceCard` | `cards/service_card.dart` | StatelessWidget | Service card with decorative leaf pattern |
| `InstaCareCardListView` | `cards/card_list_view.dart` | StatelessWidget | Card + title/body list layout |

### 7.4 Navigation Widgets (3 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareBottomAppNavBar` | `navigation/bottom_app_nav_bar.dart` | StatelessWidget | Bottom navigation bar |
| `InstaCareTopHeaderTitle` | `navigation/top_header_title.dart` | StatelessWidget | AppBar header (PreferredSizeWidget) |
| `KeyboardAwareScaffold` | `navigation/keyboard_aware_scaffold.dart` | StatelessWidget | Scaffold with keyboard handling |

### 7.5 Selection Widgets (6 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCarePillChip` | `selection/pill_chip.dart` | StatelessWidget | Single toggle pill |
| `InstaCareFilterPills` | `selection/filter_pills.dart` | StatelessWidget | Multi-select filter pills |
| `InstaCareServicePills` | `selection/service_pills.dart` | StatelessWidget | Single-select service pills |
| `InstaCareRadioButtons<T>` | `selection/radio_buttons.dart` | StatelessWidget | Radio option group |
| `InstaCareRatingScale` | `selection/rating_scale.dart` | StatelessWidget | 1-5 star rating |
| `InstaCareMcqOptionSelector` | `selection/mcq_option_selector.dart` | StatelessWidget | MCQ with prev/next buttons |

### 7.6 Feedback & Dialog Widgets (4 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareSnackbar.show()` | `dialogs/snackbar.dart` | Static method | Animated top notification |
| `showInstaCareConfirmationDialog()` | `dialogs/confirmation_dialog.dart` | Function | Confirmation popup dialog |
| `InstaCareMessageBox` | `feedback/message_box.dart` | StatelessWidget | Inline message with icon |
| `InstaCareProgressBar` | `feedback/progress_bar.dart` | StatelessWidget | Linear progress with percentage |

### 7.7 Animation Widgets (3 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareSkeletonLoading` | `animation/skeleton_loading.dart` | StatefulWidget | Shimmer placeholder |
| `InstaCareCarousel` | `animation/carousel.dart` | StatefulWidget | Auto-play image carousel with indicators |
| `InstaCareMarkdown` | `animation/markdown.dart` | StatelessWidget | Styled markdown renderer |

### 7.8 Status & Badge Widgets (3 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareStatusBadge` | `badges/status_badge.dart` | StatelessWidget | Enum-based status badge |
| `InstaCareHoursSummaryPill` | `pills/hours_summary_pill.dart` | StatelessWidget | Themed text pill |
| `InstaCareAppointmentStatusPills` | `pills/appointment_status_pills.dart` | StatelessWidget | Status badge selection row |

### 7.9 Other Widgets (5 widgets)

| Widget | File | Type | Description |
|--------|------|------|-------------|
| `InstaCareVerticalStepper` | `steps/stepper.dart` | StatefulWidget | Animated step indicator |
| `InstaCareFileUploadTile` | `upload/file_upload_tile.dart` | StatefulWidget | Upload area with hover state |
| `InstaCareLogo` | `common/logo.dart` | StatelessWidget | SVG logo + text |
| `InstaCareLogoIcon` | `common/logo.dart` | StatelessWidget | SVG logo only |
| `InstaCareLogoText` | `common/logo.dart` | StatelessWidget | Text only |
| `InstaCareNetworkImage` | `common/network_image.dart` | StatelessWidget | Image loader with shimmer/error |

### 7.10 Theme & Utility Exports

| Export | File | Description |
|--------|------|-------------|
| `AppColors` | `theme/color.dart` | Full color palette (90+ constants) |
| `InstaCareTypography` | `theme/typography.dart` | Text styles (h1-h5, p/body/r, m, s, sm, xs) |
| `InstaCareHeading` | `theme/heading.dart` | Header helper widgets |
| `ButtonSize` | `types/button_size.dart` | Enum: small, medium, large |

---

## 8. Theme System

### 8.1 Color Palette

| Category | Shades | Base Color | Usage |
|----------|--------|------------|-------|
| Primary | 50-900 | `#34513A` (Dark Green) | Main brand, buttons, borders |
| Secondary | 50-900 | `#DC9251` (Orange) | Accents, secondary actions |
| Natural | 50-900 | `#A58E74` (Brown) | Earthy backgrounds |
| Ivory | 50-900 | `#FFEFCD` (Warm Cream) | Input fills, warm backgrounds |
| Gray | 50-900 | `#000000-#F8F8F8` | Text, borders, disabled states |
| Error | 50-900 | `#FB0000` (Red) | Error states, destructive actions |
| Success | 50-900 | `#00C400` (Green) | Success feedback |

### 8.2 Typography

| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| h1 | Crimson Pro | 24 | SemiBold (600) | Page titles |
| h2 | Crimson Pro | 20 | Medium (500) | Section titles |
| h3 | Crimson Pro | 18 | Medium (500) | Section inner titles |
| h4 | Crimson Pro | 14 | SemiBold (600) | Small titles |
| h5 | Figtree | 20 | Medium (500) | Alternate heading |
| r | Figtree | 14 | Regular (400) | Body/one-liner |
| p / body | (alias for r) | 14 | Regular (400) | Body text aliases |
| m | Figtree | 14 | Medium (500) | One-liner medium |
| s | Figtree | 12 | Regular (400) | Small regular |
| sm | Figtree | 12 | Medium (500) | Small medium |
| xs | Figtree | 10 | Medium (500) | Extra small |

**Note:** `p` and `body` are aliases for `r`. No forced `height` value — Flutter uses natural font line height.

---

## 9. Dependency Analysis

| Package | Version | Necessary? | Notes |
|---------|---------|------------|-------|
| `google_fonts` | ^8.0.2 | Yes | Core to design system |
| `flutter_svg` | ^2.0.10+1 | Yes | Logo asset rendering |
| `country_flags` | ^2.2.0 | Yes | PhoneInput country flags |
| `flutter_markdown` | ^0.7.7+1 | Yes | Markdown widget core |
| `markdown` | ^7.3.0 | Yes | Required by flutter_markdown |
| `flutter_lints` | ^4.0.0 | Dev only | Linting |

**Total external dependencies: 5** — reasonable for a UI library. No bloat detected.

---

## 10. File Structure

```
lib/
  instacare_components.dart              # Main barrel export
  instacare_components_web.dart          # Web platform (empty)
  src/
    animation/
      carousel.dart                      # 138 lines
      markdown.dart                      # 214 lines
      skeleton_loading.dart              # 65 lines
    badges/
      status_badge.dart                  # 58 lines
    buttons/
      button.dart                        # 204 lines
    cards/
      attempts_card.dart                 # 234 lines
      booking_card.dart                  # 275 lines
      card.dart                          # 39 lines
      card_list_view.dart                # 73 lines
      checkbox_card.dart                 # 90 lines
      income_tile.dart                   # 63 lines
      service_card.dart                  # 244 lines
    common/
      logo.dart                          # 101 lines
      network_image.dart                 # 101 lines
    dialogs/
      confirmation_dialog.dart           # 148 lines
      snackbar.dart                      # 216 lines
    feedback/
      message_box.dart                   # 97 lines
      progress_bar.dart                  # 46 lines
    inputs/
      checkbox_field.dart                # 44 lines
      date_picker_field.dart             # 92 lines
      dropdown.dart                      # 253 lines
      dropdown_with_checkbox.dart        # 313 lines
      otp_input.dart                     # 165 lines
      phone_input.dart                   # 163 lines
      search_bar.dart                    # 57 lines
      text_field.dart                    # 167 lines
    navigation/
      bottom_app_nav_bar.dart            # 82 lines
      keyboard_aware_scaffold.dart       # 125 lines
      top_header_title.dart              # 36 lines
    pills/
      appointment_status_pills.dart      # 55 lines
      hours_summary_pill.dart            # 29 lines
    selection/
      filter_pills.dart                  # 31 lines
      mcq_option_selector.dart           # 126 lines
      pill_chip.dart                     # 45 lines
      radio_buttons.dart                 # 86 lines
      rating_scale.dart                  # 33 lines
      service_pills.dart                 # 31 lines
    steps/
      stepper.dart                       # 212 lines
    theme/
      color.dart                         # 136 lines
      heading.dart                       # 48 lines
      typography.dart                    # 112 lines
    types/
      button_size.dart                   # 14 lines
    upload/
      file_upload_tile.dart              # 61 lines
    assets_patient/                      # SVG/PNG assets
      logo.svg, caretaker.png/svg, liveincare.png/svg,
      nursing.png/svg, physiotheraphy.png/svg
```
