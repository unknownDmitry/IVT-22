import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const InputScreen());
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _massController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  bool _consent = false;
  String? _errorMass;
  String? _errorRadius;

  bool get _isValid {
    final mass = double.tryParse(_massController.text.replaceAll(',', '.'));
    final radius = double.tryParse(_radiusController.text.replaceAll(',', '.'));
    return _consent && mass != null && mass > 0 && radius != null && radius > 0;
  }

  void _validate() {
    final mass = double.tryParse(_massController.text.replaceAll(',', '.'));
    final radius = double.tryParse(_radiusController.text.replaceAll(',', '.'));
    setState(() {
      _errorMass = (mass == null || mass <= 0) ? 'Введите массу (>0)' : null;
      _errorRadius = (radius == null || radius <= 0)
          ? 'Введите радиус (>0)'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Савин Дмитрий Николаевич',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _massController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Масса (кг)',
                errorText: _errorMass,
              ),
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Радиус (м)',
                errorText: _errorRadius,
              ),
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Согласен на обработку данных'),
              value: _consent,
              onChanged: (v) => setState(() => _consent = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isValid
                  ? () {
                      final m = double.parse(
                        _massController.text.replaceAll(',', '.'),
                      );
                      final r = double.parse(
                        _radiusController.text.replaceAll(',', '.'),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(mass: m, radius: r),
                        ),
                      );
                    }
                  : null,
              child: const Text('Рассчитать'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double mass;
  final double radius;
  const ResultScreen({super.key, required this.mass, required this.radius});

  @override
  Widget build(BuildContext context) {
    // g = G * M / R^2, где G = 6.67430e-11 (Н·м^2/кг^2)
    const double G = 6.67430e-11;
    final double g = G * mass / (radius * radius);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Савин Дмитрий Николаевич',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Формула: g = G · M / R²',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text('G = 6.67430×10⁻¹¹ Н·м²/кг²'),
            Text('M (масса) = ${mass.toStringAsExponential(6)} кг'),
            Text('R (радиус) = ${radius.toStringAsExponential(6)} м'),
            const Divider(height: 24),
            Text(
              'g = ${g.toStringAsExponential(6)} м/с²',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
