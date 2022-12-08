import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/cards/custom_card.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/providers/weight_service_provider.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/weight_service.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends ConsumerWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Stats',
      ),
      body: _buildBody(ref),
    );
  }

  Widget _buildBody(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomCard(
            content: _buildDefaultLineChart(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLineChart(WidgetRef ref) {
    final AuthBase auth = ref.read(authProvider);
    final WeightService weightService = ref.read(weightServiceProvider);

    return StreamBuilder<List<Weight>>(
      stream: weightService.getWeightsThisMonth(auth.currentUser!.uid),
      builder: ((context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Text('No connection');
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('No data');
        }

        final chartData = snapshot.data!.map((weight) {
          return _ChartData(
              weight.time.toDate(), double.parse('${weight.value}'));
        }).toList();

        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          title: ChartTitle(
            text: 'Weight last month',
            textStyle: const TextStyle(
              fontWeight: FontStyles.fwTitle,
            ),
            alignment: ChartAlignment.near,
          ),
          primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 5,
            majorGridLines: const MajorGridLines(width: 0),
          ),
          series: _getDefaultLineSeries(chartData),
          tooltipBehavior: TooltipBehavior(enable: true),
        );
      }),
    );
  }

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries(
      List<_ChartData> data) {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
        animationDuration: 2500,
        dataSource: data,
        xValueMapper: (_ChartData weight, _) => weight.x.day,
        xAxisName: 'Day of month',
        yValueMapper: (_ChartData weight, _) => weight.y,
        yAxisName: 'Weight',
        width: 2,
        color: Palette.accent[400],
        markerSettings: const MarkerSettings(
          height: 5,
          width: 5,
          isVisible: true,
        ),
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
