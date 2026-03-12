# Instacare UI Plugin - Complete Detailed Documentation

This file is a full reference for the `instacare_components` plugin:
- what the plugin is
- exact folder/file structure
- scripts
- every public callable name
- each symbol type
- what arguments you must pass (name + type)
- practical usage examples

---

## 1) What This Plugin Is

`instacare_components` is a reusable Flutter UI component plugin used to build Instacare screens quickly with:
- shared design tokens (`AppColors`, `InstaCareTypography`, `ButtonSize`)
- prebuilt widgets for buttons, forms, cards, selection, feedback, dialogs, navigation, upload, animation, markdown, and step progress

Package info (from `instacare_components/pubspec.yaml`):
- Package name: `instacare_components`
- Version: `1.0.0`
- Dart SDK: `>=3.0.0 <4.0.0`
- Flutter: `>=3.16.0`
- Extra dependencies: `country_flags`, `flutter_markdown`, `markdown`

---

## 2) Exact Repository Structure

```text
instacare-ui-plugin/
  .git/
  .vscode/
  components list.png
  create-plugin.sh
  READ.md
  README.md
  instacare_components/
    .dart_tool/
    android/
    build/
    docs/
      component_size_typography.md
    example/
    ios/
    lib/
      instacare_components.dart
      src/
        animation/
          carousel.dart
          skeleton_loading.dart
          markdown.dart
        badges/
          status_badge.dart
        buttons/
          button.dart
        cards/
          attempts_card.dart
          booking_card.dart
          card.dart
          card_list_view.dart
          checkbox_card.dart
          income_tile.dart
          service_card.dart
        dialogs/
          confirmation_dialog.dart
          snackbar.dart
        feedback/
          message_box.dart
          progress_bar.dart
        inputs/
          checkbox_field.dart
          date_picker_field.dart
          dropdown.dart
          dropdown_with_checkbox.dart
          otp_input.dart
          phone_input.dart
          search_bar.dart
          text_field.dart
        navigation/
          bottom_app_nav_bar.dart
          top_header_title.dart
        pills/
          appointment_status_pills.dart
          hours_summary_pill.dart
        selection/
          filter_pills.dart
          mcq_option_selector.dart
          pill_chip.dart
          radio_buttons.dart
          rating_scale.dart
          service_pills.dart
        steps/
          stepper.dart
        theme/
          color.dart
          heading.dart
          typography.dart
        types/
          button_size.dart
        upload/
          file_upload_tile.dart
    macos/
    test/
    .gitignore
    .metadata
    analysis_options.yaml
    LICENSE
    pubspec.lock
    pubspec.yaml
```

### Folder Purpose
- `instacare_components/lib/src/theme`: design system tokens and heading helpers
- `instacare_components/lib/src/types`: shared enum/style types
- `instacare_components/lib/src/*`: reusable UI components grouped by domain
- `instacare_components/lib/instacare_components.dart`: one public export barrel
- `instacare_components/example`: demo/gallery app for manual testing
- `instacare_components/test`: automated tests
- `instacare_components/docs`: package-level docs
- `create-plugin.sh`: script that bootstraps/regenerates the plugin skeleton

---

## 3) Script Documentation

### `create-plugin.sh`
Type: Bash setup script

What it does:
1. Deletes existing `instacare_components` folder (if present)
2. Runs `flutter create --template=plugin ...`
3. Rewrites platform/plugin stub files
4. Rewrites `pubspec.yaml`
5. Creates starter components and exports
6. Creates example app themes and demo screen

Use when:
- you need to regenerate the plugin scaffold from scratch
- you are rebuilding baseline files quickly

Important:
- it is destructive (`rm -rf instacare_components`)

---

## 4) Public Import and How To Call

### Single import
```dart
import 'package:instacare_components/instacare_components.dart';
```

Everything below is exported by that one import.

---

## 5) Global Design Tokens

### 5.1 `AppColors` (Type: class of static `Color` constants)
Call name: `AppColors.<token>`

Examples:
- `AppColors.primary1`
- `AppColors.gray4`
- `AppColors.infoBg`
- `AppColors.successFg`

