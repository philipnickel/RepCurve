import 'package:flutter/material.dart';

class AddWorkoutScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const AddWorkoutScreen({super.key, this.selectedDate});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<ExerciseEntry> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    }
    _addExercise(); // Start with one exercise
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    for (var exercise in _exercises) {
      exercise.dispose();
    }
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add(ExerciseEntry());
    });
  }

  void _removeExercise(int index) {
    if (_exercises.length > 1) {
      setState(() {
        _exercises[index].dispose();
        _exercises.removeAt(index);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Save workout to API
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving workout: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveWorkout,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Workout name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  hintText: 'e.g., Push Day, Leg Day',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Date selection
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Workout Date'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 16),

              // Exercises section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercises',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add Exercise',
                  ),
                ],
              ),

              // Exercises list
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Exercise ${index + 1}',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                if (_exercises.length > 1)
                                  IconButton(
                                    onPressed: () => _removeExercise(index),
                                    icon: const Icon(Icons.delete),
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _exercises[index].buildForm(context),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Notes section
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Workout Notes (Optional)',
                  hintText: 'How did the workout feel?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseEntry {
  final TextEditingController nameController = TextEditingController();
  final List<SetEntry> sets = [SetEntry()];

  void dispose() {
    nameController.dispose();
    for (var set in sets) {
      set.dispose();
    }
  }

  void addSet() {
    sets.add(SetEntry());
  }

  void removeSet(int index) {
    if (sets.length > 1) {
      sets[index].dispose();
      sets.removeAt(index);
    }
  }

  Widget buildForm(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            // Exercise name
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Bench Press, Squat',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter exercise name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Sets header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sets',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      addSet();
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 20,
                ),
              ],
            ),

            // Sets list
            ...sets.asMap().entries.map((entry) {
              int index = entry.key;
              SetEntry setEntry = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text('${index + 1}'),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: setEntry.buildRepsField()),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: setEntry.buildWeightField()),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: setEntry.buildRpeField()),
                    if (sets.length > 1)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            removeSet(index);
                          });
                        },
                        icon: const Icon(Icons.remove),
                        iconSize: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class SetEntry {
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController rpeController = TextEditingController();

  void dispose() {
    repsController.dispose();
    weightController.dispose();
    rpeController.dispose();
  }

  Widget buildRepsField() {
    return TextFormField(
      controller: repsController,
      decoration: const InputDecoration(
        labelText: 'Reps',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Reps';
        }
        if (int.tryParse(value) == null) {
          return 'Invalid';
        }
        return null;
      },
    );
  }

  Widget buildWeightField() {
    return TextFormField(
      controller: weightController,
      decoration: const InputDecoration(
        labelText: 'Weight',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Weight';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid';
        }
        return null;
      },
    );
  }

  Widget buildRpeField() {
    return TextFormField(
      controller: rpeController,
      decoration: const InputDecoration(
        labelText: 'RPE',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final rpe = int.tryParse(value);
          if (rpe == null || rpe < 1 || rpe > 10) {
            return '1-10';
          }
        }
        return null;
      },
    );
  }
}