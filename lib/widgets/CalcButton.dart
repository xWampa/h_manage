import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final int fillColor;
  final int textColor;
  final double textSize;
  final Function? callback;
  const CalcButton({
    Key? key,
    this.fillColor=0xFFFFFFFF,
    this.textColor=0xFF000000,
    this.textSize=24,
    this.callback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        width: 65,
        height: 65,
        child: TextButton(
          onPressed: () {
            if(callback != null) callback!(text);
          },
          child: Text(text),
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.rubik(
              fontSize: textSize,
            ),
            primary: Color(textColor),
            backgroundColor: Color(fillColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}