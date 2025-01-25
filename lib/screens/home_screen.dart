import 'package:flutter/material.dart';
import '../widgets/emi_card_widget.dart';
import '../widgets/expanded_slider_card.dart';
import '../widgets/collapsed_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = true;
  double selectedAmount = 150000; // The amount from the slider

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the slide animation for the EMI selection view
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start just below the visible area
      end: Offset.zero, // End at its natural position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // If initially not expanded, ensure the EMI view is visible
    if (!isExpanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Toggle between expanded and collapsed states
  void _toggleView() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Entire screen background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AnimatedSize for smooth height transitions
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded ? _buildExpandedView() : _buildCollapsedRow(),
              ),
              // SlideTransition for the EMI selection view
              SlideTransition(
                position: _slideAnimation,
                child: _buildEMISelectionView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1) The expanded slider card view
  Widget _buildExpandedView() {
    return ExpandedSliderCard(
      key: const ValueKey('expandedView'),
      initialAmount: selectedAmount,
      onAmountChanged: (val) {
        setState(() {
          selectedAmount = val;
        });
      },
      onProceed: _toggleView,
    );
  }

  // 2) The collapsed row view
  Widget _buildCollapsedRow() {
    return CollapsedRow(
      key: const ValueKey('collapsedRow'),
      amount: selectedAmount,
      onTap: _toggleView,
    );
  }

  // 3) The EMI selection view
  Widget _buildEMISelectionView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // EMI Selection Header
          Text(
            "How do you wish to repay?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose one of our recommended plans or make your own",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          // EMI Cards List
          Container(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                EMICardWidget(
                  amountPerMonth: "₹4,247",
                  duration: "12 months",
                  isRecommended: false,
                ),
                const SizedBox(width: 12),
                EMICardWidget(
                  amountPerMonth: "₹5,580",
                  duration: "9 months",
                  isRecommended: true,
                ),
                const SizedBox(width: 12),
                EMICardWidget(
                  amountPerMonth: "₹8,247",
                  duration: "6 months",
                  isRecommended: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Create Your Own Plan Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add your custom plan creation logic here
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          ),
          const SizedBox(height: 40),
          // Select Your Bank Account Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Next flow
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                "Select your bank account",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
