import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String icon;

  const SectionTitle({@required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFECECEC),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _renderIcon(),
          Text(
            this.title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ]),
      ),
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SvgPicture.asset(this.icon),
        ),
      ),
    );
  }
}
