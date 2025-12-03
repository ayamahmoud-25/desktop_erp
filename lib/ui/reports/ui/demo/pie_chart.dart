import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/agent_data_model.dart';

class PieChartSample extends StatelessWidget {
  final List<AgentData> agents;

  PieChartSample({required this.agents});

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,// مسافة صغيرة بين القطع
        centerSpaceRadius: 0, // فراغ في النص (عشان يبقى Doughnut Chart)
        startDegreeOffset: 0, // تقدري تخليه مثلاً 180 علشان يبقى نص دايرة
        sections: agents.asMap().entries.map((entry) {
          int index = entry.key;
          AgentData agent = entry.value;

          return PieChartSectionData(
            color: colors[index % colors.length], // لون مختلف لكل بنك
            value: agent.endDebit,
            title: agent.name, // يظهر الكود أو أي نص
            radius: 150, // حجم القطاع
            titleStyle: TextStyle(
              fontSize: 5,
              fontWeight: FontWeight.bold,
              color: Colors.black,

            ),
            borderSide: BorderSide(color: Colors.black, width: 1), // إطار
            titlePositionPercentageOffset:1.5, // 👈 يتحكم في مكان النص

          );
        }).toList(),
      ),
    );
  }
}
