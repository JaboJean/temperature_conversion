import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() => _TemperatureConverterScreenState();
}

class ConversionRecord {
  final String type;
  final double input;
  final double result;

  ConversionRecord({
    required this.type,
    required this.input,
    required this.result,
  });

  @override
  String toString() {
    return '$type: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}';
  }
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final TextEditingController _temperatureController = TextEditingController();
  String _conversionType = 'F to C'; // Default selection
  double? _result;
  List<ConversionRecord> _history = [];

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    final String inputText = _temperatureController.text.trim();

    if (inputText.isEmpty) {
      _showErrorDialog('Please enter a temperature value');
      return;
    }

    final double? inputTemp = double.tryParse(inputText);
    if (inputTemp == null) {
      _showErrorDialog('Please enter a valid number');
      return;
    }

    double result;
    if (_conversionType == 'F to C') {
      // °C = (°F - 32) x 5/9
      result = (inputTemp - 32) * 5 / 9;
    } else {
      // °F = °C x 9/5 + 32
      result = inputTemp * 9 / 5 + 32;
    }

    setState(() {
      _result = result;
      _history.insert(0, ConversionRecord(
        type: _conversionType,
        input: inputTemp,
        result: result,
      ));
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout();
          } else {
            return _buildLandscapeLayout();
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildConverterCard(),
          const SizedBox(height: 20),
          _buildHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: _buildConverterCard(),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _buildHistoryCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildConverterCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Temperature Converter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Conversion Type Selection
            const Text(
              'Conversion Type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('°F to °C'),
                    value: 'F to C',
                    groupValue: _conversionType,
                    onChanged: (String? value) {
                      setState(() {
                        _conversionType = value!;
                        _result = null; // Clear previous result
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('°C to °F'),
                    value: 'C to F',
                    groupValue: _conversionType,
                    onChanged: (String? value) {
                      setState(() {
                        _conversionType = value!;
                        _result = null; // Clear previous result
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Temperature Input
            TextField(
              controller: _temperatureController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter Temperature',
                hintText: _conversionType == 'F to C' ? 'Temperature in °F' : 'Temperature in °C',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.thermostat),
              ),
            ),

            const SizedBox(height: 20),

            // Convert Button
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // Result Display
            if (_result != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Result:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_result!.toStringAsFixed(2)}${_conversionType == 'F to C' ? '°C' : '°F'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_history.isNotEmpty)
                  TextButton(
                    onPressed: _clearHistory,
                    child: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (_history.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No conversions yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final record = _history[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        record.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}