# InstaCare Patient-Side Widgets Documentation

A complete reference for all patient-facing widgets — their properties, default sizes, and how to customize them.

---

## Table of Contents

1. [InstaCareWelcomeHeader](#1-instacarewelcomeheader)
2. [InstaCareServiceCard](#2-instacareservicecard)
3. [InstaCareServiceCategoryGrid](#3-instacareservicecategorygrid)
4. [InstaCareServiceListTile](#4-instacareservicelisttile)
5. [InstaCareBookingCard](#5-instacarebookingcard)
6. [InstaCarePatientPartnerConnect](#6-instacarepatientpartnerconnect)
7. [InstaCareOtpInput](#7-instacareotpinput)
8. [InstaCareSignaturePad](#8-instacaresignaturepad)

---

## 1. InstaCareWelcomeHeader

**File:** `lib/src/navigation/welcome_header.dart`

The top welcome banner with user avatar and search bar.

### Properties

| Property           | Type                       | Default                            | Description                        |
| ------------------ | -------------------------- | ---------------------------------- | ---------------------------------- |
| `userName`         | `String`                   | **required**                       | Display name shown in greeting     |
| `searchHint`       | `String`                   | `'What care do you need today?'`   | Placeholder text in the search bar |
| `searchController` | `TextEditingController?`   | `null`                             | Controller for the search field    |
| `onSearchChanged`  | `ValueChanged<String>?`    | `null`                             | Callback when search text changes  |
| `onAvatarTap`      | `VoidCallback?`            | `null`                             | Callback when avatar is tapped     |

### Fixed Dimensions

| Element              | Value     |
| -------------------- | --------- |
| Avatar radius        | `24`      |
| Avatar icon size     | `26`      |
| Search field padding | `14h, 13v`|
| Search border radius | `8`       |
| Focused border width | `2`       |
| Search icon size     | `22`      |

### Adjustability

- **Avatar size** — Not adjustable via props. Override by wrapping in a custom widget.
- **Search bar** — Hint text is customizable. Colors follow theme (`AppColors`).

### Usage

```dart
InstaCareWelcomeHeader(
  userName: 'John',
  searchHint: 'Search services...',
  onSearchChanged: (query) => print(query),
  onAvatarTap: () => navigateToProfile(),
)
```

---

## 2. InstaCareServiceCard

**File:** `lib/src/cards/service_card.dart`

A visually rich card displaying a service with title, subtitle, and price. Scales responsively.

### Properties

| Property          | Type         | Default                            | Description                     |
| ----------------- | ------------ | ---------------------------------- | ------------------------------- |
| `title`           | `String`     | **required**                       | Main service title              |
| `subtitle`        | `String`     | **required**                       | Description below the title     |
| `priceText`       | `String`     | **required**                       | Price label (e.g. `'$50/hr'`)   |
| `onTap`           | `VoidCallback?` | `null`                          | Tap callback                    |
| `backgroundColor` | `Color`      | `AppColors.serviceCardBackground`  | Card background color           |
| `titleColor`      | `Color`      | `AppColors.serviceCardTitle`       | Title text color                |
| `bodyColor`       | `Color`      | `AppColors.serviceCardBody`        | Subtitle text color             |
| `accentColor`     | `Color`      | `AppColors.serviceCardAccent`      | Accent/price color              |

### Fixed Dimensions (Scale-Responsive)

The card uses a scale factor based on parent constraints. Fallback size: **320 x 146**.

| Element            | Formula                             | Clamp Range    |
| ------------------ | ----------------------------------- | -------------- |
| Border radius      | `10 * scale`                        | `8 – 14`       |
| Horizontal padding | `16 * widthScale`                   | `10 – 22`      |
| Vertical padding   | `14 * heightScale`                  | `8 – 18`       |
| Title font size    | `24 * scale`                        | `16 – 30`      |
| Body font size     | `16 * scale`                        | `12 – 18`      |
| Price font size    | `24 * scale`                        | `14 – 26`      |
| Leaf decoration    | `width * 0.22`                      | `48 – 90`      |

### Adjustability

- **Size** — Adapts to parent constraints. Wrap in a `SizedBox` or `ConstrainedBox` to control size.
- **Colors** — All 4 color slots (background, title, body, accent) are fully customizable.
- **Font sizes** — Auto-scaled based on card size. Not directly adjustable.

### Usage

```dart
SizedBox(
  width: 300,
  height: 140,
  child: InstaCareServiceCard(
    title: 'Nursing Care',
    subtitle: 'Professional nursing at home',
    priceText: '\$45/hr',
    backgroundColor: Colors.teal.shade50,
    onTap: () => navigateToService(),
  ),
)
```

---

## 3. InstaCareServiceCategoryGrid

**File:** `lib/src/cards/service_category_grid.dart`

A 2-column grid of service categories with icons and labels.

### Properties

| Property        | Type                                        | Default      | Description                          |
| --------------- | ------------------------------------------- | ------------ | ------------------------------------ |
| `categories`    | `List<InstaCareServiceCategory>`            | **required** | List of category data objects        |
| `onCategoryTap` | `ValueChanged<InstaCareServiceCategory>?`   | `null`       | Callback when a category is tapped   |

### InstaCareServiceCategory Model

| Field         | Type       |
| ------------- | ---------- |
| `title`       | `String`   |
| `subtitle`    | `String`   |
| `imagePath`   | `String`   |

### Fixed Dimensions

| Element           | Value      |
| ----------------- | ---------- |
| Grid columns      | `2`        |
| Main axis spacing | `12`       |
| Cross axis spacing| `12`       |
| Child aspect ratio| `1.35`     |
| Card border radius| `12`       |
| Card padding      | `14` all   |
| Dialog icon size  | `120 x 120`|

### Adjustability

- **Grid layout** — Column count (2), spacing (12), and aspect ratio (1.35) are hardcoded. To change, modify the source.
- **Content** — Fully driven by the `categories` list. Add/remove categories dynamically.
- **Card appearance** — Colors follow the theme. Not customizable via props.

### Usage

```dart
InstaCareServiceCategoryGrid(
  categories: [
    InstaCareServiceCategory(
      title: 'Nursing',
      subtitle: 'Home nursing care',
      imagePath: 'assets/nursing.png',
    ),
    InstaCareServiceCategory(
      title: 'Physiotherapy',
      subtitle: 'Rehab & therapy',
      imagePath: 'assets/physio.png',
    ),
  ],
  onCategoryTap: (cat) => print(cat.title),
)
```

---

## 4. InstaCareServiceListTile

**File:** `lib/src/cards/service_list_tile.dart`

A vertical list of service items with image, title, description, duration, and optional "New" badge.

### Properties

| Property       | Type                                      | Default   | Description                        |
| -------------- | ----------------------------------------- | --------- | ---------------------------------- |
| `items`        | `List<InstaCareServiceListItem>`          | **required** | List of service items           |
| `newBadgeLabel`| `String`                                  | `'New'`   | Text for the "new" badge           |
| `onItemTap`    | `ValueChanged<InstaCareServiceListItem>?` | `null`    | Callback when an item is tapped    |

### InstaCareServiceListItem Model

| Field         | Type     |
| ------------- | -------- |
| `title`       | `String` |
| `description` | `String` |
| `duration`    | `String` |
| `imagePath`   | `String?`|
| `isNew`       | `bool`   |

### Fixed Dimensions

| Element              | Value        |
| -------------------- | ------------ |
| Image/placeholder    | `90 x 90`   |
| Image border radius  | `8`          |
| Card border radius   | `12`         |
| Card padding         | `10` all     |
| Badge padding        | `10h, 3v`    |
| Badge border radius  | `20`         |
| Time icon size       | `14`         |
| Placeholder icon     | `32`         |

### Adjustability

- **Image size** — Fixed at 90x90. Not adjustable via props.
- **Badge text** — Customizable via `newBadgeLabel`.
- **Item count** — Dynamically driven by the `items` list.
- **Colors** — Follow theme defaults. Not customizable via props.

### Usage

```dart
InstaCareServiceListTile(
  newBadgeLabel: 'NEW',
  items: [
    InstaCareServiceListItem(
      title: 'Live-in Care',
      description: '24/7 home care support',
      duration: '8 hrs',
      imagePath: 'assets/livein.png',
      isNew: true,
    ),
  ],
  onItemTap: (item) => print(item.title),
)
```

---

## 5. InstaCareBookingCard

**File:** `lib/src/cards/booking_card.dart`

Displays a booking summary with patient info, service details, location, date/time, and status badge.

### Properties

| Property                     | Type                      | Default                           | Description                           |
| ---------------------------- | ------------------------- | --------------------------------- | ------------------------------------- |
| `category`                   | `String`                  | **required**                      | Service category label                |
| `serviceName`                | `String`                  | **required**                      | Name of the booked service            |
| `patientName`                | `String`                  | **required**                      | Patient display name                  |
| `bookingId`                  | `String`                  | **required**                      | Booking reference ID                  |
| `location`                   | `String`                  | **required**                      | Appointment location                  |
| `dateTime`                   | `String`                  | **required**                      | Date and time display string          |
| `durationText`               | `String?`                 | `null`                            | Optional duration label               |
| `status`                     | `InstaCareStatusBadgeType`| `InstaCareStatusBadgeType.active`  | Status badge type                     |
| `backgroundColor`            | `Color?`                  | `null`                            | Card background color override        |
| `bookingIdPrefix`            | `String`                  | **required**                      | Prefix before booking ID              |
| `inTravelStatusLabel`        | `String`                  | **required**                      | Label for in-travel status            |
| `fallbackPatientInitial`     | `String`                  | **required**                      | Fallback letter for avatar            |
| `categoryServiceSeparator`   | `String`                  | **required**                      | Separator between category & service  |

### Fixed Dimensions

| Element              | Value         |
| -------------------- | ------------- |
| Patient avatar radius| `12`          |
| Category pill padding| `10h, 6v`     |
| Category pill radius | `999` (fully rounded) |
| Location icon size   | `14`          |
| Calendar icon size   | `13`          |

### Adjustability

- **Background color** — Customizable via `backgroundColor`.
- **Status** — Controlled by `status` prop (active, completed, cancelled, etc.).
- **Labels/text** — All label strings are customizable (prefix, separator, etc.).
- **Card size** — Expands to fill parent width. Wrap in `SizedBox` to constrain.

### Usage

```dart
InstaCareBookingCard(
  category: 'Nursing',
  serviceName: 'Home Nursing',
  patientName: 'Jane Doe',
  bookingId: 'BK-12345',
  location: '123 Main St',
  dateTime: 'Mar 12, 2026 · 10:00 AM',
  durationText: '2 hours',
  status: InstaCareStatusBadgeType.active,
  bookingIdPrefix: 'ID:',
  inTravelStatusLabel: 'In Transit',
  fallbackPatientInitial: 'J',
  categoryServiceSeparator: ' · ',
)
```

---

## 6. InstaCarePatientPartnerConnect

**File:** `lib/src/cards/patient_partner_connect.dart`

Shows a patient-partner pairing with avatars connected by a dotted line.

### Properties

| Property        | Type       | Default      | Description                         |
| --------------- | ---------- | ------------ | ----------------------------------- |
| `patientName`   | `String`   | **required** | Patient display name                |
| `patientLabel`  | `String`   | `'Patient'`  | Label below patient name            |
| `patientAvatar` | `Widget?`  | `null`        | Custom avatar widget for patient   |
| `partnerName`   | `String`   | **required** | Partner display name                |
| `partnerLabel`  | `String`   | `'Partner'`  | Label below partner name            |
| `partnerAvatar` | `Widget?`  | `null`        | Custom avatar widget for partner   |

### Fixed Dimensions

| Element              | Value       |
| -------------------- | ----------- |
| Container padding    | `20h, 18v`  |
| Container radius     | `12`        |
| Default avatar radius| `26`        |
| Connect icon size    | `28`        |
| Dotted line width    | `full width`|

### Adjustability

- **Avatars** — Pass any custom `Widget` via `patientAvatar` / `partnerAvatar` to fully replace the default `CircleAvatar`.
- **Labels** — Both `patientLabel` and `partnerLabel` are customizable.
- **Size** — Fixed padding/radius. Card expands to parent width.

### Usage

```dart
InstaCarePatientPartnerConnect(
  patientName: 'John Doe',
  patientLabel: 'Patient',
  partnerName: 'Dr. Smith',
  partnerLabel: 'Caregiver',
  partnerAvatar: CircleAvatar(
    radius: 26,
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
)
```

---

## 7. InstaCareOtpInput

**File:** `lib/src/inputs/otp_input.dart`

A row of individual digit input cells for OTP verification.

### Properties

| Property      | Type                    | Default | Description                              |
| ------------- | ----------------------- | ------- | ---------------------------------------- |
| `length`      | `int`                   | `6`     | Number of OTP digits                     |
| `onCompleted` | `ValueChanged<String>?` | `null`  | Callback when all digits are entered     |
| `onChanged`   | `ValueChanged<String>?` | `null`  | Callback on each digit change            |

### Dynamic Dimensions

Cell size is **calculated automatically** based on available width:

| Element         | Formula                                              | Clamp Range |
| --------------- | ---------------------------------------------------- | ----------- |
| Cell size       | `(availableWidth - totalSpacing - 32) / length`      | `40 – 56`   |
| Font size       | `cellSize * 0.45`                                    | `16 – 24`   |
| Border radius   | `cellSize * 0.25`                                    | `10 – 14`   |
| Cell spacing    | Fixed `8`                                            | —           |

### Adjustability

- **Digit count** — Change `length` to support 4-digit, 6-digit, or any length OTP.
- **Cell size** — Auto-scales to fit available width. Constrain parent width to control cell size.
- **Colors/fonts** — Follow theme. Not directly adjustable via props.

### Usage

```dart
InstaCareOtpInput(
  length: 4,
  onCompleted: (otp) => verifyOtp(otp),
  onChanged: (value) => print('Current: $value'),
)
```

---

## 8. InstaCareSignaturePad

**File:** `lib/src/inputs/signature_pad.dart`

A drawable canvas for capturing patient signatures. Stays sticky inside scroll views.

### Properties

| Property          | Type                                   | Default              | Description                        |
| ----------------- | -------------------------------------- | -------------------- | ---------------------------------- |
| `label`           | `String`                               | `'Signature'`        | Label text above the pad           |
| `clearLabel`      | `String`                               | `'Clear'`            | Clear button text                  |
| `height`          | `double`                               | `200`                | Height of the drawing area         |
| `strokeColor`     | `Color`                                | `AppColors.gray2`    | Drawing stroke color               |
| `strokeWidth`     | `double`                               | `2.0`                | Drawing stroke thickness           |
| `backgroundColor` | `Color`                                | `AppColors.baseWhite`| Canvas background color            |
| `borderColor`     | `Color`                                | `AppColors.primary8` | Border color around the pad        |
| `onChanged`       | `ValueChanged<List<List<Offset>>>?`    | `null`               | Callback with stroke data          |

### Fixed Dimensions

| Element          | Value            |
| ---------------- | ---------------- |
| Canvas height    | `widget.height` (default 200) |
| Canvas width     | `full width`     |
| Border radius    | `12`             |
| Border width     | `1`              |
| Label-pad gap    | `8`              |

### Adjustability

- **Height** — Fully adjustable via the `height` prop (default 200).
- **Width** — Always fills parent width (`double.infinity`).
- **Stroke** — Both `strokeColor` and `strokeWidth` are adjustable.
- **Background & border** — Customizable via `backgroundColor` and `borderColor`.
- **Labels** — Both `label` and `clearLabel` text can be changed.

### Public Methods (via GlobalKey)

| Method      | Returns           | Description                    |
| ----------- | ----------------- | ------------------------------ |
| `clear()`   | `void`            | Clears all strokes             |
| `toImage()` | `Future<ui.Image?>`| Exports signature as an image |
| `isEmpty`   | `bool`            | Whether the pad has any strokes|

### Usage

```dart
final signatureKey = GlobalKey<InstaCareSignaturePadState>();

InstaCareSignaturePad(
  key: signatureKey,
  height: 250,
  strokeColor: Colors.black,
  strokeWidth: 3.0,
  label: 'Patient Signature',
  clearLabel: 'Reset',
  onChanged: (strokes) => print('${strokes.length} strokes'),
)

// Clear programmatically
signatureKey.currentState?.clear();

// Export as image
final image = await signatureKey.currentState?.toImage();
```

---

## Quick Reference: What's Adjustable vs Fixed

| Widget                  | Size         | Colors       | Text/Labels  | Layout       |
| ----------------------- | ------------ | ------------ | ------------ | ------------ |
| WelcomeHeader           | Fixed        | Theme only   | Hint text    | Fixed        |
| ServiceCard             | Auto-scales  | All 4 colors | All text     | Auto-scales  |
| ServiceCategoryGrid     | Fixed grid   | Theme only   | Via data     | Fixed 2-col  |
| ServiceListTile         | Fixed 90x90  | Theme only   | Badge text   | Fixed        |
| BookingCard             | Full width   | Background   | All labels   | Fixed        |
| PatientPartnerConnect   | Full width   | Theme only   | Both labels  | Fixed        |
| OtpInput                | Auto-scales  | Theme only   | —            | Auto-scales  |
| SignaturePad             | Height prop  | All colors   | Both labels  | Full width   |
