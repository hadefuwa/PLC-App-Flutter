enum SystemState {
  stopped,
  running,
  paused,
  faulted,
}

enum PartMaterial {
  steel,
  aluminium,
  plastic,
}

enum FaultType {
  none,
  eStop,
  sensorStuck,
  paddleJam,
  vacuumLeak,
}

class SimulatorState {
  final SystemState systemState;
  final bool isRunning;
  final FaultType activeFault;

  // Inputs
  final bool firstGate;
  final bool inductive;
  final bool capacitive;
  final bool photoGate;
  final bool eStop;
  final bool gantryHome;

  // Outputs
  final bool conveyor;
  final bool paddleSteel;
  final bool paddleAluminium;
  final bool plungerDown;
  final bool vacuum;
  final bool gantryStep;
  final bool gantryDir;

  // Metrics
  final int steelCount;
  final int aluminiumCount;
  final int plasticCount;
  final int rejectCount;
  final int totalCount;
  final double fpy;
  final double throughput;
  final Duration uptime;

  // Run configuration
  final String currentRecipe;
  final int conveyorSpeed;
  final int batchTarget;

  SimulatorState({
    this.systemState = SystemState.stopped,
    this.isRunning = false,
    this.activeFault = FaultType.none,
    this.firstGate = false,
    this.inductive = false,
    this.capacitive = false,
    this.photoGate = false,
    this.eStop = false,
    this.gantryHome = true,
    this.conveyor = false,
    this.paddleSteel = false,
    this.paddleAluminium = false,
    this.plungerDown = false,
    this.vacuum = false,
    this.gantryStep = false,
    this.gantryDir = false,
    this.steelCount = 0,
    this.aluminiumCount = 0,
    this.plasticCount = 0,
    this.rejectCount = 0,
    this.totalCount = 0,
    this.fpy = 100.0,
    this.throughput = 0.0,
    this.uptime = Duration.zero,
    this.currentRecipe = 'Steel/Aluminium/Plastic Sorting',
    this.conveyorSpeed = 50,
    this.batchTarget = 100,
  });

  SimulatorState copyWith({
    SystemState? systemState,
    bool? isRunning,
    FaultType? activeFault,
    bool? firstGate,
    bool? inductive,
    bool? capacitive,
    bool? photoGate,
    bool? eStop,
    bool? gantryHome,
    bool? conveyor,
    bool? paddleSteel,
    bool? paddleAluminium,
    bool? plungerDown,
    bool? vacuum,
    bool? gantryStep,
    bool? gantryDir,
    int? steelCount,
    int? aluminiumCount,
    int? plasticCount,
    int? rejectCount,
    int? totalCount,
    double? fpy,
    double? throughput,
    Duration? uptime,
    String? currentRecipe,
    int? conveyorSpeed,
    int? batchTarget,
  }) {
    return SimulatorState(
      systemState: systemState ?? this.systemState,
      isRunning: isRunning ?? this.isRunning,
      activeFault: activeFault ?? this.activeFault,
      firstGate: firstGate ?? this.firstGate,
      inductive: inductive ?? this.inductive,
      capacitive: capacitive ?? this.capacitive,
      photoGate: photoGate ?? this.photoGate,
      eStop: eStop ?? this.eStop,
      gantryHome: gantryHome ?? this.gantryHome,
      conveyor: conveyor ?? this.conveyor,
      paddleSteel: paddleSteel ?? this.paddleSteel,
      paddleAluminium: paddleAluminium ?? this.paddleAluminium,
      plungerDown: plungerDown ?? this.plungerDown,
      vacuum: vacuum ?? this.vacuum,
      gantryStep: gantryStep ?? this.gantryStep,
      gantryDir: gantryDir ?? this.gantryDir,
      steelCount: steelCount ?? this.steelCount,
      aluminiumCount: aluminiumCount ?? this.aluminiumCount,
      plasticCount: plasticCount ?? this.plasticCount,
      rejectCount: rejectCount ?? this.rejectCount,
      totalCount: totalCount ?? this.totalCount,
      fpy: fpy ?? this.fpy,
      throughput: throughput ?? this.throughput,
      uptime: uptime ?? this.uptime,
      currentRecipe: currentRecipe ?? this.currentRecipe,
      conveyorSpeed: conveyorSpeed ?? this.conveyorSpeed,
      batchTarget: batchTarget ?? this.batchTarget,
    );
  }

  int get producedCount => steelCount + aluminiumCount + plasticCount;
  int get remainingCount => batchTarget - producedCount;
}
