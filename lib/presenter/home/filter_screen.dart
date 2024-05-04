import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final TextEditingController _numberOfUsersController = TextEditingController();
  int? _numberOfUsers;
  Gender? _selectedGender;
  final List<Nationality> _selectedNationalities = [];
  final List<Include> _selectedIncludes = [];
  final List<Exclude> _selectedExcludes = [];

  void restoreFilters() {
    _numberOfUsersController.text = '10';
    _numberOfUsers = 10;
    _selectedGender = null;
    _selectedNationalities.clear();
    _selectedIncludes.clear();
    _selectedExcludes.clear();
  }

  @override
  Widget build(BuildContext context) {

    if(_numberOfUsers == null) {
      _numberOfUsersController.text = widget.filter?.results?.toString() ?? '';
      _numberOfUsers = widget.filter?.results;
      _selectedGender = widget.filter?.gender;
      _selectedNationalities.addAll(widget.filter?.nationality?.toList() ?? []);
      _selectedIncludes.addAll(widget.filter?.include?.toList() ?? []);
      _selectedExcludes.addAll(widget.filter?.exclude?.toList() ?? []);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Filters'),
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
                          onChanged: (value) {
                            _numberOfUsers = int.tryParse(value);
                          },
                          decoration: const InputDecoration(
                            labelText: '1 to 5000 (max)',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
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
                              title: Text(nationality.toString().split('.').last),
                              value: _selectedNationalities.contains(nationality),
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
                                  if(_selectedExcludes.isNotEmpty) {
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
                                  if(_selectedIncludes.isNotEmpty) {
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                widget.saveFilter(
                    Filter(
                      results: _numberOfUsers,
                      include: _selectedIncludes,
                      exclude: _selectedExcludes,
                      gender: _selectedGender,
                      nationality: _selectedNationalities,
                    )
                );
              },
              child: const Text('Apply Filters'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                restoreFilters();
                setState(() {
                  widget.saveFilter(
                      Filter(
                        results: _numberOfUsers,
                        include: _selectedIncludes,
                        exclude: _selectedExcludes,
                        gender: _selectedGender,
                        nationality: _selectedNationalities,
                      )
                  );
                });
              },
              child: const Text('Restore Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
