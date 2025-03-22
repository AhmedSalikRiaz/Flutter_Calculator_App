// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PortraitLayout extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onButtonPressed;

  const PortraitLayout({
    super.key,
    required this.controller,
    required this.onButtonPressed,
  });

  @override
  _PortraitLayoutState createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
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

  static const List<String> _buttons = [
    "C",
    "( )",
    "%",
    "÷",
    "7",
    "8",
    "9",
    "×",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
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

    // ✅ Adjust padding and spacing
    double horizontalPadding = screenWidth * 0.06;
    double spacing = 8;
    double childAspectRatio = 1;

    if (screenHeight < 826) {
      horizontalPadding = screenWidth * 0.1;
      childAspectRatio = 1.1;
    }

    if (screenHeight > 1279) {
      horizontalPadding = screenWidth * 0.09;
      spacing = 30;
      childAspectRatio = 1.05;
    }

    return Column(
      children: [
        // ✅ Expression Display (TextField with Auto-Focus)
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding + 15,
              vertical: screenHeight * 0.03, // ✅ Adjusted padding
            ),
            alignment: Alignment.bottomRight,
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller, // ✅ Uses controller from main
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                color: Colors.green,
              ),
              cursorColor: Colors.green,
              showCursor: true,
              readOnly: true, // ✅ No keyboard popup
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
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            bottom: screenHeight * 0.02, // ✅ Bottom padding only
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Left Section (🕒, 📏, 𝛴)
              Row(
                children:
                    ["🕒", "📏", "𝛴"].map((button) {
                      return Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.06),
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Divider(color: Colors.grey[800], thickness: 1.5),
        ),

        // ✅ Buttons Grid with Responsive Padding
        Expanded(
          flex: 2,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: 8,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: _buttons.length,
                itemBuilder: (context, index) {
                  final button = _buttons[index];
                  return _buildButton(button, screenWidth, screenHeight);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Extra Buttons (Clock, Measure, Toggle, Backspace)
  Widget _buildExtraButton(
    String label,
    double screenWidth,
    double screenHeight,
  ) {
    double buttonSize = screenWidth * 0.08; // ✅ Smaller than main buttons

    return InkWell(
      onTap: () => widget.onButtonPressed(label),
      borderRadius: BorderRadius.circular(buttonSize),
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
          style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white70),
        ),
      ),
    );
  }

  // ✅ Main Calculator Buttons
  Widget _buildButton(String label, double screenWidth, double screenHeight) {
    double buttonSize = screenWidth * 0.22;
    if (screenHeight < 1500) {
      buttonSize = screenWidth * 0.18;
    }

    double fontSize = screenWidth * 0.08;
    if (screenHeight < 600) {
      fontSize = screenWidth * 0.07;
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: _getButtonColor(label),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () => widget.onButtonPressed(label),
          borderRadius: BorderRadius.circular(buttonSize),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Container(
            width: buttonSize,
            height: buttonSize,
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

  // ✅ Button Colors
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
