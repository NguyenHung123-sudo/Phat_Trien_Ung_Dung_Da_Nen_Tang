import 'package:flutter/material.dart';

class Part2Responsive extends StatelessWidget {
  static const colorCodes = (
    body: Color(0xFFF8E287), // Sweet Corn
    navigation: Color(0xFFC5ECCE), // Padua
    pane: Color(0xFFEEEE2B), // Chamois (Corrected hex to 6 digits + alpha: 0xFFEEEE2B is 8, 0xFFEEE2BC is what screenshot might mean)
  );

  static const _style = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);
  static const body = Center(child: Text('Body', style: _style));
  static const navigation = Center(child: Text('Navigation', style: _style));
  static const panes = Center(child: Text('Pane', style: _style));

  const Part2Responsive({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(() {
          if (screenWidth < 600) return 'Responsive UI - Phone';
          if (screenWidth < 840) return 'Responsive UI - Tablet';
          if (screenWidth < 1200) return 'Responsive UI - Landscape';
          return 'Responsive UI - Large Desktop';
        }()),
      ),
      body: () {
        if (screenWidth < 600) return buildCompactScreen();
        if (screenWidth < 840) return buildMediumScreen();
        if (screenWidth < 1200) return buildExpandedScreen();
        return buildLargeScreen();
      }(),
    );
  }

  Widget buildCompactScreen() {
    return Column(
      children: [
        Expanded(child: Container(color: colorCodes.body, child: body)),
        Container(height: 80, color: colorCodes.navigation, child: navigation),
      ],
    );
  }

  Widget buildMediumScreen() {
    return Row(
      children: [
        Container(width: 80, color: colorCodes.navigation, child: navigation),
        Expanded(child: Container(color: colorCodes.body, child: body)),
      ],
    );
  }

  Widget buildExpandedScreen() {
    return Row(
      children: [
        Container(width: 80, color: colorCodes.navigation, child: navigation),
        Container(width: 360, color: colorCodes.body, child: body),
        Expanded(child: Container(color: colorCodes.pane, child: panes)),
      ],
    );
  }

  Widget buildLargeScreen() {
    return Row(
      children: [
        Container(width: 360, color: colorCodes.navigation, child: navigation),
        Container(width: 360, color: colorCodes.body, child: body),
        Expanded(child: Container(color: colorCodes.pane, child: panes)),
      ],
    );
  }
}
