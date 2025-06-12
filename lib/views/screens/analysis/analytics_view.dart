import 'package:flutter/material.dart';
import 'package:women_health/core/models/period_data.dart';
import 'package:women_health/core/services/period_services.dart'
    show PeriodService;

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final PeriodService _periodService = PeriodService();
  List<PeriodData> _periods = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final periods = await _periodService.getPeriods();
    setState(() {
      _periods = periods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: _periods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No data available yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start logging your periods to see analytics',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Stats
                  _buildOverviewSection(),
                  SizedBox(height: 24),

                  // Cycle History
                  _buildCycleHistorySection(),
                  SizedBox(height: 24),

                  // Predictions
                  _buildPredictionsSection(),
                  SizedBox(height: 24),

                  // Insights
                  _buildInsightsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewSection() {
    final avgCycleLength =
        _periods.map((p) => p.cycleLength).reduce((a, b) => a + b) /
            _periods.length;
    final avgPeriodLength = _periods
            .map((p) => p.endDate.difference(p.startDate).inDays + 1)
            .reduce((a, b) => a + b) /
        _periods.length;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Average Cycle',
                    '${avgCycleLength.round()} days',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Average Period',
                    '${avgPeriodLength.round()} days',
                    Colors.pink,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Cycles',
                    '${_periods.length}',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Tracking Since',
                    _periods.isNotEmpty
                        ? '${_periods.first.startDate.month}/${_periods.first.startDate.year}'
                        : 'N/A',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildCycleHistorySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cycle History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ..._periods.reversed
                .take(5)
                .map((period) => _buildCycleHistoryItem(period)),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleHistoryItem(PeriodData period) {
    final periodLength = period.endDate.difference(period.startDate).inDays + 1;
    final startDate = '${period.startDate.day}/${period.startDate.month}';
    final endDate = '${period.endDate.day}/${period.endDate.month}';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$startDate - $endDate',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$periodLength days period, ${period.cycleLength} days cycle',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Visual representation
          Row(
            children: List.generate(period.cycleLength, (index) {
              Color color = Colors.grey.shade300;
              if (index < periodLength) {
                color = Colors.pink.shade400;
              }
              return Container(
                width: 8,
                height: 20,
                margin: EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsSection() {
    final predictions = _periodService.predictNextPeriods(_periods, 3);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predictions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...predictions.asMap().entries.map((entry) {
              final index = entry.key;
              final date = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Next Period #${index + 1}'),
                subtitle: Text('${date.day}/${date.month}/${date.year}'),
                trailing: Text(
                  '${date.difference(DateTime.now()).inDays} days',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInsightItem(
              Icons.trending_up,
              'Cycle Regularity',
              _getCycleRegularityText(),
              Colors.blue,
            ),
            _buildInsightItem(
              Icons.calendar_today,
              'Most Common Cycle Length',
              _getMostCommonCycleLength(),
              Colors.green,
            ),
            _buildInsightItem(
              Icons.access_time,
              'Average Period Duration',
              _getAveragePeriodDuration(),
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCycleRegularityText() {
    if (_periods.length < 2) return 'Need more data';

    final cycleLengths = _periods.map((p) => p.cycleLength).toList();
    final maxDiff = cycleLengths.reduce((a, b) => a > b ? a : b) -
        cycleLengths.reduce((a, b) => a < b ? a : b);

    if (maxDiff <= 3) {
      return 'Very regular cycles';
    } else if (maxDiff <= 7) {
      return 'Fairly regular cycles';
    } else {
      return 'Irregular cycles - consider consulting a doctor';
    }
  }

  String _getMostCommonCycleLength() {
    if (_periods.isEmpty) return 'No data';

    final cycleLengths = _periods.map((p) => p.cycleLength).toList();
    final counts = <int, int>{};

    for (var length in cycleLengths) {
      counts[length] = (counts[length] ?? 0) + 1;
    }

    final mostCommon = counts.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return '${mostCommon.key} days (${mostCommon.value} times)';
  }

  String _getAveragePeriodDuration() {
    if (_periods.isEmpty) return 'No data';

    final durations = _periods
        .map((p) => p.endDate.difference(p.startDate).inDays + 1)
        .toList();
    final average = durations.reduce((a, b) => a + b) / durations.length;

    return '${average.round()} days';
  }
}
