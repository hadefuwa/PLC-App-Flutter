class IOLinkData {
  // H1 Status LED
  final bool h1GreenLed;
  final bool h1AmberLed;
  final bool h1RedLed;

  // Capacitive Proxy Sensor
  final bool capProxyOn;
  final double capProxyTemperature; // in Celsius
  final DateTime? capProxyLastDisconnected;

  IOLinkData({
    this.h1GreenLed = false,
    this.h1AmberLed = false,
    this.h1RedLed = false,
    this.capProxyOn = false,
    this.capProxyTemperature = 25.0,
    this.capProxyLastDisconnected,
  });

  IOLinkData copyWith({
    bool? h1GreenLed,
    bool? h1AmberLed,
    bool? h1RedLed,
    bool? capProxyOn,
    double? capProxyTemperature,
    DateTime? capProxyLastDisconnected,
  }) {
    return IOLinkData(
      h1GreenLed: h1GreenLed ?? this.h1GreenLed,
      h1AmberLed: h1AmberLed ?? this.h1AmberLed,
      h1RedLed: h1RedLed ?? this.h1RedLed,
      capProxyOn: capProxyOn ?? this.capProxyOn,
      capProxyTemperature: capProxyTemperature ?? this.capProxyTemperature,
      capProxyLastDisconnected: capProxyLastDisconnected ?? this.capProxyLastDisconnected,
    );
  }
}