Groups:
- base: `baseWhite`, `basePrimary`, `baseSecondary`, `baseNatural`, `baseIvory`
- primary: `primary1` ... `primary10`
- secondary: `secondary1` ... `secondary10`
- natural: `natural1` ... `natural10`
- ivory: `ivory1` ... `ivory10`
- gray: `gray1` ... `gray9`
- error: `error1` ... `error10`
- success: `success1` ... `success10`
- semantic: `infoBg`, `infoFg`, `warningBg`, `warningFg`, `errorBg`, `errorFg`, `successBg`, `successFg`, `completedBg`, `completedFg`
- service card defaults: `serviceCardBackground`, `serviceCardTitle`, `serviceCardBody`, `serviceCardAccent`

### 5.2 `InstaCareTypography` (Type: class of static `TextStyle` tokens)
Call name: `InstaCareTypography.<token>`

Font families:
- heading: `CrimsonPro`
- body: `Figtree`

Tokens:
- `h1`, `h2`, `h3`
- `body`, `r`, `m`, `s`, `sm`, `xs`

### 5.3 `ButtonSize` (Type: enum)
Call name: `ButtonSize.small|medium|large`

Extension values:
- `ButtonSize.small.height = 40`, padding `h16 v10`
- `ButtonSize.medium.height = 48`, padding `h24 v12`
- `ButtonSize.large.height = 56`, padding `h32 v16`

---

## 6) Full API Catalog (Name, Type, What To Pass)

### Legend
- Required: must pass
- Optional: can skip
- Default: used when skipped

