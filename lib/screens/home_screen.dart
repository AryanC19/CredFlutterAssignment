import 'package:flutter/material.dart';
import '../widgets/emi_card_widget.dart';
import '../widgets/expanded_slider_card.dart';
import '../widgets/collapsed_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = true;
  double selectedAmount = 150000; // The amount from the slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // entire screen background
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: isExpanded
                ? _buildExpandedView()
                : _buildCollapsedAndSecondView(),
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
      onProceed: () {
        // When user taps "Proceed to EMI selection,"
        // collapse this into a row and show the second view
        setState(() {
          isExpanded = false;
        });
      },
    );
  }

  // 2) The collapsed row plus the second portion
  Widget _buildCollapsedAndSecondView() {
    return Container(
      key: const ValueKey('collapsedView'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collapsed row at top
          CollapsedRow(
            amount: selectedAmount,
            onTap: () {
              // Tapping the row or arrow re‐expands the slider
              setState(() {
                isExpanded = true;
              });
            },
          ),
          const SizedBox(height: 24),

          // Second portion
          Text(
            "how do you wish to repay?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "choose one of our recommended plans or make your own",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          Container(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                EMICardWidget(
                  amountPerMonth: "₹4,247",
                  duration: "12 months",
                  isRecommended: false,
                ),
                SizedBox(width: 12),
                EMICardWidget(
                  amountPerMonth: "₹5,580",
                  duration: "9 months",
                  isRecommended: true,
                ),
                SizedBox(width: 12),
                EMICardWidget(
                  amountPerMonth: "₹8,247",
                  duration: "6 months",
                  isRecommended: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add your custom plan creation logic here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
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
          // For example, a button labeled "Select your bank account"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // next flow
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
