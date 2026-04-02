# InstaCare UI Components Plugin — Codebase Audit Report

**Version:** 1.1.1 | **Date:** 2026-03-25 (Updated)
**Total Widgets:** ~40 unique widgets | **Total Dart Files:** 45 | **Total Lines:** 4,905
**Flutter SDK:** >=3.16.0 | **Dart SDK:** >=3.0.0 <4.0.0

---

## 1. Overall Assessment: 8.5/10

### Strengths
- Well-organized folder structure by widget category (14 directories)
- Consistent `InstaCare` prefix naming convention across all 40+ widgets
- Good `const` constructor usage throughout every widget
- Comprehensive color system with 90+ semantic tokens (`AppColors`)
- Custom painters for unique visual identity (leaf patterns, dot textures) with proper `shouldRepaint()`
- Generic type support in `Dropdown<T>` and `RadioButtons<T>`
- Proper disposal of controllers, focus nodes, timers in all stateful widgets
- `LayoutBuilder` used for responsive scaling in buttons, service cards, stepper, OTP, MCQ
- Clean separation of theme tokens from widget code
- `WidgetStateProperty` (modern API, not deprecated `MaterialStateProperty`)
- `WidgetsBindingObserver` in dropdowns to close overlay on metrics change
- Barrel export file properly exports all 45 public widgets/types
- Private constructor utility classes (`AppColors._()`, `InstaCareTypography._()`)
- Named constructors for clean API (`InstaCareButton.secondary`, `InstaCareTextField.password`)

### Weaknesses
- No unit tests (test files are boilerplate only)
- No `Semantics` widgets for accessibility
- No widget-level dartdoc documentation on most widgets
- Duplicate `InputDecoration` pattern across 7 input widgets
- Duplicate enums (`InstaCareSnackbarType` vs `InstaCareMessageType`)

---

## 2. Bugs Fixed (This Audit)

| # | Issue | File | Severity | Fix |
|---|-------|------|----------|-----|
| 1 | `FocusNode()` created inside `build()` — leaked every rebuild | `otp_input.dart:110` | **Critical** | Created `_keyListenerNodes` list in `initState()`, disposed in `dispose()` |
| 2 | `Future.delayed` recursion for autoplay — uncancellable | `carousel.dart:51` | **High** | Replaced with `Timer.periodic` + cancel in `dispose()` |
| 3 | `height: 1.0` on all 11 typography styles — breaks multiline text | `typography.dart` | **High** | Removed `height: 1.0` from all styles, Flutter uses natural font line height |
| 4 | `p` and `r` were separate identical `GoogleFonts.figtree()` definitions | `typography.dart` | **Medium** | `r` is the single definition; `p` and `body` are aliases for `r` |
| 5 | `Padding(padding: EdgeInsets.all(0))` — no-op wrapper | `booking_card.dart:157` | **Low** | Removed unnecessary `Padding` wrapper |
| 6 | Directory typo `assessts_patient` | `pubspec.yaml` + `logo.dart` | **Medium** | Fixed to `assets_patient` in all references |
| 7 | Plugin section in `pubspec.yaml` for a pure Dart package | `pubspec.yaml:23-31` | **Medium** | Removed `plugin:` section entirely |
| 8 | Card border uses `backgroundColor` fallback instead of dedicated color | `card.dart:27` | **Medium** | Border now always uses `const BorderSide(color: AppColors.primary700)` |

---

## 3. Current Issues — Prioritized

### 3.1 Fix Now (before next release)

