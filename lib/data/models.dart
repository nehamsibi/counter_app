class Counter {
  final int value;
  final int maxValue;

  Counter({required this.value, required this.maxValue});

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      value: json['value'],
      maxValue: json['max_value'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'max_value': maxValue,
    };
  }

  Counter counternew({int? value, int? maxValue}) {
    return Counter(
      value: value ?? this.value,
      maxValue: maxValue ?? this.maxValue,
    );
  }
}
