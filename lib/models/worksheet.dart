class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class Worksheet {
  final String id;
  final String title;
  final String goal;
  final int estimatedMinutes;
  final String content;
  final List<String> steps;
  final List<String> overToYou;
  final String soWhat;
  final List<String> keyTakeaways;
  final List<QuizQuestion> quiz;

  Worksheet({
    required this.id,
    required this.title,
    required this.goal,
    required this.estimatedMinutes,
    required this.content,
    required this.steps,
    required this.overToYou,
    required this.soWhat,
    required this.keyTakeaways,
    required this.quiz,
  });

  static List<Worksheet> getWorksheets() {
    return [
      // WS01: Understanding Sensors
      Worksheet(
        id: 'WS01',
        title: 'Understanding Sensors',
        goal: 'Learn about the different sensor types and their functions in industrial automation',
        estimatedMinutes: 30,
        content: 'Sensors are the foundation of any smart manufacturing system. They act as the "eyes and ears" of automated equipment, providing real-time information about materials, positions, and process states. In this worksheet, you will explore three critical sensor technologies: optical sensors that detect object presence using light beams, inductive sensors that identify ferrous metals through magnetic field disruption, and capacitive sensors that detect non-ferrous materials by measuring changes in electrical capacitance. Understanding when and how to use each sensor type is essential for designing reliable automated systems.',
        steps: [
          'Navigate to the I/O screen using the bottom navigation bar to access all input and output controls.',
          'Locate the First Gate sensor (optical) in the inputs section - this sensor detects when any object enters the system by breaking a light beam.',
          'Study how the Inductive sensor responds to ferrous metals like steel by generating a magnetic field that changes when metal is present.',
        ],
        overToYou: [
          'Open the I/O screen and start the system in simulation mode to observe sensor behavior.',
          'Watch each sensor indicator light up green as simulated materials pass through the system.',
          'Switch to the manual controls section and manually trigger different sensors to see their response.',
          'Try triggering the optical sensor first, then the inductive sensor, and observe the timing.',
          'Experiment with triggering sensors in different sequences to understand their individual detection zones.',
          'Document which sensors activate for steel parts versus aluminium parts.',
        ],
        soWhat: 'Understanding sensor technology is fundamental to smart manufacturing. Different materials require different detection methods - optical sensors detect presence regardless of material, inductive sensors specifically detect ferrous metals through magnetic field changes, and capacitive sensors detect non-ferrous materials through electric field variations. Knowing which sensor to use for which application prevents costly mistakes in system design and ensures reliable operation in production environments.',
        keyTakeaways: [
          'Optical sensors detect object presence using light beams and work with any material type.',
          'Inductive sensors specifically detect ferrous (magnetic) metals like steel through magnetic field disruption.',
          'Capacitive sensors detect non-ferrous metals like aluminium by measuring electrical capacitance changes.',
          'Multiple sensor types are needed because each detects different material properties and characteristics.',
        ],
        quiz: [
          QuizQuestion(
            question: 'Which sensor type would you use to detect steel parts on a conveyor belt?',
            options: ['Optical sensor', 'Inductive sensor', 'Capacitive sensor', 'Photo gate sensor'],
            correctAnswerIndex: 1,
            explanation: 'Inductive sensors detect ferrous (magnetic) metals like steel by creating a magnetic field. When steel enters this field, it disrupts the magnetic flux, triggering the sensor.',
          ),
          QuizQuestion(
            question: 'What does an optical sensor primarily detect?',
            options: ['Metal type', 'Object presence', 'Material temperature', 'Part weight'],
            correctAnswerIndex: 1,
            explanation: 'Optical sensors use light beams to detect the presence of any object. When an object breaks the beam, the sensor triggers, regardless of the material type.',
          ),
          QuizQuestion(
            question: 'Why do we need multiple sensor types in the smart factory?',
            options: [
              'For redundancy in case one sensor fails',
              'To detect different material properties and types',
              'To make the system more complex and expensive',
              'They all perform the same function',
            ],
            correctAnswerIndex: 1,
            explanation: 'Different sensors detect different properties: optical for presence detection, inductive for ferrous metals, and capacitive for non-ferrous metals. Each is specialized for specific detection tasks.',
          ),
          QuizQuestion(
            question: 'Which sensor would successfully detect an aluminium part?',
            options: ['Inductive sensor only', 'Photo gate only', 'Capacitive sensor', 'None of these sensors'],
            correctAnswerIndex: 2,
            explanation: 'Capacitive sensors detect non-ferrous metals like aluminium through changes in electric field capacity. Inductive sensors cannot detect aluminium as it is non-magnetic.',
          ),
          QuizQuestion(
            question: 'What is the Photo Gate sensor primarily used for in automation?',
            options: ['Color detection', 'Weight measurement', 'Precise position detection', 'Temperature sensing'],
            correctAnswerIndex: 2,
            explanation: 'The Photo Gate sensor provides precise position information, allowing the system to know exactly where a part is located on the conveyor for coordinated operations.',
          ),
        ],
      ),

      // WS02: Reject Mechanisms
      Worksheet(
        id: 'WS02',
        title: 'Reject Mechanisms',
        goal: 'Understand how defective parts are detected and removed from the production line',
        estimatedMinutes: 35,
        content: 'Quality control is critical in manufacturing. The reject mechanism is an automated system that identifies defective parts and removes them from the production line before they can be assembled or shipped to customers. This system combines sensor technology with pneumatic actuation to physically divert bad parts into a reject bin. Understanding how reject systems work is essential for maintaining product quality and preventing defective items from reaching customers, which could damage reputation and result in costly recalls.',
        steps: [
          'Review the defect detection logic that determines when a part should be rejected based on sensor inputs and quality criteria.',
          'Examine how the reject solenoid is controlled - it activates a pneumatic cylinder that pushes defective parts off the conveyor.',
          'Study the timing requirements - the reject mechanism must activate at precisely the right moment as the defective part passes the rejection point.',
        ],
        overToYou: [
          'Navigate to the I/O screen and locate the Reject Solenoid output control.',
          'Run the system in simulation mode and observe when parts are marked as defective.',
          'Watch the reject solenoid activate to divert defective parts into the reject bin.',
          'Manually trigger the reject solenoid using the output controls to see the physical action.',
          'Count how many parts are rejected versus accepted in a typical production run.',
          'Analyze whether the reject timing is accurate - are good parts being rejected or bad parts getting through?',
        ],
        soWhat: 'Reject mechanisms are your last line of defense against shipping defective products to customers. A well-designed reject system protects your brand reputation, reduces warranty claims, and ensures customer satisfaction. Understanding the interplay between defect detection sensors and the reject actuator timing is crucial for building quality into the manufacturing process rather than trying to inspect quality in afterward.',
        keyTakeaways: [
          'Reject mechanisms automatically remove defective parts from the production line before shipment.',
          'Precise timing is critical - the reject solenoid must activate exactly when the defective part is in position.',
          'Quality control systems combine multiple sensor inputs to make accurate accept/reject decisions.',
          'Automated rejection is more consistent and reliable than manual inspection processes.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary purpose of a reject mechanism in manufacturing?',
            options: [
              'To slow down the production line',
              'To remove defective parts from the production flow',
              'To count the number of parts produced',
              'To stop the entire system when errors occur',
            ],
            correctAnswerIndex: 1,
            explanation: 'The reject mechanism automatically identifies and removes defective parts from the production line, ensuring only good parts continue to the next process step.',
          ),
          QuizQuestion(
            question: 'Why is timing critical for the reject solenoid activation?',
            options: [
              'To save energy by minimizing solenoid on-time',
              'To ensure the defective part is in the correct position when rejected',
              'To prevent the solenoid from overheating',
              'Timing is not important for reject systems',
            ],
            correctAnswerIndex: 1,
            explanation: 'The reject solenoid must activate at precisely the right moment when the defective part is at the rejection point. Too early or too late, and the wrong part gets rejected.',
          ),
          QuizQuestion(
            question: 'What happens to parts that are rejected by the system?',
            options: [
              'They are automatically repaired',
              'They are diverted to a reject bin for later analysis',
              'They continue through the production line',
              'The system shuts down',
            ],
            correctAnswerIndex: 1,
            explanation: 'Rejected parts are diverted to a reject bin where they can be analyzed later to identify the root cause of defects and improve the process.',
          ),
          QuizQuestion(
            question: 'Which type of actuator is commonly used for reject mechanisms?',
            options: [
              'Electric motor',
              'Hydraulic cylinder',
              'Pneumatic cylinder',
              'Servo motor',
            ],
            correctAnswerIndex: 2,
            explanation: 'Pneumatic cylinders are commonly used for reject mechanisms because they provide fast, powerful linear motion and are cost-effective for simple push operations.',
          ),
          QuizQuestion(
            question: 'What is the consequence of a poorly timed reject mechanism?',
            options: [
              'Increased energy consumption',
              'Good parts may be rejected or bad parts may pass through',
              'Faster production rates',
              'No significant impact',
            ],
            correctAnswerIndex: 1,
            explanation: 'Poor timing can result in false rejects (good parts discarded) or missed rejects (defective parts continuing through), both of which are costly quality failures.',
          ),
        ],
      ),

      // WS03: Understanding the Conveyor
      Worksheet(
        id: 'WS03',
        title: 'Understanding the Conveyor',
        goal: 'Master conveyor speed control and understand its impact on production throughput',
        estimatedMinutes: 30,
        content: 'The conveyor belt is the backbone of material handling in automated manufacturing. It transports parts between different processing stations at a controlled speed. Understanding conveyor operation is crucial because conveyor speed directly affects production throughput, sensor timing, and the coordination of all other system components. Too fast, and sensors may miss parts or actuators may not have time to respond. Too slow, and production throughput suffers. This worksheet explores how conveyor speed is controlled and optimized.',
        steps: [
          'Learn how the conveyor motor is controlled using pulse-width modulation (PWM) or variable frequency drives (VFD) to achieve precise speed control.',
          'Understand the relationship between conveyor speed and cycle time - faster conveyors increase throughput but require faster sensor and actuator response.',
          'Study how sensor detection zones are affected by conveyor speed - parts moving faster have less time in the detection zone.',
        ],
        overToYou: [
          'Go to the I/O screen and locate the Conveyor output control.',
          'Start the conveyor at low speed and observe how parts move through the system.',
          'Gradually increase the conveyor speed and watch how sensor timing changes.',
          'Identify the maximum speed at which the system can still reliably detect and process all parts.',
          'Experiment with stopping and starting the conveyor using the manual controls.',
          'Measure the time it takes for a part to travel from the first sensor to the end of the conveyor at different speeds.',
        ],
        soWhat: 'Conveyor speed optimization is a balancing act between maximizing throughput and maintaining reliable operation. Understanding this relationship allows you to tune production systems for optimal performance. In real manufacturing, conveyor speed affects energy consumption, wear on mechanical components, and the overall equipment effectiveness (OEE) of the entire production line. Getting it right means producing more with less waste.',
        keyTakeaways: [
          'Conveyor speed directly impacts production throughput and cycle time.',
          'Faster conveyors require faster sensor response times and actuator activation.',
          'Speed must be optimized to balance throughput with reliable detection and processing.',
          'Variable speed control allows the system to adapt to different products and production requirements.',
        ],
        quiz: [
          QuizQuestion(
            question: 'How does increasing conveyor speed affect production throughput?',
            options: [
              'Decreases throughput',
              'Has no effect on throughput',
              'Increases throughput up to the point where reliability suffers',
              'Only affects energy consumption',
            ],
            correctAnswerIndex: 2,
            explanation: 'Faster conveyor speed increases throughput by moving more parts per hour, but only up to the point where sensors and actuators can still respond reliably. Beyond that, errors increase.',
          ),
          QuizQuestion(
            question: 'What control method is commonly used for precise conveyor speed control?',
            options: [
              'On/off switching',
              'Pulse-width modulation (PWM) or variable frequency drives (VFD)',
              'Manual speed adjustment',
              'Hydraulic control',
            ],
            correctAnswerIndex: 1,
            explanation: 'PWM and VFD provide precise, continuously variable speed control by modulating motor power or frequency, allowing fine-tuning of conveyor speed.',
          ),
          QuizQuestion(
            question: 'What happens to sensor detection if the conveyor speed is too fast?',
            options: [
              'Sensors become more accurate',
              'Sensors may miss parts or have insufficient time to respond',
              'Sensors automatically adjust their response time',
              'Speed has no effect on sensor performance',
            ],
            correctAnswerIndex: 1,
            explanation: 'At excessive speeds, parts spend less time in the sensor detection zone, potentially causing the sensor to miss detections or not have enough time to process the signal.',
          ),
          QuizQuestion(
            question: 'Why is variable speed control important for conveyors?',
            options: [
              'It is not important; fixed speed is sufficient',
              'It allows optimization for different products and production requirements',
              'It only saves energy',
              'It makes the system more complex',
            ],
            correctAnswerIndex: 1,
            explanation: 'Variable speed control allows the system to run at optimal speeds for different products, adjust to process variations, and balance throughput with quality and reliability.',
          ),
          QuizQuestion(
            question: 'What is the primary trade-off when setting conveyor speed?',
            options: [
              'Cost versus performance',
              'Throughput versus reliability and detection accuracy',
              'Energy consumption versus noise level',
              'Size versus weight',
            ],
            correctAnswerIndex: 1,
            explanation: 'The primary trade-off is between maximizing throughput (faster speed) and maintaining reliable part detection and processing (requiring adequate response time).',
          ),
        ],
      ),

      // WS04: Sorting Counters
      Worksheet(
        id: 'WS04',
        title: 'Sorting Counters',
        goal: 'Learn how to track and count different material types for inventory management',
        estimatedMinutes: 30,
        content: 'Material tracking and counting are essential for inventory management, production reporting, and quality control. The smart factory uses sorting counters to track how many parts of each type (steel, aluminium, good, defective) have been processed. These counters are incremented based on sensor readings and quality inspection results. Accurate counting enables data-driven decisions about production efficiency, material usage, and defect rates. This worksheet explores how counters work and why they are critical for manufacturing intelligence.',
        steps: [
          'Understand how counters are incremented based on sensor inputs - each time a sensor detects a specific material type, the corresponding counter increases.',
          'Learn the difference between hardware counters (built into PLCs) and software counters (maintained by control programs).',
          'Study how counters are reset at the beginning of each production run to track batch-specific quantities.',
        ],
        overToYou: [
          'Navigate to the Analytics screen to view the current counter values.',
          'Run a production cycle in simulation mode and watch the counters increment in real-time.',
          'Count manually how many steel parts pass through and verify the counter matches your manual count.',
          'Do the same for aluminium parts to verify accurate counting.',
          'Check the defect counter and verify it matches the number of rejected parts.',
          'Reset all counters and run another production cycle to see counters start from zero.',
        ],
        soWhat: 'Accurate counting is the foundation of production metrics like First Pass Yield (FPY), defect rates, and Overall Equipment Effectiveness (OEE). Without reliable counters, you cannot measure performance, identify trends, or make data-driven improvements. In real manufacturing, counting errors can lead to inventory discrepancies, incorrect production reports, and poor decision-making. Understanding how to implement and verify counting systems ensures data integrity.',
        keyTakeaways: [
          'Counters track quantities of different material types and production outcomes.',
          'Accurate counting is essential for calculating production metrics and KPIs.',
          'Counters must be reset at the start of each production run or batch.',
          'Counter data enables inventory management and production reporting.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary purpose of sorting counters in manufacturing?',
            options: [
              'To control conveyor speed',
              'To track quantities of different material types and production outcomes',
              'To detect defective parts',
              'To operate the reject mechanism',
            ],
            correctAnswerIndex: 1,
            explanation: 'Sorting counters track how many parts of each type have been processed, providing essential data for inventory management, production reporting, and quality metrics.',
          ),
          QuizQuestion(
            question: 'When should production counters be reset?',
            options: [
              'Never - counters should accumulate indefinitely',
              'At the start of each production run or batch',
              'Only when the system is shut down',
              'Every hour automatically',
            ],
            correctAnswerIndex: 1,
            explanation: 'Counters are typically reset at the start of each production run or batch to track quantities specific to that run, enabling batch-level reporting and traceability.',
          ),
          QuizQuestion(
            question: 'How are counters typically incremented in an automated system?',
            options: [
              'Manually by an operator',
              'Automatically based on sensor inputs and inspection results',
              'Randomly by the control system',
              'Based on time intervals',
            ],
            correctAnswerIndex: 1,
            explanation: 'Counters are automatically incremented when sensors detect parts or when inspection systems identify specific outcomes (good, defective, etc.), ensuring accurate real-time tracking.',
          ),
          QuizQuestion(
            question: 'What production metric requires accurate counter data?',
            options: [
              'Conveyor speed',
              'First Pass Yield (FPY) and defect rate',
              'Sensor sensitivity',
              'Motor torque',
            ],
            correctAnswerIndex: 1,
            explanation: 'FPY and defect rates are calculated from counter data (good parts / total parts). Inaccurate counters lead to incorrect metrics and poor decision-making.',
          ),
          QuizQuestion(
            question: 'What is the consequence of inaccurate counting in production?',
            options: [
              'Increased energy consumption',
              'Inventory discrepancies and incorrect production reports',
              'Faster production rates',
              'Better quality control',
            ],
            correctAnswerIndex: 1,
            explanation: 'Inaccurate counting leads to inventory errors, incorrect production metrics, and poor business decisions based on faulty data. Data integrity depends on reliable counters.',
          ),
        ],
      ),

      // WS05: Driving the Stepper Motor
      Worksheet(
        id: 'WS05',
        title: 'Driving the Stepper Motor',
        goal: 'Understand stepper motor operation and precise positioning control for the gantry system',
        estimatedMinutes: 35,
        content: 'Stepper motors are widely used in automation because they provide precise position control without the need for feedback sensors. Unlike standard motors that spin continuously, stepper motors move in discrete steps, typically 1.8 degrees per step (200 steps per revolution). The gantry system uses a stepper motor to position the pick-and-place mechanism accurately above parts on the conveyor. Understanding stepper motor control is essential for any application requiring precise positioning, from 3D printers to CNC machines to robotic systems.',
        steps: [
          'Learn how stepper motors work - they have multiple electromagnetic coils that are energized in sequence to rotate the motor shaft in precise steps.',
          'Understand the difference between full-step, half-step, and microstepping modes - each provides different trade-offs between resolution and torque.',
          'Study how step rate (steps per second) determines motor speed and how to avoid exceeding the motor maximum step rate.',
        ],
        overToYou: [
          'Navigate to the I/O screen and locate the Stepper Motor controls.',
          'Command the stepper motor to move a specific number of steps in one direction.',
          'Reverse direction and return the motor to its starting position.',
          'Experiment with different step rates to see how speed affects movement smoothness.',
          'Try moving the gantry to specific positions and verify positioning accuracy.',
          'Observe what happens if you try to move too fast - does the motor skip steps or stall?',
        ],
        soWhat: 'Stepper motors are fundamental to precision automation. Their ability to move in exact increments without feedback makes them ideal for applications where position accuracy is critical. Understanding how to control stepper motors opens the door to building CNC machines, 3D printers, robotic arms, and automated positioning systems. The trade-offs between speed, torque, and resolution are key considerations in any motion control application.',
        keyTakeaways: [
          'Stepper motors provide precise positioning by moving in discrete steps rather than continuous rotation.',
          'Position control is achieved by counting steps without requiring position feedback sensors.',
          'Step rate determines motor speed - too fast and the motor may skip steps or stall.',
          'Microstepping increases resolution and smoothness but may reduce holding torque.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary advantage of stepper motors over standard DC motors?',
            options: [
              'Higher maximum speed',
              'Precise position control without feedback sensors',
              'Lower cost',
              'Higher power output',
            ],
            correctAnswerIndex: 1,
            explanation: 'Stepper motors can be positioned precisely by counting steps, eliminating the need for encoders or other position feedback sensors. Each step moves a known distance.',
          ),
          QuizQuestion(
            question: 'How many steps per revolution do most common stepper motors have?',
            options: [
              '50 steps',
              '100 steps',
              '200 steps (1.8 degrees per step)',
              '500 steps',
            ],
            correctAnswerIndex: 2,
            explanation: 'The most common stepper motors have 200 steps per revolution, which equals 1.8 degrees per step (360 degrees / 200 steps = 1.8 degrees).',
          ),
          QuizQuestion(
            question: 'What happens if you exceed the maximum step rate of a stepper motor?',
            options: [
              'The motor spins faster',
              'The motor may skip steps or stall completely',
              'The motor automatically reduces speed',
              'Nothing - motors can run at any speed',
            ],
            correctAnswerIndex: 1,
            explanation: 'Exceeding the maximum step rate means the motor cannot respond quickly enough to the step pulses, causing it to skip steps (losing position) or stall (stop moving).',
          ),
          QuizQuestion(
            question: 'What is microstepping in stepper motor control?',
            options: [
              'Running the motor very slowly',
              'Subdividing each full step into smaller increments for smoother motion',
              'Using very small stepper motors',
              'Skipping certain steps to go faster',
            ],
            correctAnswerIndex: 1,
            explanation: 'Microstepping divides each full step into smaller increments (like 1/16 or 1/32 step) by varying the current to the motor coils, resulting in smoother motion and higher resolution.',
          ),
          QuizQuestion(
            question: 'In the gantry system, what is the stepper motor used for?',
            options: [
              'Driving the conveyor belt',
              'Positioning the pick-and-place mechanism above parts',
              'Operating the reject mechanism',
              'Controlling sensor sensitivity',
            ],
            correctAnswerIndex: 1,
            explanation: 'The stepper motor positions the gantry horizontally so the pick-and-place mechanism can be precisely aligned above the part to be picked up from the conveyor.',
          ),
        ],
      ),

      // WS06: Understanding the Plunger
      Worksheet(
        id: 'WS06',
        title: 'Understanding the Plunger',
        goal: 'Learn about pneumatic plunger operation, safety considerations, and pick-and-place applications',
        estimatedMinutes: 30,
        content: 'The pneumatic plunger is a vertically-oriented pneumatic cylinder that provides the up-down motion for the pick-and-place mechanism. When activated, compressed air forces the plunger down to pick up or place parts. When deactivated, a spring or air pressure returns it to the up position. Understanding pneumatic systems is critical for industrial automation because pneumatics provide fast, powerful, and reliable linear motion. This worksheet covers plunger operation, safety considerations, and coordination with the gantry stepper motor.',
        steps: [
          'Learn the basic principles of pneumatic cylinders - compressed air provides force to extend the cylinder, and springs or reverse air pressure retract it.',
          'Understand the importance of pressure regulation - too much pressure can damage parts or equipment, too little may fail to complete the action.',
          'Study safety considerations - pneumatic systems store significant energy and require proper guarding, emergency stops, and pressure relief valves.',
        ],
        overToYou: [
          'Navigate to the I/O screen and locate the Plunger Solenoid output control.',
          'Manually activate the plunger and observe the down stroke motion.',
          'Deactivate the plunger and watch it return to the up position.',
          'Practice coordinating plunger activation with gantry position - move gantry to a part, then activate plunger.',
          'Time how long the plunger takes to complete a full down-up cycle.',
          'Experiment with different timing to understand the coordination required for reliable pick-and-place operations.',
        ],
        soWhat: 'Pneumatic systems are ubiquitous in manufacturing because they provide clean, fast, and powerful linear motion from a simple air supply. Understanding pneumatics is essential for automation careers. The plunger demonstrates key pneumatic concepts: solenoid valve control, force generation from compressed air, and the timing coordination required when pneumatic actuators work with other motion systems. Safety is paramount - pneumatic energy can cause injury if not properly controlled.',
        keyTakeaways: [
          'Pneumatic cylinders use compressed air to generate fast, powerful linear motion.',
          'Solenoid valves control airflow to extend and retract pneumatic actuators.',
          'Pressure regulation is critical for reliable operation and preventing damage.',
          'Coordination between pneumatic actuators and other motion systems requires careful timing.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What energy source powers the pneumatic plunger?',
            options: [
              'Electricity',
              'Compressed air',
              'Hydraulic fluid',
              'Springs only',
            ],
            correctAnswerIndex: 1,
            explanation: 'Pneumatic cylinders are powered by compressed air. When air is directed into the cylinder, it pushes the piston, extending or retracting the plunger.',
          ),
          QuizQuestion(
            question: 'What component controls the airflow to the pneumatic plunger?',
            options: [
              'Manual valve',
              'Solenoid valve',
              'Check valve',
              'Pressure regulator',
            ],
            correctAnswerIndex: 1,
            explanation: 'A solenoid valve is an electrically-controlled valve that directs compressed air to extend or retract the pneumatic cylinder. When energized, it switches air flow paths.',
          ),
          QuizQuestion(
            question: 'Why is pressure regulation important in pneumatic systems?',
            options: [
              'To reduce noise only',
              'To prevent damage from excessive force and ensure consistent operation',
              'To save compressed air',
              'Pressure regulation is not important',
            ],
            correctAnswerIndex: 1,
            explanation: 'Pressure regulation ensures consistent force output and prevents excessive force that could damage parts or equipment. It also provides predictable cycle times.',
          ),
          QuizQuestion(
            question: 'What safety consideration is most critical with pneumatic systems?',
            options: [
              'Color of the pneumatic lines',
              'Stored energy in compressed air requires proper guarding and emergency stops',
              'Pneumatic systems have no safety concerns',
              'Only electrical safety matters',
            ],
            correctAnswerIndex: 1,
            explanation: 'Pneumatic systems store significant energy in compressed air. Unexpected releases or rapid movements can cause injury, requiring proper machine guarding and emergency stop systems.',
          ),
          QuizQuestion(
            question: 'What must be coordinated for successful pick-and-place operation?',
            options: [
              'Only plunger timing',
              'Gantry position, plunger activation timing, and conveyor state',
              'Only conveyor speed',
              'No coordination is needed',
            ],
            correctAnswerIndex: 1,
            explanation: 'Successful pick-and-place requires the gantry to be positioned over the part, the conveyor to be stopped or synchronized, and the plunger to activate at the right time.',
          ),
        ],
      ),

      // WS07: Delivering Counters
      Worksheet(
        id: 'WS07',
        title: 'Delivering Counters',
        goal: 'Optimize production throughput by analyzing and improving delivery rates',
        estimatedMinutes: 35,
        content: 'Production throughput - the number of parts delivered per unit time - is a critical performance metric in manufacturing. The delivery counter tracks how many parts have successfully completed all processing steps and been delivered to the output. Optimizing throughput involves balancing conveyor speed, cycle times, and process reliability. This worksheet focuses on measuring current throughput, identifying bottlenecks, and implementing improvements to increase the delivery rate without sacrificing quality.',
        steps: [
          'Understand the concept of cycle time - the time from when one part enters the system to when the next part can enter.',
          'Learn how to calculate throughput rate: parts delivered / time period (e.g., parts per minute or parts per hour).',
          'Identify system bottlenecks - the slowest operation that limits overall throughput. Improving non-bottleneck operations has no effect on throughput.',
        ],
        overToYou: [
          'Navigate to the Analytics screen and monitor the delivery counter in real-time.',
          'Run a timed production session (e.g., 5 minutes) and count total parts delivered.',
          'Calculate the throughput rate in parts per minute.',
          'Identify which operation takes the longest - conveyor travel time, pick-and-place cycle, or inspection.',
          'Experiment with increasing conveyor speed and measure the new throughput rate.',
          'Determine the maximum throughput before errors or misses begin to occur.',
        ],
        soWhat: 'Throughput optimization is the essence of manufacturing efficiency. Higher throughput means more parts produced with the same equipment, reducing per-unit costs and improving profitability. However, pushing throughput too high can increase errors and defects. Understanding how to measure and optimize throughput while maintaining quality is a core skill for manufacturing engineers. The Theory of Constraints teaches that improving the bottleneck operation is the only way to improve system throughput.',
        keyTakeaways: [
          'Throughput rate measures parts delivered per unit time and is a key performance indicator.',
          'Cycle time is the limiting factor for maximum throughput.',
          'System bottlenecks determine maximum throughput - only improving bottlenecks increases throughput.',
          'Optimization requires balancing throughput with quality and reliability.',
        ],
        quiz: [
          QuizQuestion(
            question: 'How is production throughput calculated?',
            options: [
              'Total parts produced / cost',
              'Parts delivered / time period',
              'Conveyor speed x time',
              'Number of sensors / parts',
            ],
            correctAnswerIndex: 1,
            explanation: 'Throughput is calculated as parts delivered divided by time period, typically expressed as parts per minute or parts per hour.',
          ),
          QuizQuestion(
            question: 'What is a system bottleneck?',
            options: [
              'The fastest operation in the system',
              'The slowest operation that limits overall throughput',
              'Any broken equipment',
              'The conveyor belt',
            ],
            correctAnswerIndex: 1,
            explanation: 'A bottleneck is the slowest operation in a system that limits overall throughput. The system can only go as fast as its slowest component.',
          ),
          QuizQuestion(
            question: 'What happens if you improve a non-bottleneck operation?',
            options: [
              'System throughput increases significantly',
              'System throughput remains unchanged because the bottleneck still limits output',
              'System throughput decreases',
              'Quality improves dramatically',
            ],
            correctAnswerIndex: 1,
            explanation: 'Improving non-bottleneck operations has no effect on system throughput because the bottleneck still limits the overall rate. Only improving the bottleneck increases throughput.',
          ),
          QuizQuestion(
            question: 'What is cycle time in manufacturing?',
            options: [
              'The time to produce one complete batch',
              'The time from when one part enters to when the next part can enter',
              'The shift length',
              'The time to start up the system',
            ],
            correctAnswerIndex: 1,
            explanation: 'Cycle time is the interval between successive parts entering or exiting the system. It directly determines the maximum throughput rate (throughput = 1 / cycle time).',
          ),
          QuizQuestion(
            question: 'What risk comes with maximizing throughput?',
            options: [
              'Lower energy costs',
              'Increased errors and defects if quality is sacrificed for speed',
              'Better product quality',
              'No risks - maximum throughput is always best',
            ],
            correctAnswerIndex: 1,
            explanation: 'Pushing throughput too high can exceed system response capabilities, leading to missed detections, timing errors, and increased defect rates. Optimization must balance throughput and quality.',
          ),
        ],
      ),

      // WS08: Robot Arm
      Worksheet(
        id: 'WS08',
        title: 'Robot Arm',
        goal: 'Understand robot kinematics, pick-and-place programming, and workspace coordination',
        estimatedMinutes: 40,
        content: 'Industrial robots are the workhorses of modern manufacturing, performing repetitive tasks with precision and consistency. The robot arm in the smart factory demonstrates fundamental robotics concepts: kinematics (how joint movements translate to end-effector position), coordinate systems (world coordinates vs. robot coordinates), and task programming (defining pick and place positions). Understanding these concepts is essential for programming and operating industrial robots in automotive, electronics, and packaging applications.',
        steps: [
          'Learn about robot kinematics - how rotating or extending individual joints moves the end-effector (gripper) to desired positions in 3D space.',
          'Understand coordinate systems - the robot operates in its own coordinate frame, which must be transformed to world coordinates where parts are located.',
          'Study the pick-and-place sequence: move above pick location, lower to pick height, close gripper, raise, move to place location, lower to place height, open gripper, raise.',
        ],
        overToYou: [
          'Navigate to the I/O screen and locate the robot arm control outputs.',
          'Observe the robot arm performing a pick-and-place cycle in simulation mode.',
          'Study the sequence of movements - approach, pick, transfer, place, return.',
          'Identify the coordinate positions for pick and place locations.',
          'Experiment with manually controlling individual robot joints to understand their motion.',
          'Try modifying pick or place positions and observe how the robot adapts its path.',
        ],
        soWhat: 'Industrial robots have transformed manufacturing by providing consistent, precise, and tireless automation. Understanding robot programming and coordination is a highly valuable skill. The concepts learned here - kinematics, coordinate systems, and task sequencing - apply to all industrial robots from simple pick-and-place to complex assembly operations. Robots enable lights-out manufacturing and mass customization that would be impossible with manual labor.',
        keyTakeaways: [
          'Robot kinematics describes how joint movements translate to end-effector position in 3D space.',
          'Coordinate system transformation aligns robot coordinates with world coordinates.',
          'Pick-and-place operations follow a programmed sequence of move, grasp, transfer, and release steps.',
          'Industrial robots provide consistency, precision, and repeatability for manufacturing tasks.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is robot kinematics?',
            options: [
              'The study of robot colors',
              'The mathematical relationship between joint movements and end-effector position',
              'The robot programming language',
              'The robot power consumption',
            ],
            correctAnswerIndex: 1,
            explanation: 'Kinematics is the study of motion. Robot kinematics calculates how individual joint rotations or extensions combine to position the end-effector at a desired location in 3D space.',
          ),
          QuizQuestion(
            question: 'What is the typical sequence for a pick-and-place operation?',
            options: [
              'Pick, place, move',
              'Move above pick, lower, grasp, raise, move to place, lower, release, raise',
              'Grasp, move, release',
              'Lower, grasp, place',
            ],
            correctAnswerIndex: 1,
            explanation: 'A safe pick-and-place sequence moves above the object first (avoiding collisions), lowers to pick height, grasps, raises, moves to place location, lowers, releases, and raises again.',
          ),
          QuizQuestion(
            question: 'Why are coordinate systems important in robotics?',
            options: [
              'To name robot parts',
              'To transform between robot coordinates and world coordinates where objects are located',
              'To calculate robot weight',
              'Coordinate systems are not important',
            ],
            correctAnswerIndex: 1,
            explanation: 'Robots operate in their own coordinate frame, but parts are located in world coordinates. Coordinate transformations align these frames so the robot can accurately reach target positions.',
          ),
          QuizQuestion(
            question: 'What is the end-effector of a robot?',
            options: [
              'The robot base',
              'The tool or gripper attached to the end of the robot arm',
              'The robot controller',
              'The power supply',
            ],
            correctAnswerIndex: 1,
            explanation: 'The end-effector is the tool at the end of the robot arm - it could be a gripper, welding torch, paint sprayer, or other specialized tool depending on the application.',
          ),
          QuizQuestion(
            question: 'What advantage do robots provide over manual labor in manufacturing?',
            options: [
              'Lower initial cost',
              'Consistency, precision, and ability to work continuously without fatigue',
              'Flexibility to handle unexpected situations',
              'No advantages',
            ],
            correctAnswerIndex: 1,
            explanation: 'Robots excel at repetitive tasks requiring precision and consistency. They can work 24/7 without fatigue, breaks, or performance degradation, ideal for high-volume manufacturing.',
          ),
        ],
      ),

      // WS09: Commissioning the Cell
      Worksheet(
        id: 'WS09',
        title: 'Commissioning the Cell',
        goal: 'Learn the systematic process for setting up and verifying an automated manufacturing cell',
        estimatedMinutes: 45,
        content: 'Commissioning is the systematic process of verifying that all components of an automated system are properly installed, configured, and working together as designed. This critical phase occurs before production begins and involves testing each subsystem individually, then testing integrated operations, and finally validating the complete system against performance specifications. Proper commissioning prevents costly production failures and ensures the system meets safety and performance requirements. This worksheet guides you through a structured commissioning procedure.',
        steps: [
          'Phase 1 - Individual Component Testing: Verify each sensor, actuator, and motor operates correctly in isolation before integrating with other components.',
          'Phase 2 - Subsystem Integration: Test coordinated operations like conveyor-sensor timing, gantry-plunger coordination, and robot arm sequencing.',
          'Phase 3 - System Validation: Run complete production cycles and verify throughput, quality, and safety systems meet specifications.',
        ],
        overToYou: [
          'Create a commissioning checklist listing every component that needs verification.',
          'Start with sensors - manually trigger each one and verify the system detects the input.',
          'Test each actuator individually - conveyor, reject solenoid, stepper motor, plunger, robot arm.',
          'Verify sensor-to-actuator coordination - do actions occur at the correct time based on sensor inputs?',
          'Run a complete production cycle and verify all functions execute correctly.',
          'Document any issues found and the corrections made - this becomes your commissioning report.',
        ],
        soWhat: 'Commissioning is where theory meets reality. A well-commissioned system starts production smoothly, while a poorly commissioned system suffers from frequent breakdowns, quality issues, and safety incidents. The systematic approach you learn here - test individually, then integrate, then validate - applies to commissioning everything from small machines to entire production facilities. Thorough commissioning documentation provides a baseline for troubleshooting and future modifications.',
        keyTakeaways: [
          'Commissioning systematically verifies that all system components and integrations work correctly.',
          'Test individual components first, then subsystems, then the complete integrated system.',
          'Documentation of commissioning results provides a baseline for future troubleshooting.',
          'Proper commissioning prevents costly production failures and ensures safety.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary goal of commissioning an automated system?',
            options: [
              'To paint and label equipment',
              'To systematically verify all components work correctly before production',
              'To train operators',
              'To clean the equipment',
            ],
            correctAnswerIndex: 1,
            explanation: 'Commissioning systematically verifies that all components are properly installed, configured, and working together as designed before starting production operations.',
          ),
          QuizQuestion(
            question: 'What is the recommended sequence for commissioning?',
            options: [
              'Test everything at once',
              'Individual components, then subsystems, then complete system',
              'Complete system first, then individual components',
              'Subsystems only',
            ],
            correctAnswerIndex: 1,
            explanation: 'The systematic approach tests individual components first to verify basic function, then subsystem integration, then complete system validation. This isolates problems efficiently.',
          ),
          QuizQuestion(
            question: 'Why is commissioning documentation important?',
            options: [
              'It is not important',
              'It provides a baseline for troubleshooting and documents system performance',
              'Only for compliance purposes',
              'To impress management',
            ],
            correctAnswerIndex: 1,
            explanation: 'Commissioning documentation records how the system should operate when properly configured, providing a baseline for troubleshooting and documenting initial performance specifications.',
          ),
          QuizQuestion(
            question: 'What should you do if you find a problem during commissioning?',
            options: [
              'Ignore it and start production anyway',
              'Document the issue, correct it, and retest before proceeding',
              'Only fix it if it seems serious',
              'Skip that component',
            ],
            correctAnswerIndex: 1,
            explanation: 'Any problem found during commissioning should be documented, corrected, and retested. Starting production with known issues leads to failures and potentially unsafe conditions.',
          ),
          QuizQuestion(
            question: 'What is tested during the subsystem integration phase?',
            options: [
              'Only individual sensors',
              'Coordinated operations between multiple components',
              'Only software',
              'Only mechanical components',
            ],
            correctAnswerIndex: 1,
            explanation: 'Subsystem integration testing verifies that multiple components work together correctly, such as conveyor-sensor timing or gantry-plunger coordination.',
          ),
        ],
      ),

      // WS10: Completing the Smart Factory
      Worksheet(
        id: 'WS10',
        title: 'Completing the Smart Factory',
        goal: 'Execute a complete end-to-end production cycle and analyze overall system performance',
        estimatedMinutes: 50,
        content: 'This capstone worksheet brings together all previous lessons to operate the complete smart factory system in a full production cycle. You will coordinate all subsystems - material handling, sensing, sorting, robotics, and quality control - to transform raw materials into finished products. This end-to-end operation demonstrates how individual components integrate into a functional manufacturing system. You will measure overall system performance using metrics like cycle time, throughput, First Pass Yield, and equipment utilization.',
        steps: [
          'Review the complete production sequence: material entry → sensing → sorting → pick-and-place → quality inspection → delivery or reject.',
          'Understand the control logic that coordinates all operations - how sensor inputs trigger actuator outputs at the right time.',
          'Study the system state machine - what states does the system transition through during a complete production cycle?',
        ],
        overToYou: [
          'Start the complete system in simulation mode and observe a full production cycle.',
          'Track one part from entry through all processing steps to final delivery.',
          'Measure the total cycle time for one part to complete the entire process.',
          'Calculate the theoretical maximum throughput based on cycle time.',
          'Run a production batch of 20 parts and record total good parts, defects, and cycle time.',
          'Calculate First Pass Yield (FPY) = good parts / total parts and Overall Equipment Effectiveness (OEE).',
        ],
        soWhat: 'Operating an integrated system is fundamentally different from operating individual components. Success requires understanding how components interact, how timing is coordinated, and how to diagnose problems that span multiple subsystems. The metrics you calculate - cycle time, throughput, FPY, OEE - are the language of manufacturing management. Being able to measure, analyze, and improve these metrics makes you valuable in any manufacturing environment.',
        keyTakeaways: [
          'Complete production cycles integrate all subsystems into a coordinated operation.',
          'Cycle time determines maximum throughput and is limited by the system bottleneck.',
          'First Pass Yield (FPY) measures quality by comparing good parts to total parts.',
          'Overall Equipment Effectiveness (OEE) combines availability, performance, and quality into one metric.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the complete production sequence in the smart factory?',
            options: [
              'Entry → exit',
              'Entry → sensing → sorting → pick-and-place → inspection → delivery/reject',
              'Sensing → sorting only',
              'Entry → delivery',
            ],
            correctAnswerIndex: 1,
            explanation: 'The complete sequence processes materials through entry, sensing, sorting, pick-and-place, quality inspection, and final delivery or rejection.',
          ),
          QuizQuestion(
            question: 'How is First Pass Yield (FPY) calculated?',
            options: [
              'Total parts / time',
              'Good parts / total parts',
              'Defects / good parts',
              'Cycle time / throughput',
            ],
            correctAnswerIndex: 1,
            explanation: 'FPY = good parts / total parts. It measures the percentage of parts that pass through the process without defects. For example, 18 good parts out of 20 total = 90% FPY.',
          ),
          QuizQuestion(
            question: 'What determines the maximum throughput of an integrated system?',
            options: [
              'The fastest component',
              'The average speed of all components',
              'The slowest component (bottleneck)',
              'The conveyor speed only',
            ],
            correctAnswerIndex: 2,
            explanation: 'Maximum throughput is limited by the bottleneck - the slowest operation in the system. The system can only produce as fast as its slowest component allows.',
          ),
          QuizQuestion(
            question: 'What three factors does Overall Equipment Effectiveness (OEE) combine?',
            options: [
              'Speed, quality, cost',
              'Availability, performance, quality',
              'Throughput, defects, downtime',
              'Sensors, actuators, controllers',
            ],
            correctAnswerIndex: 1,
            explanation: 'OEE = Availability x Performance x Quality. It measures how effectively equipment is being used by considering uptime, speed, and quality simultaneously.',
          ),
          QuizQuestion(
            question: 'Why is measuring cycle time important?',
            options: [
              'It is not important',
              'It determines maximum throughput and identifies opportunities for improvement',
              'Only for reporting to management',
              'To calculate energy costs',
            ],
            correctAnswerIndex: 1,
            explanation: 'Cycle time directly determines maximum throughput (throughput = 1/cycle time). Measuring it identifies bottlenecks and provides a baseline for improvement efforts.',
          ),
        ],
      ),

      // WS11: Defects & Reset Sequence
      Worksheet(
        id: 'WS11',
        title: 'Defects & Reset Sequence',
        goal: 'Master fault detection, safe shutdown procedures, and system recovery sequences',
        estimatedMinutes: 35,
        content: 'Manufacturing systems must handle faults gracefully to prevent damage and ensure safety. Fault handling involves detecting abnormal conditions, safely stopping operations, alerting operators, and providing a structured recovery sequence to return to normal production. This worksheet covers common fault types (sensor failures, jams, communication errors), emergency stop procedures, and reset sequences. Understanding fault handling is critical for maintaining high availability and preventing equipment damage or safety incidents.',
        steps: [
          'Learn to identify common fault types: sensor failures (stuck on/off), mechanical jams, communication timeouts, and sequence errors.',
          'Understand emergency stop (E-Stop) procedures - how to safely halt all motion and energy sources when a fault or safety issue occurs.',
          'Study reset sequences - the steps required to clear faults, verify safe conditions, and return to normal operation.',
        ],
        overToYou: [
          'Navigate to the Settings screen and locate the system reset controls.',
          'Intentionally create a fault condition (if simulation allows) and observe the system response.',
          'Activate the emergency stop and verify all motion ceases immediately.',
          'Follow the reset sequence to clear the fault: verify safety, reset counters, home axes, restart operation.',
          'Practice the reset procedure multiple times until it becomes second nature.',
          'Document the reset sequence steps as a procedure for operators.',
        ],
        soWhat: 'Fault handling separates amateur systems from professional systems. Equipment will fail - sensors will malfunction, parts will jam, and communication will drop. How the system responds determines whether you have minor downtime or catastrophic damage. Understanding emergency stop procedures is a safety requirement. Being able to quickly diagnose faults and execute recovery sequences minimizes production losses. The reset procedures you learn here apply to all industrial automation systems.',
        keyTakeaways: [
          'Fault detection identifies abnormal conditions before they cause damage or safety issues.',
          'Emergency stop immediately halts all motion and energy sources for safety.',
          'Reset sequences systematically verify safe conditions before resuming operation.',
          'Structured fault handling minimizes downtime and prevents equipment damage.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the purpose of an emergency stop (E-Stop)?',
            options: [
              'To pause production temporarily',
              'To immediately halt all motion and energy sources for safety',
              'To reset the system',
              'To adjust conveyor speed',
            ],
            correctAnswerIndex: 1,
            explanation: 'Emergency stop immediately halts all motion and cuts power to actuators to prevent injury or damage when a safety issue or fault occurs.',
          ),
          QuizQuestion(
            question: 'What should you verify before resetting a system after a fault?',
            options: [
              'Nothing - just press reset',
              'Safe conditions: no personnel in danger zones, fault cause identified and corrected',
              'Only that the conveyor is stopped',
              'Only that sensors are working',
            ],
            correctAnswerIndex: 1,
            explanation: 'Before resetting, verify that the fault cause has been identified and corrected, no personnel are in danger zones, and it is safe to resume operation.',
          ),
          QuizQuestion(
            question: 'What is a common cause of faults in automated systems?',
            options: [
              'Perfect operation',
              'Sensor failures, mechanical jams, or communication timeouts',
              'Running too slowly',
              'Having too many operators',
            ],
            correctAnswerIndex: 1,
            explanation: 'Common faults include sensor failures (stuck on/off), mechanical jams from material misalignment, and communication timeouts between controllers.',
          ),
          QuizQuestion(
            question: 'What is the typical reset sequence after clearing a fault?',
            options: [
              'Just press start',
              'Verify safety, reset counters, home axes to known positions, restart operation',
              'Reset and ignore the fault',
              'Replace all equipment',
            ],
            correctAnswerIndex: 1,
            explanation: 'A proper reset sequence verifies safety, resets counters and states, returns moving axes to home positions, and then resumes operation in a controlled manner.',
          ),
          QuizQuestion(
            question: 'Why is fault handling important in manufacturing?',
            options: [
              'It is not important - faults never occur',
              'It minimizes downtime, prevents damage, and ensures safety when faults occur',
              'Only for compliance',
              'To complicate the system',
            ],
            correctAnswerIndex: 1,
            explanation: 'Proper fault handling minimizes production downtime, prevents equipment damage from cascading failures, and ensures personnel safety during abnormal conditions.',
          ),
        ],
      ),

      // WS12: Vision System
      Worksheet(
        id: 'WS12',
        title: 'Vision System',
        goal: 'Understand vision-based inspection, image processing, and automated quality control',
        estimatedMinutes: 40,
        content: 'Machine vision systems use cameras and image processing algorithms to automate inspection tasks that would be difficult or impossible with traditional sensors. Vision systems can detect surface defects, verify assembly correctness, read codes, measure dimensions, and identify part orientation. This worksheet introduces fundamental vision concepts: image acquisition, preprocessing, feature extraction, and decision-making. Vision systems are increasingly important as quality standards tighten and product complexity increases.',
        steps: [
          'Learn image acquisition basics - lighting, camera resolution, and field of view must be optimized for the inspection task.',
          'Understand image preprocessing - techniques like filtering, thresholding, and edge detection enhance relevant features while removing noise.',
          'Study feature extraction and classification - how the system identifies defects, measures dimensions, or recognizes patterns.',
        ],
        overToYou: [
          'Navigate to the vision system display (if available in your smart factory app).',
          'Observe how the camera captures images of parts as they pass through the inspection zone.',
          'Identify what features the vision system is looking for (defects, dimensions, orientation).',
          'Note how lighting affects image quality - too bright washes out details, too dark obscures features.',
          'If simulation includes vision faults, observe how the system rejects parts that fail vision inspection.',
          'Consider what types of defects vision can detect that traditional sensors cannot.',
        ],
        soWhat: 'Vision systems represent the cutting edge of automated quality control. They can detect subtle defects that human inspectors might miss due to fatigue or inconsistency, and they do it at production speeds far exceeding manual inspection. Understanding vision systems opens career opportunities in automotive, electronics, pharmaceuticals, and food production where quality inspection is critical. The combination of vision hardware and machine learning algorithms is creating unprecedented inspection capabilities.',
        keyTakeaways: [
          'Vision systems automate inspection tasks using cameras and image processing algorithms.',
          'Proper lighting is critical for image quality and reliable defect detection.',
          'Image preprocessing enhances relevant features and removes noise for better analysis.',
          'Vision can detect defects and measure features that traditional sensors cannot.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary advantage of vision systems over traditional sensors for inspection?',
            options: [
              'Lower cost',
              'Ability to detect complex visual features, defects, and patterns',
              'Faster response time',
              'Simpler programming',
            ],
            correctAnswerIndex: 1,
            explanation: 'Vision systems can detect complex visual features like surface defects, incorrect assembly, and pattern recognition that would be impossible with simple proximity or presence sensors.',
          ),
          QuizQuestion(
            question: 'Why is lighting critical for vision system performance?',
            options: [
              'It is not important',
              'Proper lighting ensures consistent image quality and contrast for reliable feature detection',
              'Only for operator visibility',
              'To reduce camera cost',
            ],
            correctAnswerIndex: 1,
            explanation: 'Lighting dramatically affects image quality. Proper lighting provides consistent contrast and illumination, enabling reliable feature detection and reducing false rejects.',
          ),
          QuizQuestion(
            question: 'What is image preprocessing in vision systems?',
            options: [
              'Taking the picture',
              'Techniques like filtering and thresholding to enhance features and remove noise',
              'Storing images',
              'Displaying images',
            ],
            correctAnswerIndex: 1,
            explanation: 'Preprocessing applies techniques like noise filtering, contrast enhancement, and thresholding to enhance relevant features and suppress irrelevant information before analysis.',
          ),
          QuizQuestion(
            question: 'What types of defects can vision systems detect?',
            options: [
              'Only size defects',
              'Surface scratches, incorrect colors, missing components, dimensional errors',
              'Only weight defects',
              'Only temperature defects',
            ],
            correctAnswerIndex: 1,
            explanation: 'Vision systems can detect a wide range of visual defects including surface scratches, color variations, missing or incorrect components, and dimensional discrepancies.',
          ),
          QuizQuestion(
            question: 'How do vision systems compare to manual visual inspection?',
            options: [
              'Slower but more accurate',
              'Faster, more consistent, and do not suffer from fatigue',
              'Less accurate',
              'Only useful for simple inspections',
            ],
            correctAnswerIndex: 1,
            explanation: 'Vision systems inspect at production speeds, maintain consistent standards without fatigue, and can detect subtle defects that human inspectors might miss over time.',
          ),
        ],
      ),

      // WS13: RFID
      Worksheet(
        id: 'WS13',
        title: 'RFID',
        goal: 'Learn RFID technology for part tracking, identification, and traceability',
        estimatedMinutes: 35,
        content: 'Radio Frequency Identification (RFID) uses electromagnetic fields to automatically identify and track tags attached to objects. Unlike barcodes that require line-of-sight scanning, RFID tags can be read from a distance and through materials. This enables automated tracking of parts through production, inventory management, and product traceability. RFID is essential in industries requiring strict traceability like automotive, aerospace, and pharmaceuticals. This worksheet explores RFID technology, read/write operations, and integration with manufacturing systems.',
        steps: [
          'Understand RFID components - tags (passive or active), readers, and antennas. Passive tags are powered by the reader radio frequency field.',
          'Learn RFID data structure - tags store unique IDs and can contain additional data like part numbers, production dates, or quality status.',
          'Study RFID integration with manufacturing systems - how tag data is read, processed, and used to control production flow and maintain traceability.',
        ],
        overToYou: [
          'Navigate to the I/O screen or RFID display to view RFID reader status.',
          'Observe RFID tag reads as parts pass through the reader detection zone.',
          'Note what data is stored on each RFID tag (part ID, type, production timestamp).',
          'Track a specific RFID tag through the entire production process.',
          'Consider how RFID enables traceability - you can track which specific part was processed when and by which equipment.',
          'Compare RFID to barcode scanning - what are the advantages and disadvantages of each?',
        ],
        soWhat: 'RFID enables the "Internet of Things" in manufacturing by giving every part a digital identity that can be tracked automatically. This enables just-in-time manufacturing, prevents counterfeit parts, and provides complete traceability for quality investigations and recalls. Understanding RFID technology is valuable across many industries - retail inventory, supply chain logistics, access control, and toll collection all use RFID. The combination of RFID and Industry 4.0 is creating smart factories where every component is tracked in real-time.',
        keyTakeaways: [
          'RFID uses radio waves to automatically identify and track tagged objects without line-of-sight.',
          'RFID tags can store unique IDs and additional data like part numbers and production history.',
          'RFID enables automated tracking and traceability throughout the production process.',
          'RFID is more versatile than barcodes for tracking in harsh or obstructed environments.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary advantage of RFID over barcode scanning?',
            options: [
              'Lower cost',
              'No line-of-sight required and can read through materials',
              'Easier to print',
              'Larger data capacity',
            ],
            correctAnswerIndex: 1,
            explanation: 'RFID does not require line-of-sight and can read tags through materials, dirt, or paint. Barcodes require direct visual scanning and can be obscured by contamination.',
          ),
          QuizQuestion(
            question: 'How are passive RFID tags powered?',
            options: [
              'Battery',
              'Solar cells',
              'Energy from the reader radio frequency field',
              'Wired power connection',
            ],
            correctAnswerIndex: 2,
            explanation: 'Passive RFID tags have no internal power source. They are powered by electromagnetic energy from the RFID reader antenna when in range.',
          ),
          QuizQuestion(
            question: 'What type of data can be stored on an RFID tag?',
            options: [
              'Only a single number',
              'Unique ID, part numbers, production dates, quality status, and other custom data',
              'No data - RFID only detects presence',
              'Only color information',
            ],
            correctAnswerIndex: 1,
            explanation: 'RFID tags can store a variety of data including unique identifiers, part information, production history, quality status, and other custom fields depending on tag memory capacity.',
          ),
          QuizQuestion(
            question: 'Why is RFID important for product traceability?',
            options: [
              'It is not important for traceability',
              'It enables tracking of individual parts through production and identifies which equipment processed each part',
              'Only for inventory counting',
              'Only for access control',
            ],
            correctAnswerIndex: 1,
            explanation: 'RFID enables complete traceability by uniquely identifying each part and tracking it through production, recording which equipment, operators, and processes were involved.',
          ),
          QuizQuestion(
            question: 'In which industries is RFID traceability particularly critical?',
            options: [
              'Only retail',
              'Automotive, aerospace, pharmaceuticals where recalls require identifying affected parts',
              'Only warehousing',
              'RFID is not used in industry',
            ],
            correctAnswerIndex: 1,
            explanation: 'Industries like automotive, aerospace, and pharmaceuticals require strict traceability for safety and regulatory compliance. RFID enables tracking individual parts for recalls and quality investigations.',
          ),
        ],
      ),

      // WS14: Network & Communications
      Worksheet(
        id: 'WS14',
        title: 'Network & Communications',
        goal: 'Understand industrial networking, S7 protocol, and PLC communications',
        estimatedMinutes: 40,
        content: 'Modern manufacturing relies on networked communications between PLCs, HMIs, sensors, robots, and enterprise systems. Industrial networks differ from office IT networks in their real-time requirements, determinism, and harsh environment operation. This worksheet focuses on PLC networking, the S7 communication protocol used by Siemens PLCs, and the architecture of industrial communication systems. Understanding industrial networking is essential for integrating equipment from different manufacturers and implementing Industry 4.0 initiatives.',
        steps: [
          'Learn industrial network topologies - star, ring, and bus architectures and their reliability characteristics.',
          'Understand the S7 protocol - a Siemens protocol for PLC-to-PLC and PLC-to-HMI communication over Ethernet (S7-1200, S7-1500) or legacy networks.',
          'Study the OSI model as applied to industrial networks - physical layer (cables, connectors), data link (MAC addresses), network (IP addresses), and application (protocols like S7, Modbus).',
        ],
        overToYou: [
          'Navigate to the Settings screen and locate the network configuration section.',
          'Identify the PLC IP address and port used for S7 communication.',
          'Verify that the smart factory app is successfully communicating with the PLC (or simulator).',
          'If using simulation, examine the network connection status indicators.',
          'Test what happens if network communication is lost - does the system fault safely?',
          'Consider how multiple devices (HMI, SCADA, robots) could connect to the same PLC network.',
        ],
        soWhat: 'Industrial networking is the backbone of smart manufacturing. Without reliable communication, automated systems cannot coordinate actions, share data, or respond to changing conditions. The S7 protocol knowledge you gain here applies directly to programming and troubleshooting Siemens PLCs used worldwide in manufacturing. Understanding industrial Ethernet and protocols like S7, Modbus, and OPC-UA prepares you for Industry 4.0 implementations where machines, enterprise systems, and cloud services all communicate seamlessly.',
        keyTakeaways: [
          'Industrial networks connect PLCs, HMIs, sensors, robots, and enterprise systems.',
          'S7 protocol enables communication with Siemens PLCs over Ethernet or legacy networks.',
          'Industrial networks prioritize real-time performance and determinism over bandwidth.',
          'Understanding networking is essential for multi-device integration and Industry 4.0.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the S7 protocol used for?',
            options: [
              'Only for connecting sensors',
              'Communication between Siemens PLCs, HMIs, and SCADA systems',
              'Only for email',
              'Only for internet browsing',
            ],
            correctAnswerIndex: 1,
            explanation: 'S7 protocol enables communication between Siemens PLCs and other devices like HMIs, SCADA systems, and other PLCs to exchange data and control signals.',
          ),
          QuizQuestion(
            question: 'How do industrial networks differ from office IT networks?',
            options: [
              'They are exactly the same',
              'Industrial networks prioritize real-time performance and determinism',
              'Industrial networks are always wireless',
              'Industrial networks are slower',
            ],
            correctAnswerIndex: 1,
            explanation: 'Industrial networks require deterministic, real-time communication for control systems. Missing a deadline in industrial control can cause safety issues, unlike office IT where delays are tolerable.',
          ),
          QuizQuestion(
            question: 'What information is needed to connect to a PLC over S7 protocol?',
            options: [
              'Only the PLC brand',
              'IP address, port, rack and slot numbers',
              'Only the cable type',
              'No information needed',
            ],
            correctAnswerIndex: 1,
            explanation: 'S7 communication requires the PLC IP address, communication port (typically 102), and rack/slot numbers that identify the specific CPU module to communicate with.',
          ),
          QuizQuestion(
            question: 'Why is network reliability critical in manufacturing?',
            options: [
              'It is not critical',
              'Communication failures can halt production, cause safety issues, and result in defects',
              'Only for data logging',
              'Only for energy savings',
            ],
            correctAnswerIndex: 1,
            explanation: 'Network failures can stop production, prevent safety systems from responding, cause equipment coordination failures, and result in quality defects or damage.',
          ),
          QuizQuestion(
            question: 'What is a common industrial networking protocol besides S7?',
            options: [
              'HTTP',
              'Modbus and OPC-UA',
              'FTP',
              'SMTP',
            ],
            correctAnswerIndex: 1,
            explanation: 'Modbus and OPC-UA are widely used industrial protocols. Modbus is simple and widely supported, while OPC-UA provides secure, standardized communication for Industry 4.0.',
          ),
        ],
      ),

      // WS15: Data Logging
      Worksheet(
        id: 'WS15',
        title: 'Data Logging',
        goal: 'Master data collection techniques, logging strategies, and data storage for analysis',
        estimatedMinutes: 35,
        content: 'Data is the foundation of continuous improvement in manufacturing. Data logging systematically records process parameters, production events, and quality metrics over time. This historical data enables trend analysis, process optimization, and root cause investigation when problems occur. This worksheet covers logging strategies (what to log, how often), data storage formats (databases, CSV files, cloud storage), and best practices for ensuring data integrity. Effective data logging is the first step toward predictive maintenance and data-driven decision making.',
        steps: [
          'Identify what data to log - sensor states, production counts, cycle times, quality results, alarms, and operator actions are all valuable.',
          'Understand logging frequency trade-offs - high-frequency logging captures more detail but generates massive data volumes; low-frequency logging misses important events.',
          'Learn data storage options - local databases for real-time access, CSV files for analysis tools, cloud storage for long-term archival and enterprise access.',
        ],
        overToYou: [
          'Navigate to the Analytics or Data Logging screen in the smart factory app.',
          'Review what data is currently being logged (production counts, cycle times, sensor events).',
          'Run a production session and observe data being logged in real-time.',
          'Export logged data to CSV format and open it in a spreadsheet.',
          'Analyze the data - can you identify patterns, anomalies, or trends?',
          'Consider what additional data would be valuable to log for process improvement.',
        ],
        soWhat: 'Data logging transforms manufacturing from art to science. Without data, you are guessing about what works and what doesn not. With comprehensive data logging, you can prove which process changes improve performance, identify subtle degradation before failures occur, and provide evidence for quality audits. The data logging skills you learn here apply to predictive maintenance, statistical process control, and the Industrial Internet of Things (IIoT) where billions of data points are logged and analyzed continuously.',
        keyTakeaways: [
          'Data logging records process parameters, events, and metrics for analysis and improvement.',
          'Logging frequency must balance capturing important events with managing data volume.',
          'Multiple storage options exist - local databases, CSV files, cloud storage - each with trade-offs.',
          'Comprehensive data logging enables trend analysis, troubleshooting, and continuous improvement.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary purpose of data logging in manufacturing?',
            options: [
              'To use storage space',
              'To record process data for analysis, troubleshooting, and continuous improvement',
              'Only for regulatory compliance',
              'To slow down production',
            ],
            correctAnswerIndex: 1,
            explanation: 'Data logging records historical process data that enables trend analysis, troubleshooting problems, validating improvements, and driving continuous improvement initiatives.',
          ),
          QuizQuestion(
            question: 'What is the trade-off when setting data logging frequency?',
            options: [
              'There is no trade-off',
              'Higher frequency captures more detail but generates larger data volumes',
              'Frequency does not matter',
              'Lower frequency is always better',
            ],
            correctAnswerIndex: 1,
            explanation: 'High-frequency logging (e.g., every second) captures detailed events but generates massive data. Low-frequency logging (e.g., every hour) reduces data volume but may miss important events.',
          ),
          QuizQuestion(
            question: 'What types of data are valuable to log in manufacturing?',
            options: [
              'Only production counts',
              'Sensor states, counts, cycle times, quality results, alarms, and operator actions',
              'Only error messages',
              'Only time stamps',
            ],
            correctAnswerIndex: 1,
            explanation: 'Comprehensive logging includes sensor states, production metrics, quality data, alarms, operator actions, and timing information to provide complete process visibility.',
          ),
          QuizQuestion(
            question: 'Why is CSV format commonly used for data logging?',
            options: [
              'It is the only format available',
              'CSV files are simple, widely supported by analysis tools, and human-readable',
              'CSV is the fastest format',
              'CSV provides the best compression',
            ],
            correctAnswerIndex: 1,
            explanation: 'CSV (comma-separated values) is simple, can be opened in spreadsheets and analysis tools, and is human-readable, making it ideal for data exchange and analysis.',
          ),
          QuizQuestion(
            question: 'How does data logging enable predictive maintenance?',
            options: [
              'It does not help with maintenance',
              'Historical data reveals degradation trends that predict failures before they occur',
              'Only by recording failures after they happen',
              'By scheduling maintenance randomly',
            ],
            correctAnswerIndex: 1,
            explanation: 'By logging performance data over time, gradual degradation trends become visible (e.g., increasing cycle time, higher reject rates), enabling maintenance before catastrophic failure.',
          ),
        ],
      ),

      // WS16: Analytics
      Worksheet(
        id: 'WS16',
        title: 'Analytics',
        goal: 'Analyze production data to calculate KPIs, FPY, OEE, and drive performance improvements',
        estimatedMinutes: 45,
        content: 'Manufacturing analytics transforms raw production data into actionable insights. Key Performance Indicators (KPIs) measure how well the production system is performing against goals. First Pass Yield (FPY) measures quality - the percentage of parts that pass inspection without rework. Overall Equipment Effectiveness (OEE) combines availability, performance, and quality into a single metric that reveals true productivity. This worksheet teaches you to calculate these metrics, interpret them correctly, and use them to identify improvement opportunities.',
        steps: [
          'Learn to calculate First Pass Yield (FPY) = good parts / total parts. World-class manufacturing targets >99% FPY.',
          'Understand OEE calculation: OEE = Availability x Performance x Quality. Availability = uptime / total time. Performance = actual throughput / ideal throughput. Quality = good parts / total parts.',
          'Study how to identify improvement opportunities from analytics - low availability suggests maintenance issues, low performance suggests process bottlenecks, low quality suggests process control problems.',
        ],
        overToYou: [
          'Navigate to the Analytics screen and review current production metrics.',
          'Run a production batch and record: total parts, good parts, defects, total time, actual throughput.',
          'Calculate FPY = good parts / total parts (e.g., 18 good / 20 total = 90% FPY).',
          'Calculate Performance = actual throughput / ideal throughput.',
          'Calculate Quality = FPY.',
          'Calculate OEE = Availability x Performance x Quality. What does your OEE tell you about system performance?',
        ],
        soWhat: 'Analytics is the language of manufacturing management. When you can quantify performance using FPY, OEE, and other KPIs, you can have data-driven discussions about improvement priorities. An OEE of 60% means you are getting only 60% of the theoretical productivity from your equipment - that is a huge opportunity for improvement. Understanding how to calculate, interpret, and improve these metrics makes you valuable in any manufacturing role from operator to plant manager.',
        keyTakeaways: [
          'First Pass Yield (FPY) measures quality as the percentage of parts passing without defects.',
          'Overall Equipment Effectiveness (OEE) combines availability, performance, and quality.',
          'World-class manufacturing targets OEE >85% and FPY >99%.',
          'Analytics identifies specific improvement opportunities in availability, performance, or quality.',
        ],
        quiz: [
          QuizQuestion(
            question: 'How is First Pass Yield (FPY) calculated?',
            options: [
              'Defects / total parts',
              'Good parts / total parts',
              'Total parts / time',
              'Good parts / defects',
            ],
            correctAnswerIndex: 1,
            explanation: 'FPY = good parts / total parts. For example, if 18 parts out of 20 are good, FPY = 18/20 = 90%. It measures the percentage of parts that pass inspection without rework.',
          ),
          QuizQuestion(
            question: 'What three factors does OEE combine?',
            options: [
              'Speed, quality, cost',
              'Availability, performance, quality',
              'Time, defects, throughput',
              'Labor, materials, overhead',
            ],
            correctAnswerIndex: 1,
            explanation: 'OEE = Availability x Performance x Quality. It measures how effectively equipment is being used by considering uptime, speed relative to capability, and quality output.',
          ),
          QuizQuestion(
            question: 'What does low Availability in OEE indicate?',
            options: [
              'Quality problems',
              'Frequent downtime due to breakdowns, changeovers, or maintenance',
              'Slow cycle time',
              'High defect rate',
            ],
            correctAnswerIndex: 1,
            explanation: 'Low Availability means the equipment is not running as much as it should due to breakdowns, setup time, or planned maintenance. Focus on reducing downtime.',
          ),
          QuizQuestion(
            question: 'What does low Performance in OEE indicate?',
            options: [
              'Equipment is running slower than its designed capability',
              'Too many defects',
              'Too much downtime',
              'Perfect operation',
            ],
            correctAnswerIndex: 0,
            explanation: 'Low Performance means the equipment is running slower than its ideal speed. This could be due to bottlenecks, intentional slowdowns, or minor stops.',
          ),
          QuizQuestion(
            question: 'What is considered world-class OEE?',
            options: [
              '50%',
              '65%',
              '85% or higher',
              '100% is easily achievable',
            ],
            correctAnswerIndex: 2,
            explanation: 'World-class manufacturing targets OEE of 85% or higher. This is challenging because it requires high availability (>90%), high performance (>95%), and high quality (>99%).',
          ),
        ],
      ),

      // WS17: IO-Link
      Worksheet(
        id: 'WS17',
        title: 'IO-Link',
        goal: 'Understand IO-Link smart sensor technology for advanced diagnostics and configuration',
        estimatedMinutes: 35,
        content: 'IO-Link is a standardized point-to-point communication protocol that transforms simple sensors and actuators into smart devices. Unlike traditional sensors that provide only a binary on/off signal, IO-Link devices can transmit diagnostic data, configuration parameters, and detailed process values. This enables remote configuration, predictive maintenance through condition monitoring, and automatic device replacement. IO-Link is becoming the standard for smart sensors in Industry 4.0 implementations.',
        steps: [
          'Understand IO-Link communication - it uses standard 3-wire sensor cables to transmit both binary signals and serial data bidirectionally.',
          'Learn about IO-Link device features - remote configuration, diagnostics, event logging, and process data beyond simple on/off.',
          'Study IO-Link system architecture - sensors/actuators connect to IO-Link masters, which integrate with PLCs or industrial Ethernet networks.',
        ],
        overToYou: [
          'Navigate to the IO-Link section of the smart factory app (if available).',
          'Identify which sensors or actuators support IO-Link communication.',
          'Review diagnostic data provided by IO-Link devices - switching counts, temperature, signal strength.',
          'If simulation supports it, change sensor configuration parameters remotely via IO-Link.',
          'Compare traditional sensors (only on/off) to IO-Link sensors (diagnostic data, configuration, process values).',
          'Consider how IO-Link enables predictive maintenance by monitoring sensor health.',
        ],
        soWhat: 'IO-Link represents the future of industrial sensors and actuators. The ability to remotely configure devices, monitor their health, and receive detailed diagnostics revolutionizes maintenance and troubleshooting. Instead of waiting for a sensor to fail completely, IO-Link diagnostics can predict failures based on degrading signal quality or excessive switching cycles. Understanding IO-Link prepares you for Industry 4.0 factories where every device provides intelligent data, not just simple on/off signals.',
        keyTakeaways: [
          'IO-Link enables smart sensors and actuators with diagnostics, configuration, and detailed data.',
          'IO-Link uses standard 3-wire cables to transmit both binary signals and serial communication.',
          'Remote configuration and diagnostics reduce downtime and enable predictive maintenance.',
          'IO-Link is a key enabling technology for Industry 4.0 smart factories.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary advantage of IO-Link over traditional sensors?',
            options: [
              'Lower cost',
              'Provides diagnostics, configuration, and detailed data beyond simple on/off signals',
              'Faster response time',
              'Smaller size',
            ],
            correctAnswerIndex: 1,
            explanation: 'IO-Link sensors provide diagnostic data (signal quality, switching counts), remote configuration, and detailed process values, unlike traditional sensors that only provide on/off signals.',
          ),
          QuizQuestion(
            question: 'How does IO-Link enable predictive maintenance?',
            options: [
              'It does not help with maintenance',
              'Diagnostic data reveals sensor degradation before complete failure',
              'Only by recording when sensors fail',
              'By scheduling random maintenance',
            ],
            correctAnswerIndex: 1,
            explanation: 'IO-Link devices report diagnostic data like signal strength degradation, contamination, or excessive switching cycles, enabling maintenance before complete failure occurs.',
          ),
          QuizQuestion(
            question: 'What type of cable does IO-Link use?',
            options: [
              'Specialized expensive cables',
              'Standard 3-wire sensor cables',
              'Fiber optic only',
              'Wireless only',
            ],
            correctAnswerIndex: 1,
            explanation: 'IO-Link uses standard 3-wire sensor cables (power, ground, signal). The same cable carries both the switching signal and bidirectional communication data.',
          ),
          QuizQuestion(
            question: 'What is an IO-Link master?',
            options: [
              'A type of sensor',
              'A device that connects IO-Link sensors to PLCs or industrial networks',
              'A software program',
              'A cable type',
            ],
            correctAnswerIndex: 1,
            explanation: 'An IO-Link master is a device that connects multiple IO-Link sensors/actuators to a PLC or industrial Ethernet network, handling communication and data exchange.',
          ),
          QuizQuestion(
            question: 'Why is remote configuration valuable for IO-Link devices?',
            options: [
              'It is not valuable',
              'Allows changing sensor parameters without physical access, reducing downtime',
              'Only for initial setup',
              'Only for documentation',
            ],
            correctAnswerIndex: 1,
            explanation: 'Remote configuration allows changing sensor parameters (switching thresholds, timing, etc.) without physical access, enabling quick adjustments and reducing downtime for maintenance.',
          ),
        ],
      ),

      // WS18: Predictive Maintenance
      Worksheet(
        id: 'WS18',
        title: 'Predictive Maintenance',
        goal: 'Learn trend analysis and predictive techniques to prevent equipment failures',
        estimatedMinutes: 45,
        content: 'Predictive maintenance uses data analysis and condition monitoring to predict when equipment will fail, allowing maintenance before breakdown occurs. This contrasts with reactive maintenance (fix after failure) and preventive maintenance (scheduled service regardless of condition). Predictive maintenance analyzes trends in sensor data, performance metrics, and equipment diagnostics to identify degradation patterns. This workshop covers trend analysis techniques, leading indicators of failure, and how to implement predictive maintenance strategies using logged data.',
        steps: [
          'Learn common leading indicators of failure - increasing cycle time, rising temperature, degrading sensor signal quality, increasing vibration, or higher reject rates.',
          'Understand trend analysis - plotting metrics over time to identify gradual degradation that would be invisible looking at single data points.',
          'Study predictive maintenance techniques - vibration analysis, thermal imaging, oil analysis, and performance monitoring to detect problems early.',
        ],
        overToYou: [
          'Navigate to the Analytics screen and review historical trend data.',
          'Look for trends that might indicate degradation - is cycle time gradually increasing? Are reject rates climbing?',
          'Create a chart plotting cycle time or throughput over multiple production runs.',
          'Identify any upward or downward trends that suggest performance changes.',
          'Review sensor data for anomalies - are sensor switching counts increasing (suggesting misalignment)?',
          'Develop a predictive maintenance plan - what metrics will you monitor and what thresholds trigger maintenance?',
        ],
        soWhat: 'Predictive maintenance is the holy grail of maintenance strategy. It maximizes equipment availability by preventing unexpected failures while minimizing maintenance costs by avoiding unnecessary scheduled maintenance. Companies using predictive maintenance report 25-30% reduction in maintenance costs and 70-75% reduction in breakdowns. The skills you learn here - identifying leading indicators, analyzing trends, and predicting failures - are highly valuable and applicable to any equipment-intensive industry from manufacturing to transportation to energy production.',
        keyTakeaways: [
          'Predictive maintenance prevents failures by identifying degradation trends before breakdown occurs.',
          'Leading indicators like increasing cycle time or reject rates signal developing problems.',
          'Trend analysis reveals gradual degradation invisible in individual data points.',
          'Predictive maintenance reduces costs by preventing failures and avoiding unnecessary scheduled maintenance.',
        ],
        quiz: [
          QuizQuestion(
            question: 'What is the primary goal of predictive maintenance?',
            options: [
              'To fix equipment after it breaks',
              'To predict and prevent failures before they occur',
              'To perform maintenance on a fixed schedule',
              'To reduce maintenance entirely',
            ],
            correctAnswerIndex: 1,
            explanation: 'Predictive maintenance analyzes data to predict when failures will occur, allowing maintenance before breakdown happens, maximizing uptime while minimizing maintenance costs.',
          ),
          QuizQuestion(
            question: 'What is a leading indicator of potential equipment failure?',
            options: [
              'Equipment color change',
              'Gradually increasing cycle time, rising temperature, or degrading sensor quality',
              'Day of the week',
              'Operator shift',
            ],
            correctAnswerIndex: 1,
            explanation: 'Leading indicators like increasing cycle time, rising operating temperature, degrading sensor signals, or climbing reject rates suggest developing problems before catastrophic failure.',
          ),
          QuizQuestion(
            question: 'How does trend analysis help predict failures?',
            options: [
              'It does not help',
              'Plotting metrics over time reveals gradual degradation patterns',
              'It only works for electrical systems',
              'It predicts failures randomly',
            ],
            correctAnswerIndex: 1,
            explanation: 'Trend analysis plots metrics like cycle time, temperature, or reject rate over time, revealing gradual degradation that would be invisible looking at individual data points.',
          ),
          QuizQuestion(
            question: 'How does predictive maintenance compare to preventive maintenance?',
            options: [
              'They are the same',
              'Predictive performs maintenance based on condition, preventive on schedule',
              'Preventive is always better',
              'Predictive is more expensive',
            ],
            correctAnswerIndex: 1,
            explanation: 'Preventive maintenance services equipment on a fixed schedule regardless of condition. Predictive maintenance performs maintenance only when data indicates it is needed, reducing costs.',
          ),
          QuizQuestion(
            question: 'What data sources enable predictive maintenance?',
            options: [
              'Only visual inspection',
              'Sensor data, performance metrics, diagnostics, vibration, temperature, and oil analysis',
              'Only maintenance schedules',
              'Only operator opinions',
            ],
            correctAnswerIndex: 1,
            explanation: 'Predictive maintenance uses multiple data sources - sensor readings, performance metrics, vibration analysis, thermal imaging, oil analysis - to detect degradation from multiple perspectives.',
          ),
        ],
      ),
    ];
  }
}