| # | Issue | File(s) | Severity | Effort |
|---|-------|---------|----------|--------|
| 1 | **Duplicate `InputDecoration`** across 7 input widgets — identical fill color, border radius, border colors repeated | `text_field.dart`, `phone_input.dart`, `otp_input.dart`, `dropdown.dart`, `dropdown_with_checkbox.dart`, `search_bar.dart`, `date_picker_field.dart` | Medium | Medium — Create shared `InputDecorationFactory` in `theme/input_theme.dart` |
| 2 | **Duplicate feedback enums** — `InstaCareSnackbarType` and `InstaCareMessageType` have identical cases (`info`, `error`, `pending`, `success`) with identical color mappings | `snackbar.dart:5`, `message_box.dart:5` | Medium | Low — Unify into `InstaCareFeedbackType` in `types/feedback_type.dart` |
| 3 | **Duplicate painters** — `_DotTexturePainter` and `_LeafPainter` are private, cannot be reused if a grid widget is added | `service_card.dart:139-243` | Low | Medium — Extract to `common/painters.dart` |
| 4 | **`InstaCareCard` border not customizable** — border color hardcoded to `AppColors.primary700`, no `borderColor` parameter | `card.dart:27` | Medium | Low — Add optional `borderColor` parameter |

### 3.2 Fix Later (next sprint)

| # | Issue | File(s) | Severity | Effort |
|---|-------|---------|----------|--------|
| 5 | **No `Semantics` labels** on any interactive widget — screen readers cannot describe UI elements | All interactive widgets | High | High |
| 6 | **No unit tests** — only boilerplate test file exists | `test/` | High | High |
| 7 | **No dartdoc comments** on most public APIs | All files | Medium | Medium |
| 8 | **`InstaCareProgressBar` color not customizable** — uses `Theme.of(context).colorScheme.primary` only, no parameter for status colors (warning, error) | `progress_bar.dart:34` | Low | Low — Add optional `color` parameter |
| 9 | **`InstaCareRatingScale` icon size not customizable** — star size uses implicit `IconButton` defaults | `rating_scale.dart:22-29` | Low | Low — Add optional `iconSize` parameter |

### 3.3 Good to Have (future)

| # | Issue | Notes |
|---|-------|-------|
| 10 | Add `borderRadius` parameter to `InstaCareCard` | Currently hardcoded to `12` |
| 11 | Add debounce support to `InstaCareSearchBar` | Consumers must implement debouncing themselves |
| 12 | Add `RepaintBoundary` around `CustomPaint` widgets in `InstaCareServiceCard` | Isolates repaint zone when card is in a list |
| 13 | Support dark mode in components that use hardcoded `AppColors` | Currently assumes light theme only |

---

## 4. Widget Performance Classification

### Heavy (watch in lists)

| Widget | File | Lines | Why |
|--------|------|-------|-----|
| `InstaCareServiceCard` | `cards/service_card.dart` | 243 | Two `CustomPaint` widgets (dot grid + leaf). `shouldRepaint()` properly implemented. |
| `InstaCareCarousel` | `animation/carousel.dart` | 141 | `Timer.periodic` auto-play + PageView animation. Timer properly cancelled in `dispose()`. |
| `InstaCareOtpInput` | `inputs/otp_input.dart` | 167 | Creates N `TextEditingController` + 2N `FocusNode`. All properly disposed. |
| `InstaCareVerticalStepper` | `steps/stepper.dart` | 212 | Creates N `AnimationController` instances. Properly disposed. Reinitializes on `didUpdateWidget`. |

### Medium

| Widget | File | Lines | Why |
|--------|------|-------|-----|
| `InstaCareDropdown` | `inputs/dropdown.dart` | 252 | Overlay-based, `WidgetsBindingObserver` for cleanup. Proper lifecycle. |
| `InstaCareDropdownWithCheckbox` | `inputs/dropdown_with_checkbox.dart` | 312 | Same overlay pattern, multi-select. Marks overlay dirty on `didUpdateWidget`. |
| `InstaCareBookingCard` | `cards/booking_card.dart` | 275 | Network image, multiple sections. Stateless, no lifecycle concerns. |
| `InstaCareMarkdown` | `animation/markdown.dart` | 213 | Custom `MarkdownStyleSheet`, custom builders. Mergeable via `styleSheet` parameter. |
| `InstaCareAttemptsCard` | `cards/attempts_card.dart` | 233 | 3 states (passed/exhausted/in-progress), `LayoutBuilder` for responsive. |
| `InstaCareSnackbar` | `dialogs/snackbar.dart` | 215 | Overlay-based with `AnimationController`, auto-dismiss with `mounted` check. |
| `InstaCareMcqOptionSelector` | `selection/mcq_option_selector.dart` | 126 | Responsive dot sizing, uses `InstaCareButton` for navigation. |
| `InstaCareConfirmationDialog` | `dialogs/confirmation_dialog.dart` | 148 | Adaptive sizing with `LayoutBuilder`, proper `Navigator.pop`. |

