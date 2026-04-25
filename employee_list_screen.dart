// lib/screens/employee_list_screen.dart

import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/employee_card.dart';
import 'employee_detail_screen.dart';
import 'emergency_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _employees = [];
  List<Employee> _filtered = [];

  String _searchQuery = '';
  String _selectedDept = 'All Departments';
  Designation? _selectedDesignation;
  EmployeeStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _employees = List.from(sampleEmployees);
    _filtered = List.from(_employees);
  }

  void _applyFilters() {
    setState(() {
      _filtered = _employees.where((e) {
        final query = _searchQuery.toLowerCase();
        final matchName = e.name.toLowerCase().contains(query);
        final matchDept = e.department.toLowerCase().contains(query);
        final matchDesig =
            Employee.designationLabel(e.designation).toLowerCase().contains(query);

        final matchSearch = query.isEmpty || matchName || matchDept || matchDesig;
        final matchDeptFilter =
            _selectedDept == 'All Departments' || e.department == _selectedDept;
        final matchDesigFilter =
            _selectedDesignation == null || e.designation == _selectedDesignation;
        final matchStatusFilter =
            _selectedStatus == null || e.status == _selectedStatus;

        return matchSearch && matchDeptFilter && matchDesigFilter && matchStatusFilter;
      }).toList();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        selectedDept: _selectedDept,
        selectedDesignation: _selectedDesignation,
        selectedStatus: _selectedStatus,
        onApply: (dept, desig, status) {
          setState(() {
            _selectedDept = dept;
            _selectedDesignation = desig;
            _selectedStatus = status;
          });
          _applyFilters();
          Navigator.pop(context);
        },
        onClear: () {
          setState(() {
            _selectedDept = 'All Departments';
            _selectedDesignation = null;
            _selectedStatus = null;
          });
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedDept != 'All Departments' ||
      _selectedDesignation != null ||
      _selectedStatus != null;

  // Stats
  int get _onDutyCount =>
      _employees.where((e) => e.status == EmployeeStatus.onDuty).length;
  int get _onLeaveCount =>
      _employees.where((e) => e.status == EmployeeStatus.onLeave).length;
  int get _homeCount =>
      _employees.where((e) => e.status == EmployeeStatus.home).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_hospital_rounded),
            tooltip: 'Emergency Info',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  count: _employees.length,
                  color: Colors.white24,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'On Duty',
                  count: _onDutyCount,
                  color: AppTheme.onDutyColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'On Leave',
                  count: _onLeaveCount,
                  color: AppTheme.onLeaveColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Home',
                  count: _homeCount,
                  color: AppTheme.homeColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),

          // Search & Filter row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, dept, designation…',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                                _applyFilters();
                              },
                            )
                          : null,
                    ),
                    onChanged: (v) {
                      setState(() => _searchQuery = v);
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    InkWell(
                      onTap: _showFilterSheet,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _hasActiveFilters
                              ? AppTheme.accentColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _hasActiveFilters
                                ? AppTheme.accentColor
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: _hasActiveFilters
                              ? Colors.white
                              : Colors.grey.shade700,
                          size: 22,
                        ),
                      ),
                    ),
                    if (_hasActiveFilters)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Active filter chips
          if (_hasActiveFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_selectedDept != 'All Departments')
                            _ActiveChip(
                              label: _selectedDept,
                              onRemove: () {
                                setState(() => _selectedDept = 'All Departments');
                                _applyFilters();
                              },
                            ),
                          if (_selectedDesignation != null)
                            _ActiveChip(
                              label: Employee.designationLabel(_selectedDesignation!),
                              onRemove: () {
                                setState(() => _selectedDesignation = null);
                                _applyFilters();
                              },
                            ),
                          if (_selectedStatus != null)
                            _ActiveChip(
                              label: Employee.statusLabel(_selectedStatus!),
                              onRemove: () {
                                setState(() => _selectedStatus = null);
                                _applyFilters();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} employee${_filtered.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No employees found',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => EmployeeCard(
                      employee: _filtered[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeDetailScreen(
                              employee: _filtered[i],
                              onStatusChanged: (newStatus) {
                                setState(() => _filtered[i].status = newStatus);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color textColor;
  const _StatChip(
      {required this.label,
      required this.count,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 12, color: AppTheme.accentColor),
          ),
        ],
      ),
    );
  }
}

// ---------- Filter Bottom Sheet ----------
class _FilterSheet extends StatefulWidget {
  final String selectedDept;
  final Designation? selectedDesignation;
  final EmployeeStatus? selectedStatus;
  final Function(String, Designation?, EmployeeStatus?) onApply;
  final VoidCallback onClear;

  const _FilterSheet({
    required this.selectedDept,
    required this.selectedDesignation,
    required this.selectedStatus,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _dept;
  Designation? _designation;
  EmployeeStatus? _status;

  @override
  void initState() {
    super.initState();
    _dept = widget.selectedDept;
    _designation = widget.selectedDesignation;
    _status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Filter Employees',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                      onPressed: widget.onClear, child: const Text('Clear All')),
                ],
              ),
              const SizedBox(height: 16),

              // Department
              const Text('Department',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _dept,
                decoration: const InputDecoration(),
                items: allDepartments
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _dept = v!),
              ),
              const SizedBox(height: 16),

              // Designation
              const Text('Designation',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Designation.values.map((d) {
                  final label = Employee.designationLabel(d);
                  final selected = _designation == d;
                  return FilterChip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    selected: selected,
                    selectedColor: AppTheme.accentColor.withOpacity(0.15),
                    checkmarkColor: AppTheme.accentColor,
                    onSelected: (_) =>
                        setState(() => _designation = selected ? null : d),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Status
              const Text('Status',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: EmployeeStatus.values.map((s) {
                  final label = Employee.statusLabel(s);
                  final selected = _status == s;
                  return FilterChip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    selected: selected,
                    selectedColor:
                        AppTheme.statusColor(label).withOpacity(0.15),
                    checkmarkColor: AppTheme.statusColor(label),
                    onSelected: (_) =>
                        setState(() => _status = selected ? null : s),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => widget.onApply(_dept, _designation, _status),
                  child: const Text('Apply Filters',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
