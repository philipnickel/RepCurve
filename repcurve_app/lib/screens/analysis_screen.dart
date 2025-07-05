import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout_models.dart';
import '../services/api_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<WorkoutLog> _workoutLogs = [];
  bool _isLoading = false;
  String _selectedExercise = 'All';
  List<String> _exerciseTypes = ['All', 'Squat', 'Bench Press', 'Deadlift'];

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getWorkoutLogs();
      if (response.success && response.data != null) {
        setState(() {
          _workoutLogs = response.data!.where((log) {
            return log.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
                   log.date.isBefore(_endDate.add(const Duration(days: 1)));
          }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadWorkoutData();
    }
  }

  List<FlSpot> _getProgressData() {
    List<FlSpot> spots = [];
    
    // Filter workouts by selected exercise
    List<WorkoutLog> filteredLogs = _workoutLogs;
    if (_selectedExercise != 'All') {
      filteredLogs = _workoutLogs.where((log) {
        return log.exerciseLogs.any((exercise) => 
          exercise.exerciseName.toLowerCase().contains(_selectedExercise.toLowerCase()));
      }).toList();
    }

    // Group by date and calculate max 1RM for each day
    Map<DateTime, double> dailyMaxes = {};
    
    for (var log in filteredLogs) {
      DateTime date = DateTime(log.date.year, log.date.month, log.date.day);
      double maxOneRM = 0;
      
      for (var exercise in log.exerciseLogs) {
        if (_selectedExercise == 'All' || 
            exercise.exerciseName.toLowerCase().contains(_selectedExercise.toLowerCase())) {
          for (var set in exercise.setLogs) {
            if (set.estimatedOneRM > maxOneRM) {
              maxOneRM = set.estimatedOneRM;
            }
          }
        }
      }
      
      if (maxOneRM > 0) {
        dailyMaxes[date] = maxOneRM;
      }
    }

    // Convert to chart data
    List<MapEntry<DateTime, double>> sortedEntries = dailyMaxes.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (int i = 0; i < sortedEntries.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedEntries[i].value));
    }

    return spots;
  }

  Widget _buildProgressChart() {
    List<FlSpot> spots = _getProgressData();
    
    if (spots.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('No data available for the selected period'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated 1RM Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt() + 1}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    int totalWorkouts = _workoutLogs.length;
    int totalSets = _workoutLogs.fold(0, (sum, log) => 
      sum + log.exerciseLogs.fold(0, (exerciseSum, exercise) => 
        exerciseSum + exercise.setLogs.length));
    
    double avgWorkoutsPerWeek = totalWorkouts > 0 
        ? (totalWorkouts / (_endDate.difference(_startDate).inDays / 7))
        : 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Workouts',
            totalWorkouts.toString(),
            Icons.fitness_center,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Sets',
            totalSets.toString(),
            Icons.repeat,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Avg/Week',
            avgWorkoutsPerWeek.toStringAsFixed(1),
            Icons.date_range,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date range and exercise filter
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text('Date Range'),
                      subtitle: Text(
                        '${_startDate.day}/${_startDate.month} - ${_endDate.day}/${_endDate.month}',
                      ),
                      onTap: _selectDateRange,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: _selectedExercise,
                        isExpanded: true,
                        underline: Container(),
                        items: _exerciseTypes.map((String exercise) {
                          return DropdownMenuItem<String>(
                            value: exercise,
                            child: Text(exercise),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedExercise = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats cards
            _buildStatsCards(),
            const SizedBox(height: 16),

            // Progress chart
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProgressChart(),
            ),
          ],
        ),
      ),
    );
  }
}