### Lightweight (well-optimized)

| Widget | File | Lines | Notes |
|--------|------|-------|-------|
| `InstaCarePillChip` | `selection/pill_chip.dart` | 45 | Simple stateless, minimal tree |
| `InstaCareCheckboxField` | `inputs/checkbox_field.dart` | 44 | Thin wrapper, delegates to Material Checkbox |
| `InstaCareProgressBar` | `feedback/progress_bar.dart` | 46 | Uses built-in `LinearProgressIndicator` |
| `InstaCareRatingScale` | `selection/rating_scale.dart` | 33 | Simple icon row with `VisualDensity.compact` |
| `InstaCareStatusBadge` | `badges/status_badge.dart` | 58 | Enum-driven color, minimal container + text |
| `InstaCareHoursSummaryPill` | `pills/hours_summary_pill.dart` | 29 | Theme-aware, minimal |
| `InstaCareFilterPills` | `selection/filter_pills.dart` | 31 | Thin composition over `PillChip` |
| `InstaCareServicePills` | `selection/service_pills.dart` | 31 | Thin composition over `PillChip` |
| `InstaCareMessageBox` | `feedback/message_box.dart` | 96 | Simple stateless container |
| `InstaCareSearchBar` | `inputs/search_bar.dart` | 56 | Thin wrapper over `TextField` |
| `KeyboardAwareScaffold` | `navigation/keyboard_aware_scaffold.dart` | 125 | Configurable (scrollable, safeArea, dismissKeyboard flags) |
| `InstaCareCard` | `cards/card.dart` | 39 | Simple card container with InkWell |
| `InstaCareIncomeTile` | `cards/income_tile.dart` | 63 | Composition over `InstaCareCard` + `InstaCareButton` |
| `InstaCareCardListView` | `cards/card_list_view.dart` | 73 | Simple list layout |
| `InstaCareTopHeaderTitle` | `navigation/top_header_title.dart` | 35 | Thin AppBar wrapper, `PreferredSizeWidget` |
| `InstaCareBottomAppNavBar` | `navigation/bottom_app_nav_bar.dart` | 82 | Customizable colors, proper `SafeArea` |
| `InstaCareCheckboxCard` | `cards/checkbox_card.dart` | 90 | Customizable colors for selected/unselected states |
| `InstaCareFileUploadTile` | `upload/file_upload_tile.dart` | 61 | Hover/highlight state tracking |
| `InstaCareSkeletonLoading` | `animation/skeleton_loading.dart` | 65 | Gradient animation with `AnimationController` |
| `InstaCareRadioButtons<T>` | `selection/radio_buttons.dart` | 86 | Generic, supports horizontal (Wrap) and vertical (Column) |
| `InstaCareTextField` | `inputs/text_field.dart` | 166 | Password variant via named constructor, color customizable |
| `InstaCarePhoneInput` | `inputs/phone_input.dart` | 162 | Country flag + code prefix, digit-only filter |
| `InstaCareDatePickerField` | `inputs/date_picker_field.dart` | 91 | Triggers system date picker, formatted display |
| `InstaCareAppointmentStatusPills` | `pills/appointment_status_pills.dart` | 55 | Badge composition with opacity-based selection |
| `InstaCareLogo` / `LogoIcon` / `LogoText` | `common/logo.dart` | 101 | SVG asset with color filter, three variants |
| `InstaCareNetworkImage` | `common/network_image.dart` | 101 | Shimmer placeholder, fade-in, custom `imageBuilder` hook |
| `InstaCareHeading` | `theme/heading.dart` | 48 | Static helper methods for consistent headings |

---

## 5. Good Practices Found

