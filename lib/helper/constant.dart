import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Color primaryColor = HexColor('#023B47');
Color secondaryColor = HexColor('#1F7879');
Color secondaryTextColor = HexColor('#658E92');

// API Url
String apiUrl = 'http://10.107.233.68:8000/api';

spancer({
  double w = 0,
  double h = 0,
}) {
  return SizedBox(
    height: h,
    width: w,
  );
}

EdgeInsets spacing({double h = 0, double v = 0}) {
  return EdgeInsets.symmetric(
    horizontal: h,
    vertical: v,
  );
}

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;

const double horizontalPadding = 40;
const double verticalPadding = 25;