| Call Name | Symbol Type | Required Parameters (name: type) | Optional Parameters (name: type = default) |
|---|---|---|---|
| `InstaCareSkeletonLoading(...)` | `StatefulWidget` | none | `width: double?`, `height: double = 14`, `borderRadius: BorderRadiusGeometry = Radius.circular(8)`, `baseColor: Color?`, `highlightColor: Color?`, `duration: Duration = 1200ms` |
| `InstaCareCarousel(...)` | `StatefulWidget` | `items: List<Widget>` | `height: double = 200`, `autoPlayDuration: Duration = 3s`, `autoPlay: bool = true`, `showIndicators: bool = true`, `indicatorActiveColor: Color?`, `indicatorInactiveColor: Color?`, `padding: EdgeInsetsGeometry?`, `viewportFraction: double = 0.9`, `onPageChanged: ValueChanged<int>?` |
| `InstaCareMarkdown(...)` | `StatelessWidget` | `data: String` | `padding: EdgeInsetsGeometry?`, `styleSheet: MarkdownStyleSheet?`, `onTapLink: void Function(String,String?,String)?`, `selectable: bool = false`, `imageDirectory: String?`, `maxImageHeight: double = 240` |
| `InstaCareStatusBadge(...)` | `StatelessWidget` | `label: String` | `type: InstaCareStatusBadgeType = custom` |
| `InstaCareButton(...)` | `StatelessWidget` | `text: String` | `onPressed: VoidCallback?`, `isLoading: bool = false`, `size: ButtonSize = medium`, `icon: IconData?`, `fullWidth: bool = false`, `isDisabled: bool = false` |
| `InstaCareButton.secondary(...)` | named constructor | `text: String` | same optional fields as primary |
| `InstaCareCard(...)` | `StatelessWidget` | `child: Widget` | `padding: EdgeInsetsGeometry?`, `onTap: VoidCallback?`, `backgroundColor: Color?`, `elevation: double?` |
| `InstaCareBookingCard(...)` | `StatelessWidget` | `category: String`, `serviceName: String`, `patientName: String`, `bookingId: String`, `location: String`, `dateTime: String`, `bookingIdPrefix: String`, `inTravelStatusLabel: String`, `fallbackPatientInitial: String`, `categoryServiceSeparator: String` | `durationText: String?`, `status: InstaCareStatusBadgeType = active`, `backgroundColor: Color?` |
| `InstaCareCardListItem(...)` | data class | `card: Widget`, `title: String`, `body: String` | none |
| `InstaCareCardListView(...)` | `StatelessWidget` | `items: List<InstaCareCardListItem>` | `spacing: double = 12`, `cardWidth: double = 84` |
| `InstaCareServiceCard(...)` | `StatelessWidget` | `title: String`, `subtitle: String`, `priceText: String` | `onTap: VoidCallback?`, `backgroundColor: Color = serviceCardBackground`, `titleColor: Color = serviceCardTitle`, `bodyColor: Color = serviceCardBody`, `accentColor: Color = serviceCardAccent` |
| `InstaCareCheckboxCard(...)` | `StatelessWidget` | `title: String`, `message: String`, `isSelected: bool` | `onChanged: ValueChanged<bool>?`, `backgroundColor: Color?`, `selectedBackgroundColor: Color?`, `borderColor: Color?`, `selectedBorderColor: Color?` |
| `InstaCareAttemptsCard(...)` | `StatelessWidget` | `totalAttempts: int`, `usedAttempts: int`, `hasPassed: bool` | none |
| `InstaCareIncomeTile(...)` | `StatelessWidget` | `title: String`, `amount: String`, `redeemButtonText: String` | `onRedeem: VoidCallback?`, `backgroundColor: Color?` |
| `InstaCareTextField(...)` | `StatefulWidget` | none | `label: String?`, `hint: String?`, `controller: TextEditingController?`, `obscureText: bool = false`, `keyboardType: TextInputType?`, `prefixIcon: IconData?`, `suffixIcon: Widget?`, `onChanged: ValueChanged<String>?`, `maxLines: int? = 1`, `enabled: bool = true`, `showPasswordToggle: bool = false`, `errorText: String?`, `validator: FormFieldValidator<String>?`, `fillColor: Color?`, `borderColor: Color?`, `focusedBorderColor: Color?`, `hintColor: Color?`, `labelColor: Color?`, `borderRadius: double = 8` |
| `InstaCareTextField.password(...)` | named constructor | none | `label: String?`, `hint: String?`, `controller: TextEditingController?`, `onChanged: ValueChanged<String>?`, `enabled: bool = true`, `errorText: String?`, `validator: FormFieldValidator<String>?`, `fillColor: Color?`, `borderColor: Color?`, `focusedBorderColor: Color?`, `hintColor: Color?`, `labelColor: Color?`, `borderRadius: double = 8` |
| `InstaCareOtpInput(...)` | `StatefulWidget` | none | `length: int = 6`, `onCompleted: ValueChanged<String>?`, `onChanged: ValueChanged<String>?` |
| `InstaCareDropdown<T>(...)` | `StatefulWidget` | `items: List<T>` | `label: String?`, `hint: String?`, `value: T?`, `onChanged: ValueChanged<T?>?`, `itemLabel: String Function(T)?`, `initiallyExpanded: bool = false` |
| `InstaCareDropdownWithCheckbox<T>(...)` | `StatefulWidget` | `items: List<T>`, `selectedItems: Set<T>`, `onChanged: ValueChanged<Set<T>>` | `itemLabel: String Function(T)?`, `hint: String?`, `label: String?`, `initiallyExpanded: bool = false` |
| `InstaCareCheckboxField(...)` | `StatelessWidget` | `value: bool`, `onChanged: ValueChanged<bool?>`, `label: String` | none |
| `InstaCareDatePickerField(...)` | `StatelessWidget` | none | `label: String?`, `value: DateTime?`, `onChanged: ValueChanged<DateTime>?`, `hint: String = 'mm/dd/yyyy'` |
| `InstaCarePhoneInput(...)` | `StatelessWidget` | none | `label: String?`, `hint: String?`, `controller: TextEditingController?`, `onChanged: ValueChanged<String>?`, `countryCode: String = '+91'`, `countryIsoCode: String = 'IN'`, `errorText: String?`, `validator: FormFieldValidator<String>?`, `maxDigits: int = 10` |
| `InstaCareSearchBar(...)` | `StatelessWidget` | none | `hint: String = 'Search'`, `controller: TextEditingController?`, `onChanged: ValueChanged<String>?` |
| `showInstaCareConfirmationDialog(...)` | `Future<bool>` function | `context: BuildContext`, `title: String`, `body: String` | `confirmText: String = 'Remove'`, `cancelText: String = 'Cancel'` |
| `InstaCareSnackbar.show(...)` | static method (`void`) | `context: BuildContext`, `type: InstaCareSnackbarType`, `title: String`, `message: String` | `duration: Duration = 4s`, `onClose: VoidCallback?` |
| `InstaCareMessageBox(...)` | `StatelessWidget` | `type: InstaCareMessageType`, `title: String`, `body: String` | none |
| `InstaCareProgressBar(...)` | `StatelessWidget` | `value: double` | `label: String?` |
| `InstaCareBottomNavItem(...)` | data class | `icon: IconData`, `label: String` | none |
| `InstaCareBottomAppNavBar(...)` | `StatelessWidget` | `currentIndex: int`, `onTap: ValueChanged<int>`, `items: List<InstaCareBottomNavItem>` | `backgroundColor: Color?`, `selectedItemColor: Color?`, `unselectedItemColor: Color?`, `topBorderColor: Color?`, `showShadow: bool = false` |
| `InstaCareTopHeaderTitle(...)` | `StatelessWidget` + `PreferredSizeWidget` | `title: String` | `actions: List<Widget>?`, `onBack: VoidCallback?` |
| `InstaCareHoursSummaryPill(...)` | `StatelessWidget` | `text: String` | none |
| `InstaCareAppointmentStatusPills(...)` | `StatelessWidget` | none | `items: List<InstaCareStatusBadgeType> = [active,upcoming,cancelled,inTravel,completed]`, `selected: InstaCareStatusBadgeType?`, `onSelected: ValueChanged<InstaCareStatusBadgeType>?` |
| `InstaCarePillChip(...)` | `StatelessWidget` | `label: String`, `selected: bool`, `onTap: VoidCallback` | none |
| `InstaCareFilterPills(...)` | `StatelessWidget` | `items: List<String>`, `selected: Set<String>`, `onToggle: ValueChanged<String>` | none |
| `InstaCareServicePills(...)` | `StatelessWidget` | `services: List<String>`, `selected: String?`, `onSelected: ValueChanged<String>` | none |
| `InstaCareRadioOption<T>(...)` | data class | `value: T`, `label: String` | none |
| `InstaCareRadioButtons<T>(...)` | `StatelessWidget` | `groupValue: T?`, `onChanged: ValueChanged<T?>`, `options: List<InstaCareRadioOption<T>>` | `direction: Axis = Axis.vertical` |
| `InstaCareRatingScale(...)` | `StatelessWidget` | `currentRating: int`, `onRatingChanged: ValueChanged<int>` | `maxRating: int = 5` |
| `InstaCareMcqOptionSelector(...)` | `StatelessWidget` | `question: String`, `options: List<String>`, `selected: String?`, `onSelected: ValueChanged<String>`, `previousLabel: String`, `nextLabel: String` | `onPrevious: VoidCallback?`, `onNext: VoidCallback?` |
| `InstaCareStepperItem(...)` | data class | `title: String` | `description: String?` |
| `InstaCareVerticalStepper(...)` | `StatefulWidget` | `items: List<InstaCareStepperItem>`, `currentStep: int` | `onStepChanged: ValueChanged<int>?`, `animationDuration: Duration = 600ms` |
| `InstaCareFileUploadTile(...)` | `StatefulWidget` | `onTap: VoidCallback` | `title: String = 'Click to upload files'`, `subtitle: String = 'PDF, PNG, JPEG OR JPG (Max 10 MB)'` |
| `InstaCareHeading.topHeaderTitle(...)` | static helper -> `Widget` | `text: String` | none |
| `InstaCareHeading.titleWithBackButton(...)` | static helper -> `Widget` | `text: String` | `onBackPressed: VoidCallback?` |
| `AppColors` | static token class | none | call static color constants |
| `InstaCareTypography` | static token class | none | call static text style constants |
| `ButtonSize` | enum | choose one enum value | `small`, `medium`, `large` |

