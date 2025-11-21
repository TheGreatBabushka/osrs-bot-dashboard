class Script {
  final String name;
  final String? parameters;

  Script({
    required this.name,
    this.parameters,
  });

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      name: json['name'] as String,
      parameters: json['parameters'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Script &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          parameters == other.parameters;

  @override
  int get hashCode => name.hashCode ^ parameters.hashCode;

  @override
  String toString() {
    return 'Script{name: $name, parameters: $parameters}';
  }
}
