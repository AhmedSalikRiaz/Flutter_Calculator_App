import 'package:flutter/material.dart';

class LandscapeLayout extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onButtonPressed;

  const LandscapeLayout({
    super.key,
    required this.controller,
    required this.onButtonPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LandscapeLayoutState createState() => _LandscapeLayoutState();
}

class _LandscapeLayoutState extends State<LandscapeLayout> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus(); // ✅ Auto-focus cursor on launch
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // ✅ Clean up FocusNode
    super.dispose();
  }

  static const List<String> _allButtons = [
    "↔",
    "Rad",
    "√",
    "C",
    "( )",
    "%",
    "÷",
    "sin",
    "cos",
    "tan",
    "7",
    "8",
    "9",
    "×",
    "ln",
    "log",
    "1/x",
    "4",
    "5",
    "6",
    "-",
    "eˣ",
    "x²",
    "xʸ",
    "1",
    "2",
    "3",
    "+",
    "|x|",
    "π",
    "e",
    "+/-",
    "0",
    ".",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // ✅ Adjust Padding & Spacing
    double padding = screenWidth * 0.015;
    double spacing = screenWidth * 0.008;

    // ✅ Responsive button sizing
    double ratio = 3.35;
    if (screenWidth > 1279) ratio = 2.15;
    if (screenWidth < 826) ratio = 2.9;

    return Column(
      children: [
        // ✅ Expression Display (TextField with Auto-Focus)
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: padding + 15,
              vertical: screenHeight * 0.03,
            ),
            alignment: Alignment.bottomRight,
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller, // ✅ Uses controller from main
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: screenHeight * 0.075,
                color: Colors.green,
              ),
              cursorColor: Colors.green,
              showCursor: true,
              readOnly: true, // ✅ Prevents keyboard from opening
              enableInteractiveSelection: true, // ✅ Allows cursor movement
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),

        // ✅ Extra Buttons Row (Left & Right Sections)
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.045,
            right: screenWidth * 0.045,
            bottom: screenHeight * 0.007, // ✅ Bottom padding only
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Left Section (🕒, 📏, 𝛴)
              Row(
                children:
                    ["🕒", "📏", "𝛴"].map((button) {
                      return Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.105),
                        child: _buildExtraButton(
                          button,
                          screenWidth,
                          screenHeight,
                        ),
                      );
                    }).toList(),
              ),

              // ✅ Right Section (⌫ Backspace)
              _buildExtraButton("⌫", screenWidth, screenHeight),
            ],
          ),
        ),

        // ✅ Horizontal Line (Divider)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Divider(color: Colors.grey[800], thickness: 1.5),
        ),

        // ✅ Buttons Grid with Improved Spacing
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: spacing * 6,
                mainAxisSpacing: spacing,
                childAspectRatio: ratio,
              ),
              itemCount: _allButtons.length,
              itemBuilder: (context, index) {
                final button = _allButtons[index];
                return _buildButton(button, screenWidth, screenHeight);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Extra Buttons (Clock, Measure, Summation, Backspace)
  Widget _buildExtraButton(
    String label,
    double screenWidth,
    double screenHeight,
  ) {
    double buttonSize = screenWidth * 0.04;

    return InkWell(
      onTap: () => widget.onButtonPressed(label),
      borderRadius: BorderRadius.circular(100),
      splashColor: Colors.white24,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.white70),
        ),
      ),
    );
  }

  // ✅ Smaller Buttons for Better Fit
  Widget _buildButton(String label, double screenWidth, double screenHeight) {
    double buttonWidth = screenHeight * 0.07;
    double buttonHeight = screenHeight * 0.04;
    double fontSize = screenHeight * 0.045;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: _getButtonColor(label),
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          onTap: () => widget.onButtonPressed(label),
          borderRadius: BorderRadius.circular(50),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: _getButtonTextColor(label),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Button Colors (Same as Portrait Mode)
  Color _getButtonColor(String label) {
    if (label == "=") return const Color.fromARGB(255, 48, 110, 50);
    if (["+", "-", "×", "÷", "%", "( )", "C"].contains(label)) {
      return Colors.grey[800]!;
    }
    return Colors.grey[900]!;
  }

  Color _getButtonTextColor(String label) {
    if (["+", "-", "×", "÷", "%", "( )"].contains(label)) return Colors.green;
    if (label == "C") return Colors.redAccent;
    return Colors.white;
  }
}