---

## 7) Enum Reference

### `InstaCareStatusBadgeType`
- `active`
- `upcoming`
- `cancelled`
- `inTravel`
- `completed`
- `custom`

### `InstaCareMessageType`
- `info`
- `error`
- `pending`
- `success`

### `InstaCareSnackbarType`
- `info`
- `error`
- `pending`
- `success`

### `ButtonSize`
- `small`
- `medium`
- `large`

---

## 8) How To Use (Category Examples)

### 8.1 Basic Setup
```dart
import 'package:flutter/material.dart';
import 'package:instacare_components/instacare_components.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InstaCareTopHeaderTitle(title: 'Demo'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InstaCareButton(text: 'Continue', onPressed: () {}),
            const SizedBox(height: 12),
            const InstaCareTextField(label: 'Name', hint: 'Enter name'),
          ],
        ),
      ),
    );
  }
}
```

### 8.2 Dialog + Snackbar
```dart
final ok = await showInstaCareConfirmationDialog(
  context: context,
  title: 'Delete Item',
  body: 'Are you sure?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
);

if (ok) {
  InstaCareSnackbar.show(
    context: context,
    type: InstaCareSnackbarType.success,
    title: 'Deleted',
    message: 'Item deleted successfully',
  );
}
```

### 8.3 Selection + Steps
```dart
InstaCareRadioButtons<String>(
  groupValue: selected,
  options: const [
    InstaCareRadioOption(value: 'yes', label: 'Yes'),
    InstaCareRadioOption(value: 'no', label: 'No'),
  ],
  onChanged: (v) => setState(() => selected = v),
)

InstaCareVerticalStepper(
  items: const [
    InstaCareStepperItem(title: 'Profile'),
    InstaCareStepperItem(title: 'Documents'),
    InstaCareStepperItem(title: 'Complete'),
  ],
  currentStep: 1,
)
```

