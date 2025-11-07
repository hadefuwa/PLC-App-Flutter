class Product {
  final String id;
  final String name;
  final String description;
  final String url;
  final String icon;
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
    required this.imagePath,
  });

  static List<Product> getProducts() {
    return [
      Product(
        id: 'SF-CONVEYOR',
        name: 'Conveyor Systems',
        description: 'Simulate real-world manufacturing scenarios with robust conveyor systems. Learn how conveyor belts are used to transport materials efficiently in industrial settings.',
        url: 'https://www.matrixtsl.com/smartfactory/',
        icon: '🏭',
        imagePath: 'assets/IM0004.jpeg',
      ),
      Product(
        id: 'SF-SENSORS',
        name: 'Sensing Systems',
        description: 'Experience advanced sensing technology including optical, proximity, and colour sensors. Program sensors to sort coloured discs based on specific attributes, mirroring modern quality control systems.',
        url: 'https://www.matrixtsl.com/smartfactory/',
        icon: '📡',
        imagePath: 'assets/IM6930.jpeg',
      ),
      Product(
        id: 'SF-PNEUMATIC',
        name: 'Pneumatic Pick and Place',
        description: 'Utilize pneumatic actuators and vacuum grippers to automate material handling. Understand the role of pneumatic systems in automating assembly lines and manufacturing processes.',
        url: 'https://www.matrixtsl.com/smartfactory/',
        icon: '🤖',
        imagePath: 'assets/IM3490.jpeg',
      ),
      Product(
        id: 'SF-MOTORS',
        name: 'DC Motor & Stepper Motor Drivers',
        description: 'Control and power various motors to drive conveyor belts and sorting gantries. Learn about motor control techniques crucial for precision and efficiency in industrial automation.',
        url: 'https://www.matrixtsl.com/smartfactory/',
        icon: '⚙️',
        imagePath: 'assets/IM0004.jpeg',
      ),
    ];
  }
}

