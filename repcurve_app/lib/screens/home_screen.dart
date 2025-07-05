import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/api_response.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiHealth? _apiHealth;
  ApiInfo? _apiInfo;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check API health
      final healthResponse = await ApiService.checkHealth();
      if (healthResponse.success) {
        _apiHealth = healthResponse.data;
      } else {
        _error = healthResponse.error;
      }

      // Get API info
      final infoResponse = await ApiService.getApiInfo();
      if (infoResponse.success) {
        _apiInfo = infoResponse.data;
      }
    } catch (e) {
      _error = 'Failed to connect to API: $e';
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RepCurve'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null 
                            ? 'Welcome back, ${user.firstName.isNotEmpty ? user.firstName : user.username}!'
                            : 'Welcome to RepCurve',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Track your powerlifting progress and analyze your rep curves.',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // API Connection Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.api),
                        const SizedBox(width: 8),
                        Text(
                          'API Connection',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Checking connection...'),
                        ],
                      )
                    else if (_error != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              const Text('Connection Failed'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _checkApiConnection,
                            child: const Text('Retry'),
                          ),
                        ],
                      )
                    else if (_apiHealth != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(_apiHealth!.status.toUpperCase()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(_apiHealth!.message),
                          if (_apiInfo != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${_apiInfo!.name} v${_apiInfo!.version}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildActionCard(
                    context,
                    icon: Icons.fitness_center,
                    title: 'New Workout',
                    subtitle: 'Start tracking',
                    onTap: () {
                      // TODO: Navigate to new workout screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('New workout coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.history,
                    title: 'Workout History',
                    subtitle: 'View past workouts',
                    onTap: () {
                      // TODO: Navigate to workout history
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('History coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.trending_up,
                    title: 'Progress Charts',
                    subtitle: 'Analyze rep curves',
                    onTap: () {
                      // TODO: Navigate to progress charts
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Charts coming soon!')),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () {
                      // TODO: Navigate to settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}