| Practice | Where | Notes |
|----------|-------|-------|
| `const` constructors | All widgets | Proper use throughout, enables widget tree optimization |
| Private constructor for utility classes | `AppColors._()`, `InstaCareTypography._()` | Prevents accidental instantiation |
| Named constructors | `InstaCareButton.secondary`, `InstaCareTextField.password` | Clean API surface |
| `WidgetStateProperty` (modern API) | `button.dart` | Not using deprecated `MaterialStateProperty` |
| Proper `dispose()` | Carousel (Timer), OTP (controllers/nodes), Dropdown (observer), Stepper (controllers), Snackbar (animation) | All resources properly cleaned up |
| `WidgetsBindingObserver` | `dropdown.dart`, `dropdown_with_checkbox.dart` | Closes overlay on screen metrics change (rotation, keyboard) |
| `shouldRepaint()` optimization | `_DotTexturePainter`, `_LeafPainter` | Compares all relevant fields, avoids unnecessary repaints |
| `Clip.antiAlias` | `booking_card.dart` | Smooth rounded corners on clipped content |
| Responsive scaling with `LayoutBuilder` | `button.dart`, `service_card.dart`, `stepper.dart`, `otp_input.dart`, `mcq_option_selector.dart`, `attempts_card.dart`, `confirmation_dialog.dart` | Adapts to container size with `.clamp()` |
| `.clamp()` for safe sizing | Throughout (7+ widgets) | Prevents extreme values on unusual screen sizes |
| `didUpdateWidget` handling | `stepper.dart`, `dropdown_with_checkbox.dart` | Reinitializes animations / rebuilds overlay when props change |
| `imageBuilder` hook | `network_image.dart` | Lets consumers inject custom caching (e.g. CachedNetworkImage) |
| Overlay position calculation | `dropdown.dart`, `dropdown_with_checkbox.dart` | Measures space above/below, flips direction as needed |
| `Timer.periodic` with dispose | `carousel.dart` | Auto-play is cancellable, no memory leak |
| `mounted` check before `setState` | `dropdown.dart:78`, `dropdown_with_checkbox.dart:89` | Prevents setState-after-dispose |

---

## 6. Bad Practices Still Present

| # | Issue | File(s) | Impact | Fix Effort |
|---|-------|---------|--------|------------|
| 1 | **Duplicate `InputDecoration`** — 7 input widgets each build identical decoration (fill: `ivory300`, border: `primary700`, focused: `primary900` width 2, radius 8) | `text_field.dart`, `phone_input.dart`, `otp_input.dart`, `dropdown.dart`, `dropdown_with_checkbox.dart`, `search_bar.dart`, `date_picker_field.dart` | More maintenance, risk of inconsistency | Medium — Create `InstaCareInputDecoration` factory |
| 2 | **Duplicate feedback enums** — `InstaCareSnackbarType` and `InstaCareMessageType` are identical (`info`, `error`, `pending`, `success`) with identical color switch maps | `snackbar.dart:5`, `message_box.dart:5` | Code duplication, confusing for consumers | Low |
| 3 | **No `Semantics` widgets** on any interactive element | All interactive widgets | Screen readers cannot describe UI | High effort |
| 4 | **No unit tests** | `test/` directory (boilerplate only) | No regression safety | High effort |
| 5 | **No dartdoc on most public APIs** | Most widgets | Consumers get no IDE documentation | Medium effort |
| 6 | **Duplicate custom painters** are private, not reusable | `service_card.dart:139-243` | If grid variant is added, painters must be duplicated | Medium effort |

---

## 7. Complete Widget Catalog

### 7.1 Buttons (1 widget, 2 variants)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareButton` | `buttons/button.dart` | StatelessWidget | 203 | Primary variant (default) |
| `InstaCareButton.secondary` | `buttons/button.dart` | StatelessWidget | — | Outlined secondary variant |

**Properties:** `text`, `onPressed`, `isLoading` (skeleton shimmer), `size` (ButtonSize enum: small/medium/large), `icon`, `fullWidth`, `isDisabled`

