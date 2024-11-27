import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String input = "";
  String result = "0";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
      } else if (value == "=") {
        try {
          result = _evaluate(input).toString();
        } catch (e) {
          result = "Error";
        }
      } else {
        input += value;
      }
    });
  }

  double _evaluate(String expression) {
    // Basic parsing for calculations
    final parser = RegExp(r'(\d+|\+|\-|\*|\/)');
    final matches = parser.allMatches(expression).map((m) => m.group(0)!).toList();

    List<String> operators = [];
    List<double> operands = [];

    for (var token in matches) {
      if (RegExp(r'\d+').hasMatch(token)) {
        operands.add(double.parse(token));
      } else {
        operators.add(token);
      }
    }

    // Perform calculations (basic left-to-right evaluation)
    double result = operands.first;
    for (int i = 0; i < operators.length; i++) {
      switch (operators[i]) {
        case "+":
          result += operands[i + 1];
          break;
        case "-":
          result -= operands[i + 1];
          break;
        case "*":
          result *= operands[i + 1];
          break;
        case "/":
          result /= operands[i + 1];
          break;
      }
    }
    return result;
  }

  Widget buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    input,
                    style: const TextStyle(fontSize: 30.0, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: ["7", "8", "9", "/"].map(buildButton).toList()),
              Row(children: ["4", "5", "6", "*"].map(buildButton).toList()),
              Row(children: ["1", "2", "3", "-"].map(buildButton).toList()),
              Row(children: ["C", "0", "=", "+"].map(buildButton).toList()),
            ],
          ),
        ],
      ),
    );
  }
}
