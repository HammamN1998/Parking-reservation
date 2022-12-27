import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/asset_constants.dart';
import '../../shared/styles.dart';

class Foreground extends StatelessWidget {
  const Foreground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 96),
        Text(
          'Welcome to our parking',
          style: heading4,
        ),
        const SizedBox(height: 1),
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 47),
          child: Text(
            'Control your parking by your phone',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 15 * (3 / 100),
              color: appGreenSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
        // Text(
        //   'POWERED BY',
        //   style: heading3,
        // ),
        // const SizedBox(height: 6),
        // RichText(
        //   text: TextSpan(
        //     text: 'TECH',
        //     style: heading2,
        //     children: <TextSpan>[
        //       TextSpan(text: ' IDARA', style: heading1),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 31),
      ],
    );
  }
}
