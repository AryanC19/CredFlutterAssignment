import 'package:flutter/material.dart';

class EMICardWidget extends StatelessWidget {
  final String amountPerMonth;
  final String duration;
  final bool isRecommended;
  final bool isSelected;

  const EMICardWidget({
    Key? key,
    required this.amountPerMonth,
    required this.duration,
    this.isRecommended = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.brown : Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.brown.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Recommended",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
          SizedBox(height: 12),
          Text(
            amountPerMonth,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            duration,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Spacer(),
          Text(
            "See calculations",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class SliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("EMI Plans"),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How do you wish to repay?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Choose one of our recommended plans or make your own",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  EMICardWidget(
                    amountPerMonth: "₹4,247 /mo",
                    duration: "for 12 months",
                    isSelected: true,
                  ),
                  EMICardWidget(
                    amountPerMonth: "₹5,580 /mo",
                    duration: "for 9 months",
                    isRecommended: true,
                  ),
                  EMICardWidget(
                    amountPerMonth: "₹8,247 /mo",
                    duration: "for 6 months",
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action for creating your own plan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    "Create your own plan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
