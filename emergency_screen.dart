// lib/screens/emergency_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/sample_data.dart';
import '../models/employee.dart';
import '../theme/app_theme.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  // Get top leadership
  List<Employee> get _leadership => sampleEmployees
      .where((e) =>
          e.designation == Designation.ceo ||
          e.designation == Designation.coo ||
          e.designation == Designation.seniorManager)
      .toList();

  // Blood group map
  Map<String, List<Employee>> get _bloodGroupMap {
    final map = <String, List<Employee>>{};
    for (final e in sampleEmployees) {
      final bg = Employee.bloodGroupLabel(e.bloodGroup);
      map.putIfAbsent(bg, () => []).add(e);
    }
    return map;
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloodMap = _bloodGroupMap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Information'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Emergency notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.red.shade500],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Icon(Icons.emergency, color: Colors.white, size: 36),
                const SizedBox(height: 8),
                const Text(
                  'EMERGENCY SUPPORT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Critical contact information for emergencies',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Emergency hotlines
          _SectionTitle(title: 'Emergency Hotlines', icon: Icons.local_phone, color: Colors.red.shade700),
          const SizedBox(height: 10),
          ..._emergencyHotlines.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HotlineCard(
                  title: h['title']!,
                  number: h['number']!,
                  icon: h['icon'] as IconData,
                  color: h['color'] as Color,
                  onCopy: () => _copyToClipboard(context, h['number']!, h['title']!),
                ),
              )),

          const SizedBox(height: 20),

          // Leadership contacts
          _SectionTitle(
              title: 'Leadership Contacts',
              icon: Icons.supervisor_account,
              color: AppTheme.primaryColor),
          const SizedBox(height: 10),
          ..._leadership.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _LeaderCard(
                  employee: e,
                  onCopy: (text, label) =>
                      _copyToClipboard(context, text, label),
                ),
              )),

          const SizedBox(height: 20),

          // Blood group directory
          _SectionTitle(
              title: 'Blood Group Directory',
              icon: Icons.bloodtype,
              color: Colors.red.shade800),
          Text(
            'Find employees by blood group for emergencies',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ...bloodMap.entries.map((entry) => _BloodGroupTile(
                bloodGroup: entry.key,
                employees: entry.value,
              )),

          const SizedBox(height: 20),

          // General safety tips
          _SectionTitle(
              title: 'Safety Guidelines',
              icon: Icons.health_and_safety,
              color: Colors.teal.shade700),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.teal.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._safetyTips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.teal.shade600, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(tip,
                                  style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _emergencyHotlines = [
    {
      'title': 'National Emergency',
      'number': '999',
      'icon': Icons.emergency_share,
      'color': Colors.red.shade700,
    },
    {
      'title': 'Fire Service',
      'number': '199',
      'icon': Icons.local_fire_department,
      'color': Colors.deepOrange.shade700,
    },
    {
      'title': 'Ambulance / Medical',
      'number': '16430',
      'icon': Icons.local_hospital,
      'color': Colors.pink.shade700,
    },
    {
      'title': 'Police Helpline',
      'number': '100',
      'icon': Icons.local_police,
      'color': Colors.blue.shade800,
    },
    {
      'title': 'Company Reception',
      'number': '+880-2-9876543',
      'icon': Icons.business,
      'color': AppTheme.primaryColor,
    },
    {
      'title': 'Company Security',
      'number': '+880 1800-000000',
      'icon': Icons.security,
      'color': Colors.indigo.shade700,
    },
  ];

  static const List<String> _safetyTips = [
    'In case of fire, use stairs — never elevators. Proceed to the nearest fire exit.',
    'Assembly point is located at the main parking area in front of the building.',
    'First aid kits are available on every floor near the elevator lobby.',
    'In case of a medical emergency, call 16430 or dial Ext. 100 (Security).',
    'Report suspicious activity immediately to security at Ext. 100.',
    'Do not share employee contact details with unauthorized persons.',
    'Keep emergency exits clear at all times.',
  ];
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionTitle(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _HotlineCard extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;
  final Color color;
  final VoidCallback onCopy;

  const _HotlineCard({
    required this.title,
    required this.number,
    required this.icon,
    required this.color,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11)),
                Text(number,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined, size: 18),
            onPressed: onCopy,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

class _LeaderCard extends StatelessWidget {
  final Employee employee;
  final Function(String, String) onCopy;

  const _LeaderCard({required this.employee, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final designation = Employee.designationLabel(employee.designation);
    final desigColor = AppTheme.designationColor(designation);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: desigColor.withOpacity(0.12),
                child: Text(
                  employee.name.split(' ').take(2).map((n) => n[0]).join(),
                  style: TextStyle(
                    color: desigColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(designation,
                        style: TextStyle(color: desigColor, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.statusColor(
                          Employee.statusLabel(employee.status))
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  Employee.statusLabel(employee.status),
                  style: TextStyle(
                    color: AppTheme.statusColor(
                        Employee.statusLabel(employee.status)),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 14),
          Row(
            children: [
              Icon(Icons.phone, size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(employee.phoneNumber,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const Spacer(),
              InkWell(
                onTap: () => onCopy(employee.phoneNumber, 'Phone number'),
                child: Icon(Icons.copy_outlined,
                    size: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 14),
              Icon(Icons.dialpad, size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text('Ext. ${employee.landlineShortNumber}',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BloodGroupTile extends StatelessWidget {
  final String bloodGroup;
  final List<Employee> employees;

  const _BloodGroupTile(
      {required this.bloodGroup, required this.employees});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(
          bloodGroup,
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        '${employees.length} employee${employees.length != 1 ? 's' : ''}',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      children: employees
          .map((e) => ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(
                    e.name[0],
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                title: Text(e.name, style: const TextStyle(fontSize: 13)),
                subtitle: Text(
                    '${Employee.designationLabel(e.designation)} · ${e.department}',
                    style: const TextStyle(fontSize: 11)),
                trailing: Text(e.phoneNumber,
                    style: const TextStyle(fontSize: 11)),
              ))
          .toList(),
    );
  }
}
