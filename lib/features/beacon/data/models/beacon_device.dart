class BeaconDevice {
  const BeaconDevice({required this.id, required this.name, required this.host, required this.port});

  final String id;
  final String name;
  final String host;
  final int port;

  @override
  bool operator ==(Object other) => other is BeaconDevice && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
