import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Details')),
      body: Center(
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1),
                  FlSpot(1, 3),
                  FlSpot(2, 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
