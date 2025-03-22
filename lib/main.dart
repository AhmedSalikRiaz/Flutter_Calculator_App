import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'portrait_layout.dart';
import 'landscape_layout.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller =
      TextEditingController(); // ✅ Added Controller
  String _expression = '';

  @override
  void dispose() {
    _controller.dispose(); // ✅ Clean up controller when widget is destroyed
    super.dispose();
  }

  void _onButtonPressed(String value) {
    // ✅ Ignore scientific buttons and extra buttons (🕒, 📏)
    if ([
      "🕒",
      "📏",
      "↔",
      "Rad",
      "√",
      "sin",
      "cos",
      "tan",
      "ln",
      "log",
      "1/x",
      "eˣ",
      "x²",
      "xʸ",
      "|x|",
      "π",
      "e",
    ].contains(value)) {
      return; // Do nothing
    }

    if (value == "𝛴") {
      _toggleOrientation();
      return;
    }

    setState(() {
      if (value == "C") {
        _expression = ''; // ✅ Clear expression
        _controller.clear();
      } else if (value == "⌫") {
        // ✅ Handle backspace (delete last character or at cursor position)
        if (_expression.isNotEmpty) {
          final text = _controller.text;
          final cursorPosition = _controller.selection.baseOffset;

          if (cursorPosition == -1 || cursorPosition == text.length) {
            _expression = text.substring(0, text.length - 1);
          } else if (cursorPosition > 0) {
            _expression =
                text.substring(0, cursorPosition - 1) +
                text.substring(cursorPosition);
          }

          _controller.text = _expression;

          // ✅ Move cursor correctly after deletion
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition - 1),
          );
        }
      } else if (value == "=") {
        try {
          // ✅ Evaluate the expression
          Parser parser = Parser();
          Expression exp = parser.parse(
            _expression
                .replaceAll('×', '*')
                .replaceAll('÷', '/')
                .replaceAll('%', '/100'), // ✅ Convert % to division by 100
          );
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          // ✅ Format the result properly
          _expression =
              eval.toString().endsWith(".0")
                  ? eval
                      .toInt()
                      .toString() // Remove decimal if whole number
                  : eval.toString();

          _controller.text = _expression;
        } catch (e) {
          _expression = "Error"; // ✅ Handle invalid input
          _controller.text = "Error";
        }
      } else if (value == "+/-") {
        // ✅ Toggle between positive and negative
        if (_expression.isNotEmpty) {
          if (_expression.startsWith("-")) {
            _expression = _expression.substring(1);
          } else {
            _expression = "-$_expression";
          }
          _controller.text = _expression;
        }
      } else if (value == "( )") {
        // ✅ Auto-add parentheses
        if (_expression.isEmpty || _expression.endsWith("(")) {
          _expression += "(";
        } else {
          int openParens = _expression.split("(").length - 1;
          int closeParens = _expression.split(")").length - 1;

          if (openParens > closeParens) {
            _expression += ")"; // ✅ Close parenthesis if needed
          } else {
            _expression += "("; // ✅ Start new parenthesis
          }
        }
        _controller.text = _expression;
      } else {
        // ✅ Insert at cursor position
        final text = _controller.text;
        final cursorPosition = _controller.selection.baseOffset;

        if (cursorPosition == -1 || cursorPosition >= text.length) {
          _expression += value;
          _controller.text = _expression;
        } else {
          final newText =
              text.substring(0, cursorPosition) +
              value +
              text.substring(cursorPosition);
          _expression = newText;
          _controller.text = newText;

          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition + value.length),
          );
        }
      }
    });
  }

  void _toggleOrientation() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // ✅ Switch to Landscape Mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) {
        SystemChrome.setPreferredOrientations(
          [],
        ); // ✅ Allow manual rotation again
      });
    } else {
      // ✅ Switch to Portrait Mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then((_) {
        SystemChrome.setPreferredOrientations(
          [],
        ); // ✅ Allow manual rotation again
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          isLandscape
              ? LandscapeLayout(
                controller: _controller, // ✅ Pass controller to landscape
                onButtonPressed: _onButtonPressed,
              )
              : PortraitLayout(
                controller: _controller, // ✅ Pass controller to portrait
                onButtonPressed: _onButtonPressed,
              ),
    );
  }
}