### 7.2 Input Widgets (9 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareTextField` | `inputs/text_field.dart` | StatefulWidget | 166 | Text input with label, hint, validation, customizable colors |
| `InstaCareTextField.password` | `inputs/text_field.dart` | StatefulWidget | — | Pre-configured password variant with toggle |
| `InstaCarePhoneInput` | `inputs/phone_input.dart` | StatelessWidget | 162 | Phone input with country flag & code |
| `InstaCareOtpInput` | `inputs/otp_input.dart` | StatefulWidget | 167 | N-digit OTP entry (default: 6) |
| `InstaCareDropdown<T>` | `inputs/dropdown.dart` | StatefulWidget | 252 | Generic overlay-based dropdown |
| `InstaCareDropdownWithCheckbox<T>` | `inputs/dropdown_with_checkbox.dart` | StatefulWidget | 312 | Multi-select dropdown with checkboxes |
| `InstaCareSearchBar` | `inputs/search_bar.dart` | StatelessWidget | 56 | Search input with icon |
| `InstaCareDatePickerField` | `inputs/date_picker_field.dart` | StatelessWidget | 91 | Date picker trigger field |
| `InstaCareCheckboxField` | `inputs/checkbox_field.dart` | StatelessWidget | 44 | Labeled checkbox |

### 7.3 Card Widgets (7 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareCard` | `cards/card.dart` | StatelessWidget | 39 | Base card container with InkWell |
| `InstaCareBookingCard` | `cards/booking_card.dart` | StatelessWidget | 275 | Patient booking info card |
| `InstaCareCheckboxCard` | `cards/checkbox_card.dart` | StatelessWidget | 90 | Selectable card with checkbox |
| `InstaCareAttemptsCard` | `cards/attempts_card.dart` | StatelessWidget | 233 | Assessment attempts tracker (3 states) |
| `InstaCareIncomeTile` | `cards/income_tile.dart` | StatelessWidget | 63 | Income display with redeem button |
| `InstaCareServiceCard` | `cards/service_card.dart` | StatelessWidget | 243 | Service card with decorative leaf pattern |
| `InstaCareCardListView` | `cards/card_list_view.dart` | StatelessWidget | 73 | Card + title/body list layout |

### 7.4 Navigation Widgets (3 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareBottomAppNavBar` | `navigation/bottom_app_nav_bar.dart` | StatelessWidget | 82 | Bottom navigation bar with customizable colors |
| `InstaCareTopHeaderTitle` | `navigation/top_header_title.dart` | StatelessWidget | 35 | AppBar header (`PreferredSizeWidget`) |
| `KeyboardAwareScaffold` | `navigation/keyboard_aware_scaffold.dart` | StatelessWidget | 125 | Scaffold with keyboard handling, scrollable/safeArea flags |

### 7.5 Selection Widgets (6 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCarePillChip` | `selection/pill_chip.dart` | StatelessWidget | 45 | Single toggle pill |
| `InstaCareFilterPills` | `selection/filter_pills.dart` | StatelessWidget | 31 | Multi-select filter pills |
| `InstaCareServicePills` | `selection/service_pills.dart` | StatelessWidget | 31 | Single-select service pills |
| `InstaCareRadioButtons<T>` | `selection/radio_buttons.dart` | StatelessWidget | 86 | Radio option group (vertical/horizontal) |
| `InstaCareRatingScale` | `selection/rating_scale.dart` | StatelessWidget | 33 | 1-N star rating (default 5) |
| `InstaCareMcqOptionSelector` | `selection/mcq_option_selector.dart` | StatelessWidget | 126 | MCQ with prev/next buttons |

### 7.6 Feedback & Dialog Widgets (4 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareSnackbar.show()` | `dialogs/snackbar.dart` | Static method | 215 | Animated top overlay notification with auto-dismiss |
| `showInstaCareConfirmationDialog()` | `dialogs/confirmation_dialog.dart` | Function | 148 | Adaptive confirmation popup |
| `InstaCareMessageBox` | `feedback/message_box.dart` | StatelessWidget | 96 | Inline message with icon |
| `InstaCareProgressBar` | `feedback/progress_bar.dart` | StatelessWidget | 46 | Linear progress with percentage |

