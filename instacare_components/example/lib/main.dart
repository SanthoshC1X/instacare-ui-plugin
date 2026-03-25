import 'package:flutter/material.dart';
import 'package:instacare_components/instacare_components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'themes/partner_theme.dart';
import 'themes/user_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPartner = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isPartner ? PartnerTheme.theme : UserTheme.theme,
      home: Gallery(
        isPartner: isPartner,
        onRoleChanged: (value) => setState(() => isPartner = value),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section entry — lightweight metadata; widget is only built when visible
// ---------------------------------------------------------------------------
class _SectionEntry {
  final String? heading;
  final String? title;
  final String? fileName;
  final WidgetBuilder? builder;

  const _SectionEntry.heading(this.heading)
      : title = null,
        fileName = null,
        builder = null;

  const _SectionEntry.component({
    required this.title,
    required this.fileName,
    required this.builder,
  }) : heading = null;

  /// Extra widget (like booking state control) that is not wrapped in a block.
  const _SectionEntry.raw(this.builder)
      : heading = null,
        title = null,
        fileName = null;
}

// ---------------------------------------------------------------------------
// Booking card demo state
// ---------------------------------------------------------------------------
class _BookingCardDemoState {
  final String patientName;
  final String? patientGender;
  final int? patientAge;
  final String? partnerName;
  final String bookingId;
  final String serviceName;
  final String dateTime;
  final int? daysUntil;

  const _BookingCardDemoState({
    required this.patientName,
    this.patientGender,
    this.patientAge,
    this.partnerName,
    required this.bookingId,
    required this.serviceName,
    required this.dateTime,
    this.daysUntil,
  });
}

// ---------------------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------------------
class Gallery extends StatefulWidget {
  final bool isPartner;
  final ValueChanged<bool> onRoleChanged;

  const Gallery({
    super.key,
    required this.isPartner,
    required this.onRoleChanged,
  });

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late int _selectedRoleIndex;
  late final PageController _pageController;

  bool loading = false;
  String? selectedGender;
  String? selectedService;
  String? selectedMcq = 'Option 1';
  String otp = '';
  int rating = 3;
  int currentStepperStep = 0;
  int currentNavIndex = 0;
  int bookingCardStateIndex = 0;
  DateTime? selectedDate;
  bool checkOne = false;
  bool checkboxCard1 = false;
  bool checkboxCard2 = true;
  bool consentChecked = false;
  String selectedRadio = 'Yes';
  final Set<String> selectedFilters = <String>{'Wound Dressing'};
  Set<String> selectedMultiDropdown = <String>{'check box 2'};
  bool showRenderedMarkdown = false;
  static const String _markdownSample = '''
# H1 – Design Fundamentals

## H2 – Visual Thinking

### H3 – Layout & Structure

#### H4 – Consistency

##### H5 – Details

###### H6 – Precision

---

<p style="color:#16A34A">Green paragraph: Good design balances <b>form</b> and <i>function</i> while staying simple.</p>

---

## Text Styling

- **Bold text**
- *Italic text*
- ***Bold and Italic***
- Simple text
- ~~Strikethrough~~
- Inline code: `padding: 16px`

---

## Lists

### Unordered List
- Balance
- Contrast
- Alignment

### Ordered List
1. Research
2. Design
3. Build

---

## Table (4 × 4)

| Item | Purpose | Tool | Output |
|------|---------|------|--------|
| Color | Branding | Figma | UI |
| Font | Readability | CSS | Text |
| Grid | Layout | Flexbox | Structure |
| Icon | Meaning | SVG | Visual |

---

## Blockquote

> Good design is obvious.
> Great design is transparent.

---

## Code Block

```css
.button {
  padding: 16px;
  border-radius: 8px;
}
''';
  final List<_BookingCardDemoState> _bookingCardStates =
      const <_BookingCardDemoState>[
    _BookingCardDemoState(
      patientName: 'Anjana',
      patientGender: 'F',
      patientAge: 34,
      partnerName: 'Rithika',
      bookingId: '786452',
      serviceName: 'Blood Sugar Monitoring',
      dateTime: 'February 14, 2026 | 6:30 p.m.',
    ),
    _BookingCardDemoState(
      patientName: 'Anjana',
      patientGender: 'F',
      patientAge: 34,
      partnerName: 'Rithika',
      bookingId: '786452',
      serviceName: 'Nebulization',
      dateTime: 'February 16, 2026 | 7:30 p.m.',
      daysUntil: 2,
    ),
    _BookingCardDemoState(
      patientName: 'John Durai',
      patientGender: 'M',
      patientAge: 45,
      partnerName: 'Priya',
      bookingId: '786500',
      serviceName: 'Postnatal Physiotherapy',
      dateTime: 'February 17, 2026 | 5:00 p.m.',
      daysUntil: 3,
    ),
    _BookingCardDemoState(
      patientName: 'Jimmy',
      patientGender: 'M',
      patientAge: 28,
      bookingId: '786321',
      serviceName: 'Vitals Monitoring',
      dateTime: 'February 10, 2026 | 10:30 a.m.',
    ),
    _BookingCardDemoState(
      patientName: 'Meera',
      patientGender: 'F',
      patientAge: 60,
      partnerName: 'Kavitha',
      bookingId: '786100',
      serviceName: 'Wound Dressing',
      dateTime: 'February 8, 2026 | 9:00 a.m.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedRoleIndex = widget.isPartner ? 0 : 1;
    _pageController = PageController(initialPage: _selectedRoleIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Role slider
  // -------------------------------------------------------------------------
  void _selectRole(int index) {
    if (_selectedRoleIndex == index) return;

    setState(() => _selectedRoleIndex = index);
    widget.onRoleChanged(index == 0);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Widget _roleSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / 2;
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: _selectedRoleIndex * segmentWidth,
                top: 4,
                bottom: 4,
                width: segmentWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                children: [
                  _roleItem('Partner', 0),
                  _roleItem('Common', 1),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roleItem(String label, int index) {
    final active = _selectedRoleIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _selectRole(index),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? AppColors.baseWhite : AppColors.gray700,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Shared helpers
  // -------------------------------------------------------------------------
  Widget _sectionHeading(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.gray800,
        ),
      ),
    );
  }

  Widget _componentBlock({
    required String title,
    required String fileName,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.ivory50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary100, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fileName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Reusable sub-widgets (kept as methods, called lazily by builders)
  // -------------------------------------------------------------------------
  Widget _bookingStateControl() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_bookingCardStates.length, (index) {
          final isSelected = bookingCardStateIndex == index;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => bookingCardStateIndex = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                '${index + 1}',
                style: InstaCareTypography.m.copyWith(
                  color: isSelected ? AppColors.primary800 : AppColors.gray600,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _skeletonPagePreview() {
    return const Column(
      children: [
        InstaCareSkeletonLoading(
          width: double.infinity,
          height: 18,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        SizedBox(height: 10),
        InstaCareSkeletonLoading(
          width: double.infinity,
          height: 12,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        SizedBox(height: 8),
        InstaCareSkeletonLoading(
          width: double.infinity,
          height: 12,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            InstaCareSkeletonLoading(
              width: 56,
              height: 56,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  InstaCareSkeletonLoading(
                    width: double.infinity,
                    height: 12,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  SizedBox(height: 8),
                  InstaCareSkeletonLoading(
                    width: double.infinity,
                    height: 12,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        InstaCareSkeletonLoading(
          width: double.infinity,
          height: 48,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ],
    );
  }

  Widget _bottomNavDemo() {
    return _componentBlock(
      title: 'Bottom App Nav Bar (Reference)',
      fileName: 'bottom_app_nav_bar.dart',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InstaCareBottomAppNavBar(
          currentIndex: currentNavIndex,
          onTap: (index) => setState(() => currentNavIndex = index),
          backgroundColor: AppColors.ivory300,
          selectedItemColor: AppColors.primary800,
          unselectedItemColor: AppColors.primary400,
          topBorderColor: AppColors.primary800,
          showShadow: true,
          items: const [
            InstaCareBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
            InstaCareBottomNavItem(
              icon: Icons.list_alt,
              label: 'Bookings',
            ),
            InstaCareBottomNavItem(
              icon: Icons.medical_services_outlined,
              label: 'Services',
            ),
            InstaCareBottomNavItem(
                icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _markdownTogglePreview() {
    final toggleText =
        showRenderedMarkdown ? 'Show Raw Markdown' : 'Show Rendered Markdown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstaCareButton.secondary(
          text: toggleText,
          onPressed: () => setState(
            () => showRenderedMarkdown = !showRenderedMarkdown,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 340),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final tween = Tween<Offset>(
              begin: const Offset(0.22, 0),
              end: Offset.zero,
            );
            return ClipRect(
              child: SlideTransition(
                position: tween.animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
            );
          },
          child: showRenderedMarkdown
              ? Container(
                  key: const ValueKey<String>('rendered'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.baseWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: const InstaCareMarkdown(data: _markdownSample),
                )
              : Container(
                  key: const ValueKey<String>('raw'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.baseWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      _markdownSample,
                      style: InstaCareTypography.s.copyWith(
                        color: AppColors.gray800,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Section registries — lightweight lists; builders fire only when visible
  // -------------------------------------------------------------------------
  List<_SectionEntry> get _partnerSections {
    final bookingState = _bookingCardStates[
        bookingCardStateIndex.clamp(0, _bookingCardStates.length - 1)];

    return [
      const _SectionEntry.heading('Partner Components'),
      const _SectionEntry.heading('Feedback'),
      _SectionEntry.component(
        title: 'Message Box',
        fileName: 'message_box.dart',
        builder: (_) => const Column(
          children: [
            InstaCareMessageBox(
                type: InstaCareMessageType.info,
                title: 'Info message box',
                body: 'Body text goes here'),
            SizedBox(height: 8),
            InstaCareMessageBox(
                type: InstaCareMessageType.error,
                title: 'Error message box',
                body: 'Body text goes here'),
            SizedBox(height: 8),
            InstaCareMessageBox(
                type: InstaCareMessageType.pending,
                title: 'Pending message box',
                body: 'Body text goes here'),
            SizedBox(height: 8),
            InstaCareMessageBox(
                type: InstaCareMessageType.success,
                title: 'Success message box',
                body: 'Body text goes here'),
          ],
        ),
      ),
      _SectionEntry.component(
        title: 'Progress Bar',
        fileName: 'progress_bar.dart',
        builder: (_) =>
            const InstaCareProgressBar(value: 0.65, label: 'Progress bar'),
      ),
      const _SectionEntry.heading('Cards'),
      _SectionEntry.component(
        title: 'Booking Card',
        fileName: 'booking_card.dart',
        builder: (_) => InstaCareBookingCard(
          patientName: bookingState.patientName,
          patientGender: bookingState.patientGender,
          patientAge: bookingState.patientAge,
          partnerName: bookingState.partnerName,
          bookingId: bookingState.bookingId,
          serviceName: bookingState.serviceName,
          dateTime: bookingState.dateTime,
          daysUntil: bookingState.daysUntil,
        ),
      ),
      _SectionEntry.raw((_) => _bookingStateControl()),
      _SectionEntry.component(
        title: 'Income Tile',
        fileName: 'income_tile.dart',
        builder: (_) => InstaCareIncomeTile(
          title: "This month's earnings",
          amount: 'Rs 0',
          redeemButtonText: 'Redeem',
          onRedeem: () {},
          backgroundColor: AppColors.ivory300,
        ),
      ),
      _SectionEntry.component(
        title: 'Card List View',
        fileName: 'card_list_view.dart',
        builder: (_) => const InstaCareCardListView(
          items: [
            InstaCareCardListItem(
              card: InstaCareCard(
                backgroundColor: AppColors.ivory300,
                child: Center(child: Text('Card')),
              ),
              title: 'Wound Dressing',
              body: 'Daily care service with dressing change.',
            ),
            InstaCareCardListItem(
              card: InstaCareCard(
                backgroundColor: AppColors.ivory300,
                child: Center(child: Text('Card')),
              ),
              title: 'Nursing Visit',
              body: 'Vitals check and medication support.',
            ),
          ],
        ),
      ),
      _SectionEntry.component(
        title: 'Checkbox Card',
        fileName: 'checkbox_card.dart',
        builder: (_) => Column(
          children: [
            InstaCareCheckboxCard(
              title: 'Card Title 1',
              message:
                  'This is a small message text that describes the card content.',
              isSelected: checkboxCard1,
              onChanged: (value) => setState(() => checkboxCard1 = value),
            ),
            const SizedBox(height: 12),
            InstaCareCheckboxCard(
              title: 'Card Title 2',
              message:
                  'Another card with a different message for demonstration.',
              isSelected: checkboxCard2,
              onChanged: (value) => setState(() => checkboxCard2 = value),
            ),
          ],
        ),
      ),
      _SectionEntry.component(
        title: 'Attempts Card',
        fileName: 'attempts_card.dart',
        builder: (_) => const Column(
          children: [
            InstaCareAttemptsCard(
              totalAttempts: 3,
              usedAttempts: 1,
              hasPassed: false,
            ),
            SizedBox(height: 12),
            InstaCareAttemptsCard(
              totalAttempts: 3,
              usedAttempts: 3,
              hasPassed: false,
            ),
            SizedBox(height: 12),
            InstaCareAttemptsCard(
              totalAttempts: 3,
              usedAttempts: 2,
              hasPassed: true,
            ),
          ],
        ),
      ),
      const _SectionEntry.heading('Badges'),
      _SectionEntry.component(
        title: 'Appointment Status Pills',
        fileName: 'appointment_status_pills.dart',
        builder: (_) => const InstaCareAppointmentStatusPills(),
      ),
      const _SectionEntry.heading('Pills'),
      _SectionEntry.component(
        title: 'Hours Summary Pill',
        fileName: 'hours_summary_pill.dart',
        builder: (_) =>
            const InstaCareHoursSummaryPill(text: 'Selected hours: 04h 30m'),
      ),
      const _SectionEntry.heading('Steps'),
      _SectionEntry.component(
        title: 'MCQ Option Selector',
        fileName: 'mcq_option_selector.dart',
        builder: (_) => InstaCareMcqOptionSelector(
          question: 'Question',
          options: const ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
          selected: selectedMcq,
          onSelected: (value) => setState(() => selectedMcq = value),
          previousLabel: 'Previous Question',
          nextLabel: 'Next Question',
          onPrevious: () {},
          onNext: () {},
        ),
      ),
      _SectionEntry.component(
        title: 'Horizontal Stepper',
        fileName: 'stepper.dart',
        builder: (_) => InstaCareVerticalStepper(
          currentStep: currentStepperStep,
          onStepChanged: (step) => setState(() => currentStepperStep = step),
          items: const [
            InstaCareStepperItem(title: 'Step 1'),
            InstaCareStepperItem(title: 'Step 2'),
            InstaCareStepperItem(title: 'Step 3'),
          ],
        ),
      ),
      const _SectionEntry.heading('Upload'),
      _SectionEntry.component(
        title: 'File Upload Tile',
        fileName: 'file_upload_tile.dart',
        builder: (_) => InstaCareFileUploadTile(onTap: () {}),
      ),
      const _SectionEntry.heading('Navigation'),
      _SectionEntry.raw((_) => _bottomNavDemo()),
    ];
  }

  Widget _buildFontWeightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFontWeightsGrid(GoogleFonts.crimsonPro, 'Crimson Pro (Headings)'),
        const SizedBox(height: 32),
        const Divider(height: 1, color: AppColors.ivory300),
        const SizedBox(height: 32),
        _buildFontWeightsGrid(GoogleFonts.figtree, 'Figtree (Body)'),
      ],
    );
  }


  List<_SectionEntry> get _commonSections {
    return [
      const _SectionEntry.heading('Common Components'),
      const _SectionEntry.heading('Badges & Status'),
      _SectionEntry.component(
        title: 'Status Badge',
        fileName: 'status_badge.dart',
        builder: (_) => const InstaCareStatusBadge(
          label: 'Status',
          type: InstaCareStatusBadgeType.custom,
        ),
      ),
      _SectionEntry.component(
        title: 'OTP Input',
        fileName: 'otp_input.dart',
        builder: (_) => InstaCareOtpInput(
          length: 4,
          onChanged: (value) {},
          onCompleted: (value) {},
        ),
      ),
      const _SectionEntry.heading('Logo'),
      _SectionEntry.component(
        title: 'Instacare Logo',
        fileName: 'common/logo.dart',
        builder: (_) => const Column(
          children: [InstaCareLogo(), SizedBox(height: 20)],
        ),
      ),
      _SectionEntry.component(
        title: 'LogoIcon',
        fileName: 'common/logo.dart',
        builder: (_) => const InstaCareLogoIcon(size: 32, color: AppColors.primary300),
      ),
      _SectionEntry.component(
        title: 'LogoText',
        fileName: 'common/logo.dart',
        builder: (_) => const InstaCareLogoText(fontSize: 24, color: AppColors.primary300),
      ),
      const _SectionEntry.heading('Typography'),
      _SectionEntry.component(
        title: 'Font Weights',
        fileName: 'google_fonts',
        builder: (_) => _buildFontWeightsSection(),
      ),
      _SectionEntry.component(
        title: 'Text Styles',
        fileName: 'typography.dart',
        builder: (_) => _buildTextStylesSection(),
      ),
      const _SectionEntry.heading('Headings'),
      _SectionEntry.component(
        title: 'Top Header Title',
        fileName: 'theme/heading.dart',
        builder: (_) => InstaCareHeading.topHeaderTitle('Top Header Title'),
      ),
      _SectionEntry.component(
        title: 'Title with Back Button',
        fileName: 'theme/heading.dart',
        builder: (_) => InstaCareHeading.titleWithBackButton(text: 'Title', onBackPressed: () {}),
      ),
      const _SectionEntry.heading('Animation'),
      _SectionEntry.component(
        title: 'Skeleton Loading',
        fileName: 'animation/skeleton_loading.dart',
        builder: (_) => _skeletonPagePreview(),
      ),
      _SectionEntry.component(
        title: 'Carousel',
        fileName: 'animation/carousel.dart',
        builder: (_) => InstaCareCarousel(
          height: 160,
          items: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.ivory300),
                boxShadow: [BoxShadow(color: AppColors.gray600.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Center(child: Text('Card 1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.gray200))),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.ivory700,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.ivory300),
                boxShadow: [BoxShadow(color: AppColors.gray600.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Center(child: Text('Card 2', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.gray200))),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.ivory300),
                boxShadow: [BoxShadow(color: AppColors.gray600.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Center(child: Text('Card 3', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.gray200))),
            ),
          ],
        ),
      ),
      _SectionEntry.component(
        title: 'Markdown Render Widget',
        fileName: 'common/markdown.dart',
        builder: (_) => _markdownTogglePreview(),
      ),
      const _SectionEntry.heading('Buttons'),
      _SectionEntry.component(
        title: 'Button States',
        fileName: 'button.dart',
        builder: (_) => Column(
          children: [
            InstaCareButton(text: 'Primary Button', fullWidth: true, onPressed: () {}),
            const SizedBox(height: 10),
            InstaCareButton.secondary(text: 'Secondary Button', fullWidth: true, onPressed: () {}),
            const SizedBox(height: 10),
            InstaCareButton(
              text: loading ? 'Loading...' : 'Load Data',
              isLoading: loading,
              fullWidth: true,
              onPressed: () {
                setState(() => loading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) setState(() => loading = false);
                });
              },
            ),
            const SizedBox(height: 10),
            const InstaCareButton(text: 'Disabled', fullWidth: true, isDisabled: true, onPressed: null),
          ],
        ),
      ),
      const _SectionEntry.heading('Inputs'),
      _SectionEntry.component(
        title: 'Text Inputs',
        fileName: 'text_field.dart',
        builder: (_) => const Column(
          children: [
            InstaCareTextField(label: 'Text Input', hint: 'placeholder', fillColor: AppColors.ivory700, borderColor: AppColors.primary300, focusedBorderColor: AppColors.primary200, hintColor: AppColors.gray600),
            SizedBox(height: 12),
            InstaCareTextField(label: 'Email', hint: 'Enter your email', prefixIcon: Icons.email_outlined),
          ],
        ),
      ),
      _SectionEntry.component(
        title: 'Phone Input',
        fileName: 'phone_input.dart',
        builder: (_) => const InstaCarePhoneInput(label: 'Mobile Number With Region Selector', hint: '87921 34521'),
      ),
      _SectionEntry.component(
        title: 'Dropdown',
        fileName: 'dropdown.dart',
        builder: (_) => InstaCareDropdown<String>(
          label: 'Gender',
          hint: 'Select gender',
          value: selectedGender,
          items: const ['Male', 'Female', 'Other'],
          onChanged: (value) => setState(() => selectedGender = value),
        ),
      ),
      _SectionEntry.component(
        title: 'Dropdown With Checkbox',
        fileName: 'dropdown_with_checkbox.dart',
        builder: (_) => InstaCareDropdownWithCheckbox<String>(
          label: 'Drop Down With Check Box',
          hint: 'Select options',
          items: const ['check box 1', 'check box 2', 'check box 3'],
          selectedItems: selectedMultiDropdown,
          onChanged: (next) => setState(() => selectedMultiDropdown = next),
        ),
      ),
      _SectionEntry.component(
        title: 'Date Picker',
        fileName: 'date_picker_field.dart',
        builder: (_) => InstaCareDatePickerField(
          label: 'Date Picker',
          value: selectedDate,
          onChanged: (next) => setState(() => selectedDate = next),
        ),
      ),
      _SectionEntry.component(
        title: 'Search Bar',
        fileName: 'search_bar.dart',
        builder: (_) => const InstaCareSearchBar(hint: 'Search services'),
      ),
      _SectionEntry.component(
        title: 'Checkbox',
        fileName: 'checkbox_field.dart',
        builder: (_) => InstaCareCheckboxField(
          value: checkOne,
          onChanged: (checked) => setState(() => checkOne = checked ?? false),
          label: 'Checkbox 1',
        ),
      ),
      _SectionEntry.component(
        title: 'OTP Input',
        fileName: 'otp_input.dart',
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InstaCareOtpInput(
              length: 6,
              onChanged: (value) => setState(() => otp = value),
              onCompleted: (value) => setState(() => otp = value),
            ),
            if (otp.isNotEmpty) ...[const SizedBox(height: 8), Text('Entered OTP: $otp')],
          ],
        ),
      ),
      const _SectionEntry.heading('Selection'),
      _SectionEntry.component(
        title: 'Radio Buttons',
        fileName: 'radio_buttons.dart',
        builder: (_) => InstaCareRadioButtons<String>(
          groupValue: selectedRadio,
          options: const [InstaCareRadioOption(value: 'Yes', label: 'Yes'), InstaCareRadioOption(value: 'No', label: 'No')],
          onChanged: (value) => setState(() => selectedRadio = value ?? 'Yes'),
          direction: Axis.horizontal,
        ),
      ),
      _SectionEntry.component(
        title: 'Service Pills',
        fileName: 'service_pills.dart',
        builder: (_) => InstaCareServicePills(
          services: const ['Minor', 'Major', 'Nursing'],
          selected: selectedService,
          onSelected: (value) => setState(() => selectedService = value),
        ),
      ),
      _SectionEntry.component(
        title: 'Filter Pills',
        fileName: 'filter_pills.dart',
        builder: (_) => InstaCareFilterPills(
          items: const ['Wound Dressing', 'Injection', 'Vitals'],
          selected: selectedFilters,
          onToggle: (item) {
            setState(() {
              selectedFilters.contains(item) ? selectedFilters.remove(item) : selectedFilters.add(item);
            });
          },
        ),
      ),
      _SectionEntry.component(
        title: 'Rating Scale',
        fileName: 'rating_scale.dart',
        builder: (_) => InstaCareRatingScale(
          currentRating: rating,
          onRatingChanged: (value) => setState(() => rating = value),
        ),
      ),
      const _SectionEntry.heading('Dialogs'),
      _SectionEntry.component(
        title: 'Confirmation Dialog',
        fileName: 'confirmation_dialog.dart',
        builder: (ctx) => InstaCareButton.secondary(
          text: 'Pop confirmation',
          onPressed: () async {
            final confirmed = await showInstaCareConfirmationDialog(context: ctx, title: 'Confirmation', body: 'Do you want to continue?');
            if (!mounted) return;
            if (confirmed) ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Confirmed')));
          },
        ),
      ),
      const _SectionEntry.heading('Navigation'),
      _SectionEntry.component(
        title: 'Bottom Nav Bar (Patient)',
        fileName: 'bottom_app_nav_bar.dart',
        builder: (_) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InstaCareBottomAppNavBar(
            currentIndex: currentNavIndex,
            onTap: (index) => setState(() => currentNavIndex = index),
            backgroundColor: AppColors.primary100,
            selectedItemColor: AppColors.primary800,
            unselectedItemColor: AppColors.primary400,
            topBorderColor: AppColors.primary800,
            showShadow: true,
            items: const [
              InstaCareBottomNavItem(
                  icon: Icons.home_outlined, label: 'Home'),
              InstaCareBottomNavItem(
                  icon: Icons.grid_view_outlined, label: 'Services'),
              InstaCareBottomNavItem(
                  icon: Icons.headset_mic_outlined, label: 'Support'),
              InstaCareBottomNavItem(
                  icon: Icons.person_outline, label: 'Profile'),
            ],
          ),
        ),
      ),
      _SectionEntry.component(
        title: 'Snackbar',
        fileName: 'snackbar.dart',
        builder: (ctx) => Column(
          children: [
            InstaCareButton(text: 'Show Success Snackbar', fullWidth: true, onPressed: () { InstaCareSnackbar.show(context: ctx, type: InstaCareSnackbarType.success, title: 'Success', message: 'Your action was completed successfully!'); }),
            const SizedBox(height: 10),
            InstaCareButton(text: 'Show Error Snackbar', fullWidth: true, onPressed: () { InstaCareSnackbar.show(context: ctx, type: InstaCareSnackbarType.error, title: 'Error', message: 'Something went wrong. Please try again.'); }),
            const SizedBox(height: 10),
            InstaCareButton(text: 'Show Info Snackbar', fullWidth: true, onPressed: () { InstaCareSnackbar.show(context: ctx, type: InstaCareSnackbarType.info, title: 'Information', message: 'Here is some useful information for you.'); }),
            const SizedBox(height: 10),
            InstaCareButton(text: 'Show Pending Snackbar', fullWidth: true, onPressed: () { InstaCareSnackbar.show(context: ctx, type: InstaCareSnackbarType.pending, title: 'Pending', message: 'Your request is being processed.'); }),
          ],
        ),
      ),
    ];
  }

  Widget _buildFontWeightsGrid(
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    }) fontStyle,
    String name,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...[100, 200, 300, 400, 500, 600, 700, 800, 900].map((w) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    'w$w',
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.gray900),
                  ),
                ),
                Expanded(
                  child: Text(
                    'The quick brown fox jumps over the lazy dog',
                    style: fontStyle(
                      fontWeight: FontWeight.values[w ~/ 100 - 1],
                      fontSize: 16,
                    ).copyWith(color: AppColors.gray800),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTextStylesSection() {
    final styles = [
      ('h1', InstaCareTypography.h1, '24/Auto'),
      ('h2', InstaCareTypography.h2, '20/Auto'),
      ('h3', InstaCareTypography.h3, '18/Auto'),
      ('h4', InstaCareTypography.h4, '14/Auto'),
      ('p', InstaCareTypography.p, '14/Auto'),
      ('r', InstaCareTypography.r, '14/Auto'),
      ('m', InstaCareTypography.m, '14/Auto'),
      ('s', InstaCareTypography.s, '12/Auto'),
      ('sm', InstaCareTypography.sm, '12/Auto'),
      ('xs', InstaCareTypography.xs, '10/Auto'),
    ];

    return Column(
      children: styles.map((styleInfo) {
        final (label, style, detail) = styleInfo;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ag',
                  style: style.copyWith(color: AppColors.gray900, height: 1),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.gray900,
                ),
              ),
              Text(
                ' \u00B7 ',
                style: TextStyle(color: AppColors.gray500.withValues(alpha: 0.5)),
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -------------------------------------------------------------------------
  // Lazy page builder — shared by all 3 tabs
  // -------------------------------------------------------------------------
  Widget _buildLazyPage(List<_SectionEntry> sections) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final entry = sections[index];

        // Heading row
        if (entry.heading != null) {
          return _sectionHeading(entry.heading!);
        }

        // Raw widget (no component block wrapper)
        if (entry.title == null && entry.builder != null) {
          return entry.builder!(context);
        }

        // Component block (lazy — only built when scrolled into view)
        return _componentBlock(
          title: entry.title!,
          fileName: entry.fileName!,
          child: entry.builder!(context),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instacare Components'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.ivory300,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: _roleSlider(),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    if (_selectedRoleIndex != index) {
                      setState(() => _selectedRoleIndex = index);
                      widget.onRoleChanged(index == 0);
                    }
                  },
                  children: [
                    _buildLazyPage(_partnerSections),
                    _buildLazyPage(_commonSections),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
