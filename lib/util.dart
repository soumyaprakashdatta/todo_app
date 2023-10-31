String getTimeSinceString(String dateStr) {
  DateTime date;
  Duration dateAgo;
  String sinceStr;

  try {
    date = DateTime.parse(dateStr);
  } on Exception {
    sinceStr = "n/a";
    return sinceStr;
  }

  dateAgo = DateTime.now().difference(date);

  if (dateAgo.inDays >= 1) {
    sinceStr = "${dateAgo.inDays} day ago";
  } else if (dateAgo.inHours >= 1) {
    sinceStr = "${dateAgo.inHours} hr ago";
  } else {
    sinceStr = "${dateAgo.inMinutes} min ago";
  }

  return sinceStr;
}
