# Instacare Widget Size and Font Documentation

Source scope: `instacare_components/lib/src/**`

## Global Fonts
- Heading font family: `CrimsonPro`
- Body font family: `Figtree`

## Typography Tokens
- `h1`: `CrimsonPro`, 24, `w500`
- `h2`: `CrimsonPro`, 20, `w500`
- `h3`: `CrimsonPro`, 18, `w500`
- `body`: `Figtree`, 14, `w400`
- `r`: `Figtree`, 14, `w400`
- `m`: `Figtree`, 14, `w500`
- `s`: `Figtree`, 12, `w400`
- `sm`: `Figtree`, 12, `w500`
- `xs`: `Figtree`, 10, `w500`

## Button Size Tokens
- `small`: height 40, padding `h16 v10`
- `medium`: height 48, padding `h24 v12`
- `large`: height 56, padding `h32 v16`

## Widget-by-Widget Specs

| Widget | Main Size Values | Label Font | No-Label / Content Font |
|---|---|---|---|
| `InstaCareButton` | minHeight `max(size.height, 48)`, radius 8 (primary) / 10 (secondary), icon gap 8 | N/A | Text: `r` (`Figtree`), dynamic size `13-16`, weight `w400` unless externally changed |
| `InstaCareSkeletonLoading` | default height 14, default radius 8 | N/A | N/A |
| `InstaCareCarousel` | default height 200, viewport 0.9, indicator `24x8` active / `8x8` inactive, indicator radius 4 | N/A | N/A |
| `InstaCareStatusBadge` | padding `h12 v7`, radius 999 | Label text: `r`, `w600` | Same as label |
| `InstaCareCard` | radius 12, default padding 16 | N/A | N/A |
| `InstaCareBookingCard` | avatar radius 12, status chip padding `h10 v6`, chip radius 999, icon sizes 14/13, gaps 8/10/4 | N/A | All text uses `r`; patient/initial `w700`; others mostly `w400` |
| `InstaCareCardListView` | default spacing 12, default card width 84, title-body gap 4 | N/A | Title: `r w600`; Body: `r w400` |
| `InstaCareCheckboxCard` | radius 8, padding 16, checkbox box `20x20`, border width 1 or 1.5 | Title is label-like: `r w600` | Message: `r w400` |
| `InstaCareAttemptsCard` | card radius 12, padding 12/16 responsive, progress segment height 8, icon container 40/44 | N/A | All text uses `r`; headings `w700`, foot label `w600`, body `w400` |
| `InstaCareIncomeTile` | amount size 56, gaps 8 and 16 | N/A | Title: `h2` overridden to 18 `w500`; Amount: `h1` overridden to 56 `w700` |
| `InstaCareServiceCard` | responsive radius `8-14`, dynamic paddings, title `16-30`, subtitle `12-18`, price `14-26` | N/A | Title: `h1` dynamic; Subtitle: `body`; Price: `h3` dynamic |
| `InstaCareTextField` | default radius 8, content padding `h16 v14`, focused border width 2, label gap 8 | Optional label: `r w600` | Input: `r w400`; Hint: `r w400` |
| `InstaCareOtpInput` | cell size `40-56`, spacing 8, radius `10-14`, focused border width 2 | N/A | OTP digit text: `h3` with dynamic size `16-24`, `w700` |
| `InstaCareDropdown` | field radius 8, field padding `h16 v14`, list maxHeight 220, list item padding `h16 v12` | Optional label: `r w600` | Field text: `r w400`; list item: `r w400` (selected `w500`) |
| `InstaCareDropdownWithCheckbox` | field radius 8, field padding `h16 v14`, list maxHeight 220, item padding `h12 v10`, checkbox box `18x18` | Optional label: `r w600` | Field text: `r w400`; item text: `r w400` |
| `InstaCareCheckboxField` | tap padding `h2 v2`, wrapper radius 8 | Label: `r w400` | Same as label |
| `InstaCareDatePickerField` | field radius 8, content padding `h16 v14`, focused border width 2, label gap 8 | Optional label: `r w600` | Date/hint text: `r w400` |
| `InstaCarePhoneInput` | radius 8, flag size 20, prefix outer padding 16, content padding `h16 v14`, focused border width 2 | Optional label: `r w600` | Input: `r w400`; Hint: `r w400`; country code: `r w400` |
| `InstaCareSearchBar` | radius 8, content padding `h16 v14`, focused border width 2 | N/A | Input: `r w400`; Hint: `r w400` |
| `InstaCarePillChip` | padding `h12 v8`, radius 999 | Label text: `r w600` | Same as label |
| `InstaCareFilterPills` | wrap spacing 8, runSpacing 8 | Uses `InstaCarePillChip` | Uses `InstaCarePillChip` |
| `InstaCareServicePills` | wrap spacing 8, runSpacing 8 | Uses `InstaCarePillChip` | Uses `InstaCarePillChip` |
| `InstaCareRadioButtons` | outer padding `h2 v4`, outer circle `20x20`, inner dot `10x10`, border width 2 | Label text uses default `Text()` style (theme, not typography token) | Same as label |
| `InstaCareRatingScale` | icon button compact density; star icon size is framework default | N/A | N/A |
| `InstaCareMcqOptionSelector` | question gap 18, option radius 14, option padding `h14 v16`, option border 1.4, dot outer `18-22`, dot inner `7-9`, actions gap 16 | Question acts as label: `h3 w500` | Option text: `r w400`; button text inherited from `InstaCareButton` |
| `InstaCareMessageBox` | width full, padding 12, radius 10, icon size 18, title-body gap 2 | Title acts as label: `r w700` | Body: `r w400` |
| `InstaCareProgressBar` | bar minHeight 10, bar radius 999, label gap 8, footer gap 6 | Optional label: `r w600` | Footer text: `r w400` |
| `showInstaCareConfirmationDialog` | adaptive radius `8-14`, adaptive title `18-22`, body `14-16`, button height `46-56`, action gap 12 | Title: `h2` with `w700` | Body: `body w400`; button text: `h3 w600` |
| `InstaCareSnackbar` | top offset `statusBar + 16`, side margins 16, container padding 16, radius 12, icon 24, close icon 20 | Title: `r w700` | Message: `r w400` |
| `InstaCareBottomAppNavBar` | uses `BottomNavigationBar`, top border, optional shadow blur 10 | Item label (selected): `r w600` | Item label (unselected): `r w500` |
| `InstaCareTopHeaderTitle` | preferred height `kToolbarHeight` | AppBar title text uses default AppBar typography unless theme overrides | Same as label |
| `InstaCareHeading.topHeaderTitle` | N/A | `h2` with `w600` | Same as label |
| `InstaCareHeading.titleWithBackButton` | back icon size 28, icon-title gap 12 | Title: `h3` with `w600` | Same as label |
| `InstaCareHoursSummaryPill` | padding `h12 v8`, radius 999 | Label text: `r w600` | Same as label |
| `InstaCareAppointmentStatusPills` | wrap spacing 8, runSpacing 8 | Uses `InstaCareStatusBadge` label style | Uses `InstaCareStatusBadge` content style |
| `InstaCareVerticalStepper` | step circle `26-38`, step number size `12-16`, connector height 2, connector horizontal padding 6 | Step number is label-like: `sm` with override `w600` | Same as label |
| `InstaCareFileUploadTile` | full width, radius 12, padding 16, upload icon 28, title-subtitle gap 4 | Title: `r w700` | Subtitle: `r w400` |
| `InstaCareCarousel` | default height 
| Instacre
## Label vs No-Label Quick Rule
- **Label** in this document means explicit field labels or heading/title text.
- **No-label/content** means input value text, hint text, body text, helper text, option text, or message text.
- If a widget has no separate label API, `Label Font` is marked `N/A` or mapped to its primary text.
