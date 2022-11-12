class TerminalCount {
  String? count;

  TerminalCount({this.count});

  factory TerminalCount.fromJson(Map<String, dynamic> json) {
    return TerminalCount(
      count: json['count'],
    );
  }
}