### 7.7 Animation Widgets (3 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareSkeletonLoading` | `animation/skeleton_loading.dart` | StatefulWidget | 65 | Gradient shimmer placeholder |
| `InstaCareCarousel` | `animation/carousel.dart` | StatefulWidget | 141 | Auto-play image carousel with indicators |
| `InstaCareMarkdown` | `animation/markdown.dart` | StatelessWidget | 213 | Styled markdown renderer with custom builders |

### 7.8 Status & Badge Widgets (3 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareStatusBadge` | `badges/status_badge.dart` | StatelessWidget | 58 | Enum-based status badge |
| `InstaCareHoursSummaryPill` | `pills/hours_summary_pill.dart` | StatelessWidget | 29 | Theme-aware text pill |
| `InstaCareAppointmentStatusPills` | `pills/appointment_status_pills.dart` | StatelessWidget | 55 | Status badge selection row with opacity |

### 7.9 Other Widgets (6 widgets)

| Widget | File | Type | Lines | Description |
|--------|------|------|-------|-------------|
| `InstaCareVerticalStepper` | `steps/stepper.dart` | StatefulWidget | 212 | Animated horizontal step indicator |
| `InstaCareFileUploadTile` | `upload/file_upload_tile.dart` | StatefulWidget | 61 | Upload area with hover/highlight state |
| `InstaCareLogo` | `common/logo.dart` | StatelessWidget | 101 | SVG logo + text |
| `InstaCareLogoIcon` | `common/logo.dart` | StatelessWidget | — | SVG logo only |
| `InstaCareLogoText` | `common/logo.dart` | StatelessWidget | — | Text only |
| `InstaCareNetworkImage` | `common/network_image.dart` | StatelessWidget | 101 | Image loader with shimmer/error + custom `imageBuilder` hook |

### 7.10 Theme & Utility Exports

| Export | File | Lines | Description |
|--------|------|-------|-------------|
| `AppColors` | `theme/color.dart` | 136 | Full color palette (90+ constants, 7 color families + semantic) |
| `InstaCareTypography` | `theme/typography.dart` | 103 | Text styles (h1-h5, r/p/body, m, s, sm, xs) via Google Fonts |
| `InstaCareHeading` | `theme/heading.dart` | 48 | Static header helper methods |
| `ButtonSize` | `types/button_size.dart` | 14 | Enum with height/padding extensions |

---

## 8. Theme System

### 8.1 Color Palette

| Category | Shades | Base Color | Usage |
|----------|--------|------------|-------|
| Primary | 50-900 | `#34513A` (Dark Green) | Main brand, buttons, borders |
| Secondary | 50-900 | `#DC9251` (Orange) | Accents, secondary actions |
| Natural | 50-900 | `#A58E74` (Brown) | Earthy backgrounds |
| Ivory | 50-900 | `#FFEFCD` (Warm Cream) | Input fills, warm backgrounds |
| Gray | 50-900 | `#000000`-`#F8F8F8` | Text, borders, disabled states |
| Error | 50-900 | `#FB0000` (Red) | Error states, destructive actions |
| Success | 50-900 | `#00C400` (Green) | Success feedback |
| Semantic | infoBg/Fg, warningBg/Fg, errorBg/Fg, successBg/Fg, completedBg/Fg | — | Snackbar, message box, attempts card |
| Service Card | background, title, body, accent | `#6F8572` base | Service card defaults |

### 8.2 Typography

| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| h1 | Crimson Pro | 24 | SemiBold (600) | Page titles |
| h2 | Crimson Pro | 20 | Medium (500) | Section titles |
| h3 | Crimson Pro | 18 | Medium (500) | Section inner titles |
| h4 | Crimson Pro | 14 | SemiBold (600) | Small titles |
| h5 | Figtree | 20 | Medium (500) | Alternate heading |
| r | Figtree | 14 | Regular (400) | Body / one-liner (canonical) |
| p / body | (alias for `r`) | 14 | Regular (400) | Body text aliases |
| m | Figtree | 14 | Medium (500) | One-liner medium |
| s | Figtree | 12 | Regular (400) | Small regular |
| sm | Figtree | 12 | Medium (500) | Small medium |
| xs | Figtree | 10 | Medium (500) | Extra small |

