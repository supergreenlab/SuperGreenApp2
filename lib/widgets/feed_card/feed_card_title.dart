import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedCardTitle extends StatelessWidget {
  final String icon;
  final String title;
  final FeedEntry feedEntry;

  const FeedCardTitle(this.icon, this.title, this.feedEntry);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
                width: 40,
                height: 40,
                child: icon.endsWith('svg')
                    ? SvgPicture.asset(icon)
                    : Image.asset(icon)),
          ),
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}
