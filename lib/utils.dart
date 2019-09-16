String formatCode(String code) {
  print(code);

  return code
      .replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "")
      .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
      .toUpperCase();
}
