// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/circular_checkbox.dart';
import '../widgets/emi_card_widget.dart';
import '../widgets/expanded_amount_slider.dart';
import '../models/data_api_model.dart';

enum ViewStep {
  slider,
  loading, // New step for the loading transition
  emi,
  account,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Current step in the view
  ViewStep _currentStep = ViewStep.slider;

  // Track the amount from the slider
  double selectedAmount = 150000;

  // Track the index and data of the selected EMI
  int? selectedCardIndex;
  String? selectedEmiText;
  String? selectedEmiDuration;

  // Animation controller for EMI view
  late AnimationController _emiController;
  late Animation<Offset> _emiSlideAnimation;

  // Animation controller for Account view
  late AnimationController _accountController;
  late Animation<Offset> _accountSlideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController for EMI
    _emiController = AnimationController(
      duration: const Duration(
          milliseconds: 500), // Adjusted duration for smoother animation
      vsync: this,
    );
    // Initialize the EMI Slide Animation
    _emiSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts off-screen below
      end: Offset.zero, // Ends at its natural position
    ).animate(
      CurvedAnimation(
        parent: _emiController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize the AnimationController for Account
    _accountController = AnimationController(
      duration: const Duration(milliseconds: 500), // Adjusted duration
      vsync: this,
    );
    // Initialize the Account Slide Animation
    _accountSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts off-screen below
      end: Offset.zero, // Ends at its natural position
    ).animate(
      CurvedAnimation(
        parent: _accountController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _emiController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  // Step 1: Collapse Slider & Show Loading, then EMI
  void _goToEMIStep() async {
    setState(() {
      _currentStep = ViewStep.loading;
    });
    // Simulate a loading delay (e.g., 2 seconds)
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _currentStep = ViewStep.emi;
      _emiController.forward();
    });
  }

  // Step 2: Collapse EMI & Show Account
  void _goToAccountStep() async {
    setState(() {
      _currentStep = ViewStep.loading;
    });
    // Simulate a loading delay (e.g., 2 seconds)
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      // Save the selected EMI data, if any
      if (selectedCardIndex != null) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        final emiItem = dataProvider.data?.items?[1];
        if (emiItem != null) {
          selectedEmiText =
              emiItem.openState?.body!.items?[selectedCardIndex!]['emi'];
          selectedEmiDuration =
              emiItem.openState?.body!.items?[selectedCardIndex!]['duration'];
        }
      }
      _currentStep = ViewStep.account;
      _accountController.forward();
    });
  }

  // Re‐expand slider if it’s collapsed
  void _backToSlider() async {
    setState(() {
      _currentStep = ViewStep.loading;
    });
    // Simulate a loading delay (e.g., 2 seconds)
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _currentStep = ViewStep.slider;
      _emiController.reset();
      _accountController.reset();
    });
  }

  // Re‐expand EMI if it is collapsed
  void _backToEMI() async {
    setState(() {
      _currentStep = ViewStep.loading;
    });
    // Simulate a loading delay (e.g., 2 seconds)
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _currentStep = ViewStep.emi;
      _accountController.reset();
    });
  }

  // Loading screen with 3 animated dots
  Widget _buildLoadingScreen() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0),
          const SizedBox(width: 8),
          _buildDot(1),
          const SizedBox(width: 8),
          _buildDot(2),
        ],
      ),
    );
  }

  // Helper method to create individual dots with animation
  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        // Stagger the opacity for each dot
        double opacity = (value - index * 0.3).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    // Initiate data fetching if not already done
    if (_currentStep == ViewStep.slider &&
        dataProvider.data == null &&
        !dataProvider.isLoading &&
        dataProvider.error == null) {
      dataProvider.fetchData();
    }

    return Scaffold(
      backgroundColor: Color(0xFF11141a), // Entire screen background
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      /* Close logic */
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    onPressed: () {
                      /* Help logic */
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Main content
                  if (dataProvider.isLoading && _currentStep == ViewStep.slider)
                    const Center(child: CircularProgressIndicator())
                  else if (dataProvider.error != null)
                    Center(child: Text('Error: ${dataProvider.error}'))
                  else if (dataProvider.data != null)
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // 1) Slider portion or its collapsed row
                          AnimatedSize(
                            duration: const Duration(
                                milliseconds: 500), // Adjusted duration
                            curve: Curves.easeInOut,
                            child: _buildSliderSection(
                                dataProvider.data!.items![0]),
                          ),
                          // 2) EMI portion or its collapsed row
                          AnimatedSize(
                            duration: const Duration(
                                milliseconds: 500), // Adjusted duration
                            curve: Curves.easeInOut,
                            child: _buildEMIHeaderOrCollapsed(
                                dataProvider.data!.items![1]),
                          ),
                          // 3) Account portion (final step)
                          _buildAccountSelectionAnimated(
                              dataProvider.data!.items![2]),
                          // Add a little bottom padding so scrolling won't be obscured by the pinned CTA
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  // Pinned bottom CTA button (for all steps)
                  // Pinned top buttons (added here)

                  // Rest of the existing stack children
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildBottomCTA(),
                  ),
                  if (_currentStep == ViewStep.loading)
                    Container(
                      color: Colors.black54,
                      child: _buildLoadingScreen(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom CTA that changes text & onPressed based on the current step
  Widget _buildBottomCTA() {
    String buttonText;
    VoidCallback? onTap;

    switch (_currentStep) {
      case ViewStep.slider:
        // Get ctaText from sliderItem
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        final sliderItem = dataProvider.data?.items?[0];
        buttonText = sliderItem?.ctaText ?? "API NOT CALLED";
        onTap = _goToEMIStep;
        break;
      case ViewStep.loading:
        buttonText = "Loading...";
        onTap = null; // Disable the button
        break;
      case ViewStep.emi:
        // Get ctaText from emiItem
        final dataProviderEmi =
            Provider.of<DataProvider>(context, listen: false);
        final emiItem = dataProviderEmi.data?.items?[1];
        buttonText = emiItem?.ctaText ?? "Select your bank account";
        onTap = _goToAccountStep;
        break;
      case ViewStep.account:
        // Get ctaText from accountItem
        final dataProviderAccount =
            Provider.of<DataProvider>(context, listen: false);
        final accountItem = dataProviderAccount.data?.items?[2];
        buttonText = accountItem?.ctaText ?? "Tap for 1-click KYC";
        onTap = () {
          // Final step or next flow
          // TODO: Implement your KYC logic here
        };
        break;
    }

    // CTA container with a top rounded corner
    return Container(
      decoration: BoxDecoration(
        color: _currentStep == ViewStep.loading
            ? Colors.grey // Change color to indicate disabled state
            : const Color(0xFF33419F), // Purple / Blue color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap, // Handle the tap
        child: Opacity(
          opacity: onTap == null ? 0.6 : 1.0, // Reduce opacity if disabled
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------
  // BUILD SLIDER SECTION
  //-----------------------------------------------
  Widget _buildSliderSection(ItemData sliderItem) {
    // If not in slider step, show collapsed
    if (_currentStep != ViewStep.slider) {
      return _buildCollapsedSliderRow(sliderItem);
    }

    // Extract openState data
    final body = sliderItem.openState?.body;
    final title = body?.title ?? "No Title";
    final subtitle = body?.subtitle ?? "No Subtitle";
    final footer = body?.footer ?? "No Footer";

    final card = body?.card;
    final minRange = card?.minRange?.toDouble() ?? 0.0;
    final maxRange = card?.maxRange?.toDouble() ?? 1000000.0;

    return Container(
      color: Color(0xFF161921), // Dark color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider widget
            ExpandedAmountSlider(
              initialAmount: selectedAmount,
              min: minRange,
              max: maxRange,
              title: title,
              subtitle: subtitle,
              footer: footer,
              onAmountChanged: (val) {
                setState(() {
                  selectedAmount = val;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Collapsed row for sliderWidget
  Widget _buildCollapsedSliderRow(ItemData sliderItem) {
    final closedBody = sliderItem.closedState?.body;
    // e.g., key1 might be "credit amount"
    final collapsedText = closedBody?.key1 ?? "Credit amount";
    return InkWell(
      onTap: _backToSlider, // Tapping re‐expands
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 90,
        decoration: BoxDecoration(
          color: Color(0xFF161921),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "$collapsedText:",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    "₹${selectedAmount.round()}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------
  // BUILD EMI SECTION
  //-----------------------------------------------
  Widget _buildEMIHeaderOrCollapsed(ItemData emiItem) {
    // If we are in slider or loading step, EMI is hidden entirely
    if (_currentStep == ViewStep.slider || _currentStep == ViewStep.loading) {
      return const SizedBox();
    }

    // If we are in EMI step, show the expanded EMI selection
    if (_currentStep == ViewStep.emi) {
      return SlideTransition(
        position: _emiSlideAnimation,
        child: _buildEMIExpandedView(emiItem),
      );
    } else {
      // We must be in the “account” step => show EMI as collapsed row
      return _buildCollapsedEMIRow(emiItem);
    }
  }

  Widget _buildEMIExpandedView(ItemData emiItem) {
    final body = emiItem.openState?.body;

    final title = body?.title ?? "How do you wish to repay?";
    final subtitle = body?.subtitle ?? "API NOT CALLED ";
    final footer = body?.footer ??
        "stash is instant. money will be credited within seconds.";

    // Assuming body?.items has EMI plan items
    final emiPlans = body?.items ?? [];
    final List<Color> emiCardColors = [
      Color(0xFF43343E),
      Color(0xFF7C7391),
      Color(0xFF58698c),
    ];

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1a1c29), // Dark color
      ),
      key: const ValueKey('emiExpanded'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 6),
          // Subtitle
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 24),
          // EMI Cards
// EMI Cards
          SizedBox(
            height: 200, // Increased from 180 to 200
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: emiPlans.length,
              itemBuilder: (context, index) {
                final planItem = emiPlans[index];
                final amountPerMonth = planItem['title'] ?? "₹0/mo";
                final duration = planItem['subtitle'] ?? "for 0 months";
                final isRecommended = (planItem['tag'] == "recommended");
                final bgColor =
                    emiCardColors[index % emiCardColors.length]; // Assign color

                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: EMICardWidget(
                    amountPerMonth: amountPerMonth,
                    duration: duration,
                    isRecommended: isRecommended,
                    isSelected: selectedCardIndex == index,
                    bgColor: bgColor,
                    // Pass color here
                    onSelected: (isSelected) {
                      setState(() {
                        selectedCardIndex = isSelected ? index : null;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // Create Your Own Plan Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Custom plan creation logic
                // TODO: Implement your custom plan logic here
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                footer,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCollapsedEMIRow(ItemData emiItem) {
    final closedBody = emiItem.closedState?.body;
    final rowTitle = closedBody?.key1 ?? "EMI";
    final rowDuration = closedBody?.key2 ?? "duration";

    return InkWell(
      onTap: _backToEMI,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1a1c29),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Ensure the Row takes maximum width
          children: [
            // EMI column
            Expanded(
              flex: 2, // Adjust flex as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rowTitle,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedEmiText ?? "Not Selected",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Add spacing between columns
            // Duration column
            Expanded(
              flex: 1, // Adjust flex as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rowDuration,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedEmiDuration ?? "Not selected",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------
  // BUILD FINAL ACCOUNT SELECTION
  //-----------------------------------------------
  Widget _buildAccountSelectionAnimated(ItemData accountItem) {
    if (_currentStep != ViewStep.account) {
      return Container();
    }
    return SlideTransition(
      position: _accountSlideAnimation,
      child: Container(
        color: Colors.blueGrey.shade800, // Light dark-blue background
        child: _buildAccountSelectionView(accountItem),
      ),
    );
  }

// Add this at the top of your file
  int? selectedBankIndex;

// Modified _buildAccountSelectionView
  Widget _buildAccountSelectionView(ItemData accountItem) {
    final body = accountItem.openState?.body;
    final title = body?.title ?? "Where should we send the money?";
    final subtitle = body?.subtitle ??
        "Amount will be credited to this bank account. EMI will also be debited from this bank account.";

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: const Color(0xFF262A3D),
      ),
      key: const ValueKey('accountExpanded'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: body?.items?.length ?? 0,
              itemBuilder: (context, index) {
                final bankItem = body!.items![index];
                final bankTitle = bankItem['title'] ?? "Bank Name";
                final bankSubtitle = "${bankItem['subtitle'] ?? ''}";
                final String bankIcon =
                    (bankItem['title'] ?? "").split(" ").first.toLowerCase();

                final isSelected = selectedBankIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBankIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(
                      //   color: isSelected ? Colors.blue : Colors.transparent,
                      //   width: 2,
                      // ),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: bankIcon.isNotEmpty
                                ? Image.asset("assets/images/$bankIcon.png")
                                : Image.network(bankIcon, fit: BoxFit.contain)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bankSubtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircularCheckbox(
                          isChecked: isSelected,
                          onChanged: (value) {
                            setState(() {
                              selectedBankIndex = value ? index : null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              /* Handle change account */
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text("Change account"),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
