import 'package:flutter/material.dart';
import '../widgets/emi_card_widget.dart';
import '../widgets/expanded_slider_card.dart';

// Optional: an enum to track our steps
enum ViewStep {
  slider,
  emi,
  account,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Which step are we on?
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

  // Define your EMI plans
  final List<Map<String, dynamic>> emiPlans = [
    {
      'amountPerMonth': "₹4,247 /mo",
      'duration': "for 12 months",
      'isRecommended': false,
    },
    {
      'amountPerMonth': "₹5,580 /mo",
      'duration': "for 9 months",
      'isRecommended': true,
    },
    {
      'amountPerMonth': "₹8,247 /mo",
      'duration': "for 6 months",
      'isRecommended': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for EMI
    _emiController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
      duration: const Duration(milliseconds: 300),
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

    // If starting with EMI or Account, animate those in
    if (_currentStep == ViewStep.emi) {
      _emiController.forward();
    } else if (_currentStep == ViewStep.account) {
      _accountController.forward();
    }
  }

  @override
  void dispose() {
    _emiController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  // Step 1: Collapse Slider & Show EMI
  void _goToEMIStep() {
    setState(() {
      _currentStep = ViewStep.emi;
      _emiController.forward();
    });
  }

  // Step 2: Collapse EMI & Show Account
  void _goToAccountStep() {
    setState(() {
      // Save the selected EMI data, if any
      if (selectedCardIndex != null) {
        selectedEmiText = emiPlans[selectedCardIndex!]['amountPerMonth'];
        selectedEmiDuration = emiPlans[selectedCardIndex!]['duration'];
      }
      _currentStep = ViewStep.account;
      _accountController.forward();
    });
  }

  // Re‐expand slider if it’s collapsed
  void _backToSlider() {
    setState(() {
      _currentStep = ViewStep.slider;
      _emiController.reset();
      _accountController.reset();
    });
  }

  // Re‐expand EMI if it is collapsed
  void _backToEMI() {
    setState(() {
      _currentStep = ViewStep.emi;
      _accountController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black26, // entire screen background
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              // Main scrolling content
              SingleChildScrollView(
                child: Column(
                  children: [
                    // 1) Slider portion or its collapsed row
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _buildSliderSection(),
                    ),
                    // 2) EMI portion or its collapsed row
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _buildEMIHeaderOrCollapsed(),
                    ),
                    // 3) Account portion (final step)
                    _buildAccountSelectionAnimated(),
                    // Add a little bottom padding so scrolling won't be obscured by the pinned CTA
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              // Pinned bottom CTA button (for all steps)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomCTA(),
              ),
            ],
          ),
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
        buttonText = "Proceed to EMI selection";
        onTap = _goToEMIStep;
        break;
      case ViewStep.emi:
        buttonText = "Select your bank account";
        onTap = _goToAccountStep;
        break;
      case ViewStep.account:
        buttonText = "Tap for 1-click KYC";
        onTap = () {
          // final step or next flow
        };
        break;
    }

// CTA container with a top rounded corner
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue, // Purple / Blue color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap, // Handle the tap
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.blue, // same color as container
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
    );
  }

  //-----------------------------------------------
  // BUILD SLIDER SECTION
  //-----------------------------------------------
  Widget _buildSliderSection() {
    if (_currentStep == ViewStep.slider) {
      // Show the expanded slider
      return Container(
        color: Colors.blueGrey.shade800, // Light dark-blue background
        child: _buildExpandedSlider(),
      );
    } else {
      // Show the collapsed slider row
      return _buildCollapsedSliderRow();
    }
  }

  Widget _buildExpandedSlider() {
    return ExpandedSliderCard(
      key: const ValueKey('expandedSlider'),
      initialAmount: selectedAmount,
      onAmountChanged: (val) {
        setState(() {
          selectedAmount = val;
        });
      },
    );
  }

  Widget _buildCollapsedSliderRow() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: _backToSlider, // Tapping re‐expands
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Credit amount: ₹${selectedAmount.round()}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------
  // BUILD EMI SECTION
  //-----------------------------------------------
  Widget _buildEMIHeaderOrCollapsed() {
    // If we are in slider step, EMI is hidden entirely
    if (_currentStep == ViewStep.slider) {
      return const SizedBox();
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // If we are in EMI step, show the expanded EMI selection
    if (_currentStep == ViewStep.emi) {
      return SlideTransition(
        position: _emiSlideAnimation,
        child: Container(
          height: screenHeight,
          color: Colors.blueGrey.shade800, // Light dark-blue background
          child: _buildEMIExpandedView(),
        ),
      );
    } else {
      // We must be in the “account” step => show EMI as collapsed row
      return _buildCollapsedEMIRow();
    }
  }

  Widget _buildEMIExpandedView() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.amber,
      ),
      key: const ValueKey('emiExpanded'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "How do you wish to repay?",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose one of our recommended plans or make your own",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // EMI Cards
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: emiPlans.length,
              itemBuilder: (context, index) {
                final plan = emiPlans[index];
                return EMICardWidget(
                  amountPerMonth: plan['amountPerMonth'],
                  duration: plan['duration'],
                  isRecommended: plan['isRecommended'],
                  isSelected: selectedCardIndex == index,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedCardIndex = index;
                      } else {
                        selectedCardIndex = null;
                      }
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Create Your Own Plan Button
          ElevatedButton(
            onPressed: () {
              // custom plan creation logic
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Create your own plan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Removed the big “Select your bank account” button here,
          // now handled by the pinned bottom CTA.
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCollapsedEMIRow() {
    // The EMI row shows “EMI: <selectedEmiText>” + “duration: <selectedEmiDuration>”
    // plus a down arrow to re‐expand. If none is selected, show placeholders.
    final emiText = selectedEmiText ?? "EMI";
    final emiDuration = selectedEmiDuration ?? "duration";

    return InkWell(
      onTap: _backToEMI,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            // EMI column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("EMI",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(emiText,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            // Duration column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("duration",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text(emiDuration,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
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
  Widget _buildAccountSelectionAnimated() {
    if (_currentStep != ViewStep.account) {
      return Container();
    }
    return SlideTransition(
      position: _accountSlideAnimation,
      child: Container(
        color: Colors.blueGrey.shade800, // Light dark-blue background
        child: _buildAccountSelectionView(),
      ),
    );
  }

  Widget _buildAccountSelectionView() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // Final expanded screen
    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.amber,
      ),
      key: const ValueKey('accountExpanded'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "where should we send the money?",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "amount will be credited to this bank account. EMI will also be debited from this bank account",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          // A placeholder list of bank accounts
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Bank logo
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/hdfc_icon.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                // Bank details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "HDFC Bank",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "50100117009192",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Check icon
                const Icon(Icons.check_circle, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // "Change account" button
          OutlinedButton(
            onPressed: () {
              // handle change
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text("Change account"),
          ),

          // Removed the big “Tap for 1-click KYC” button here,
          // now handled by the pinned bottom CTA.
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
