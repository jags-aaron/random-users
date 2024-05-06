import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/model/filter.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({
    super.key,
    required this.saveFilter,
    required this.filter,
  });

  final Function(Filter) saveFilter;
  final Filter? filter;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _numberOfUsersController =
      TextEditingController();
  int? _numberOfUsers;
  Gender? _selectedGender;
  final List<Nationality> _selectedNationalities = [];
  final List<Include> _selectedIncludes = [];
  final List<Exclude> _selectedExcludes = [];

  bool initialState = true;

  void restoreFilters() {
    _numberOfUsersController.text = '10';
    _numberOfUsers = 10;
    _selectedGender = null;
    _selectedNationalities.clear();
    _selectedIncludes.clear();
    _selectedExcludes.clear();
    setState(() {});
  }

  bool _invalidNumber() {
    if(_numberOfUsersController.text.isEmpty) {
      return true;
    }
    if(_numberOfUsers == null || _numberOfUsersController.text.isEmpty) {
      return false;
    }
    if (_numberOfUsers == null ||
        _numberOfUsers! < 1 ||
        _numberOfUsers! > 5000) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (initialState) {
      _numberOfUsersController.text = widget.filter?.results?.toString() ?? '';
      _numberOfUsers = widget.filter?.results;
      _selectedGender = widget.filter?.gender;
      _selectedNationalities.addAll(widget.filter?.nationality?.toList() ?? []);
      _selectedIncludes.addAll(widget.filter?.include?.toList() ?? []);
      _selectedExcludes.addAll(widget.filter?.exclude?.toList() ?? []);
      initialState = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Filters'),
        leading: IconButton(
          iconSize: 25,
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              restoreFilters();
            },
            child: const Text(
              'Restore',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Max number of results'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _numberOfUsersController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            _numberOfUsers = int.tryParse(value);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: '1 to 5000 (max)',
                            error: _invalidNumber()
                                ? const Text(
                                    'Invalid number',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: DropdownButton<Gender>(
                          value: _selectedGender,
                          underline: Container(),
                          items: Gender.values.map((gender) {
                            return DropdownMenuItem<Gender>(
                              value: gender,
                              child: Text(gender.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          hint: const Text('Gender'),
                        ),
                      ),
                      Card(
                        child: ExpansionTile(
                          title: const Text('Nationality'),
                          children: Nationality.values.map((nationality) {
                            return CheckboxListTile(
                              title:
                                  Text(nationality.toString().split('.').last),
                              value:
                                  _selectedNationalities.contains(nationality),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedNationalities.add(nationality);
                                  } else {
                                    _selectedNationalities.remove(nationality);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Card(
                        child: ExpansionTile(
                          title: const Text('Include'),
                          children: Include.values.map((include) {
                            return CheckboxListTile(
                              title: Text(include.toString().split('.').last),
                              value: _selectedIncludes.contains(include),
                              onChanged: (checked) {
                                setState(() {
                                  if (_selectedExcludes.isNotEmpty) {
                                    _selectedExcludes.clear();
                                  }
                                  if (checked == true) {
                                    _selectedIncludes.add(include);
                                  } else {
                                    _selectedIncludes.remove(include);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Card(
                        child: ExpansionTile(
                          title: const Text('Exclude'),
                          children: Exclude.values.map((exclude) {
                            return CheckboxListTile(
                              title: Text(exclude.toString().split('.').last),
                              value: _selectedExcludes.contains(exclude),
                              onChanged: (checked) {
                                setState(() {
                                  if (_selectedIncludes.isNotEmpty) {
                                    _selectedIncludes.clear();
                                  }
                                  if (checked == true) {
                                    _selectedExcludes.add(exclude);
                                  } else {
                                    _selectedExcludes.remove(exclude);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  widget.saveFilter(Filter(
                    results: _numberOfUsers,
                    include: _selectedIncludes,
                    exclude: _selectedExcludes,
                    gender: _selectedGender,
                    nationality: _selectedNationalities,
                  ));
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
