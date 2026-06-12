import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderEmptyView extends StatelessWidget {
  const OrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 20),
          Text(
            "No Orders Yet",
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You haven't placed any orders yet.\nStart shopping to see your orders here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}