### 8.4 Tokens
```dart
Container(
  color: AppColors.ivory7,
  child: Text(
    'Instacare',
    style: InstaCareTypography.h2.copyWith(
      color: AppColors.primary2,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### 8.5 Markdown Renderer
```dart
InstaCareMarkdown(
  data: '''
# Title

- [x] Task
- [ ] Pending

| Name | Value |
| --- | --- |
| A | 1 |
''',
  selectable: true,
  onTapLink: (text, href, title) {
    // Handle links
  },
)
```

---

## 9) Folder-to-Use Mapping (Quick)

- `src/theme`: color and typography tokens, heading helpers
- `src/types`: size enums and size logic
- `src/buttons`: all button variants
- `src/inputs`: forms and input widgets
- `src/cards`: card components and card item models
- `src/selection`: chips/radio/mcq/rating choices
- `src/feedback`: inline message/progress UI
- `src/dialogs`: modal dialog and snackbar overlay
- `src/navigation`: app top/bottom navigation widgets
- `src/pills`: compact status/summary pills
- `src/steps`: stepper progression UI
- `src/animation`: skeleton, carousel, and markdown renderer
- `src/upload`: file upload tile

---

## 10) Integration Checklist

1. Add dependency in app `pubspec.yaml`.
2. Import only `package:instacare_components/instacare_components.dart`.
3. Use tokens (`AppColors`, `InstaCareTypography`, `ButtonSize`) for consistency.
4. Use provided enums (`InstaCareStatusBadgeType`, `InstaCareMessageType`, `InstaCareSnackbarType`) instead of string literals.
5. For forms, pass controllers + validators from parent screen state.
6. For overlays/dialogs, always pass the current `BuildContext`.
7. Validate on small screens (many widgets are responsive).

---

## 11) Important Notes

- `InstaCareTopHeaderTitle` uses default AppBar text style unless your app theme overrides it.
- `InstaCareRadioButtons` label text uses default `Text()` style (not tokenized in component).
- `InstaCareBookingCard` has several required display-label strings (`bookingIdPrefix`, etc.); pass all of them.
- Example app (`example/lib/main.dart`) includes a Markdown demo with a toggle to switch between raw markdown text and rendered output using a slide animation.
- `create-plugin.sh` is for scaffold generation and can wipe existing package folder.

---

## 12) Where To Extend

If you add new components:
1. Place file under correct `lib/src/<group>/` folder.
2. Export it in `lib/instacare_components.dart`.
3. Add usage demo in `example/lib/main.dart`.
4. Add/update docs in `instacare_components/docs/` and this `READ.md`.