**Note:** `p` and `body` are aliases for `r`. No forced `height` value — Flutter uses natural font line height.

---

## 9. Dependency Analysis

| Package | Version | Necessary? | Notes |
|---------|---------|------------|-------|
| `google_fonts` | ^8.0.2 | Yes | Core to design system (Crimson Pro + Figtree) |
| `flutter_svg` | ^2.0.10+1 | Yes | Logo SVG rendering |
| `country_flags` | ^2.2.0 | Yes | PhoneInput country flags |
| `flutter_markdown` | ^0.7.7+1 | Yes | Markdown widget core |
| `markdown` | ^7.3.0 | Yes | Required by flutter_markdown |
| `flutter_lints` | ^4.0.0 | Dev only | Linting rules |

**Total external dependencies: 5** — lean for a UI library. No bloat detected.

---

## 10. File Structure

```
lib/
  instacare_components.dart              # Barrel export (46 lines, 45 exports)
  instacare_components_web.dart          # Web platform (empty)
  src/
    animation/
      carousel.dart                      # 141 lines — Timer.periodic auto-play
      markdown.dart                      # 213 lines — Custom builders + style
      skeleton_loading.dart              # 65 lines  — Gradient shimmer
    badges/
      status_badge.dart                  # 58 lines
    buttons/
      button.dart                        # 203 lines — Primary + secondary variants
    cards/
      attempts_card.dart                 # 233 lines — 3-state (passed/exhausted/progress)
      booking_card.dart                  # 275 lines — Patient booking info
      card.dart                          # 39 lines  — Base card
      card_list_view.dart                # 73 lines
      checkbox_card.dart                 # 90 lines  — Color-customizable
      income_tile.dart                   # 63 lines
      service_card.dart                  # 243 lines — CustomPaint leaf + dots
    common/
      logo.dart                          # 101 lines — 3 variants
      network_image.dart                 # 101 lines — imageBuilder hook
    dialogs/
      confirmation_dialog.dart           # 148 lines — Adaptive sizing
      snackbar.dart                      # 215 lines — Overlay + animation
    feedback/
      message_box.dart                   # 96 lines
      progress_bar.dart                  # 46 lines
    inputs/
      checkbox_field.dart                # 44 lines
      date_picker_field.dart             # 91 lines
      dropdown.dart                      # 252 lines — Overlay + observer
      dropdown_with_checkbox.dart        # 312 lines — Multi-select overlay
      otp_input.dart                     # 167 lines — N controllers/nodes
      phone_input.dart                   # 162 lines — Country flag prefix
      search_bar.dart                    # 56 lines
      text_field.dart                    # 166 lines — Password named constructor
    navigation/
      bottom_app_nav_bar.dart            # 82 lines
      keyboard_aware_scaffold.dart       # 125 lines — Configurable flags
      top_header_title.dart              # 35 lines
    pills/
      appointment_status_pills.dart      # 55 lines
      hours_summary_pill.dart            # 29 lines
    selection/
      filter_pills.dart                  # 31 lines
      mcq_option_selector.dart           # 126 lines — Responsive dots
      pill_chip.dart                     # 45 lines
      radio_buttons.dart                 # 86 lines — Generic, axis support
      rating_scale.dart                  # 33 lines
      service_pills.dart                 # 31 lines
    steps/
      stepper.dart                       # 212 lines — Animated connectors
    theme/
      color.dart                         # 136 lines — 90+ color constants
      heading.dart                       # 48 lines  — Static helpers
      typography.dart                    # 103 lines — 11 styles, 2 fonts
    types/
      button_size.dart                   # 14 lines  — Enum + extension
    upload/
      file_upload_tile.dart              # 61 lines
    assets_patient/                      # SVG/PNG assets
      logo.svg, caretaker.png/svg, liveincare.png/svg,
      nursing.png/svg, physiotheraphy.png/svg
```

**Total:** 45 Dart files, 4,905 lines of code.
