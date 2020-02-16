import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedCardDate extends StatelessWidget {
  final FeedEntry feedEntry;

  const FeedCardDate(this.feedEntry);

  @override
  Widget build(BuildContext context) {
    Duration diff = DateTime.now().difference(feedEntry.date);
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''} ago';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''} ago';
    } else if (dayDiff < 5) {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''} ago';
    } else {
      DateFormat f = DateFormat('yyyy-MM-dd');
      format = f.format(feedEntry.date);
    }
    return Text(format,
        style: TextStyle(color: Colors.black54));
  }
}
