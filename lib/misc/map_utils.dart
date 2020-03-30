class MapUtils {
  static dynamic valuePath(Map<String, dynamic> map, String path) {
    List<String> pathElem = path.split('.');
    dynamic value;
    for (int i = 0; i < pathElem.length; ++i) {
      try {
        map = map[pathElem[i]];
        if (map == null) return null;
      } catch (e) {}
      value = map[pathElem[i]];
    }
    return value;
  }
}
