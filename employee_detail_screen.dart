// lib/screens/employee_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/employee.dart';
import '../theme/app_theme.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;
  final Function(EmployeeStatus) onStatusChanged;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
    required this.onStatusChanged,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late EmployeeStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.employee.status;
  }

  void _changeStatus(EmployeeStatus newStatus) {
    setState(() => _currentStatus = newStatus);
    widget.employee.status = newStatus;
    widget.onStatusChanged(newStatus);
  }

  void _copyToClipboard(String text, String label) {
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
    final e = widget.employee;
    final designation = Employee.designationLabel(e.designation);
    final bloodGroup = Employee.bloodGroupLabel(e.bloodGroup);
    final statusLabel = Employee.statusLabel(_currentStatus);
    final statusColor = AppTheme.statusColor(statusLabel);
    final desigColor = AppTheme.designationColor(designation);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor,
                      desigColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white24,
                        child: Text(
                          e.name.split(' ').take(2).map((n) => n[0]).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        e.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          designation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              PopupMenuButton<EmployeeStatus>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Change Status',
                itemBuilder: (_) => EmployeeStatus.values.map((s) {
                  final label = Employee.statusLabel(s);
                  return PopupMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.statusColor(label),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(label),
                      ],
                    ),
                  );
                }).toList(),
                onSelected: _changeStatus,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status card
                  _StatusCard(
                    currentStatus: _currentStatus,
                    statusLabel: statusLabel,
                    statusColor: statusColor,
                    onChangeStatus: _changeStatus,
                  ),
                  const SizedBox(height: 14),

                  // Quick info row
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Employee ID',
                          value: e.id,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.bloodtype_outlined,
                          label: 'Blood Group',
                          value: bloodGroup,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.business_outlined,
                          label: 'Department',
                          value: e.department,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.dialpad_outlined,
                          label: 'Short Number',
                          value: 'Ext. ${e.landlineShortNumber}',
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contact section
                  _SectionHeader(title: 'Contact Information', icon: Icons.contacts_outlined),
                  const SizedBox(height: 8),
                  _ContactCard(
                    icon: Icons.phone_rounded,
                    label: 'Mobile Number',
                    value: e.phoneNumber,
                    color: AppTheme.onDutyColor,
                    onCopy: () => _copyToClipboard(e.phoneNumber, 'Mobile number'),
                  ),
                  const SizedBox(height: 8),
                  _ContactCard(
                    icon: Icons.phone_in_talk_rounded,
                    label: 'Landline Extension',
                    value: 'Ext. ${e.landlineShortNumber}',
                    color: Colors.orange.shade700,
                    onCopy: () => _copyToClipboard(e.landlineShortNumber, 'Extension'),
                  ),
                  const SizedBox(height: 8),
                  _ContactCard(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: e.email,
                    color: AppTheme.accentColor,
                    onCopy: () => _copyToClipboard(e.email, 'Email'),
                  ),

                  const SizedBox(height: 16),

                  // Emergency contact
                  _SectionHeader(
                      title: 'Emergency Contact', icon: Icons.emergency_outlined),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red.shade100,
                              child: Icon(Icons.person,
                                  color: Colors.red.shade600, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.emergencyContactName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    e.emergencyContactRelation,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.red.shade600),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.emergencyContactPhone,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy,
                                  size: 16, color: Colors.red.shade400),
                              onPressed: () => _copyToClipboard(
                                  e.emergencyContactPhone, 'Emergency contact number'),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final EmployeeStatus currentStatus;
  final String statusLabel;
  final Color statusColor;
  final Function(EmployeeStatus) onChangeStatus;

  const _StatusCard({
    required this.currentStatus,
    required this.statusLabel,
    required this.statusColor,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 6)
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Currently: $statusLabel',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          PopupMenuButton<EmployeeStatus>(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Change',
                style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            itemBuilder: (_) => EmployeeStatus.values.map((s) {
              final label = Employee.statusLabel(s);
              return PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.statusColor(label),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
              );
            }).toList(),
            onSelected: onChangeStatus,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 10),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onCopy;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
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
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
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
                Text(label,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 11)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_outlined, size: 18, color: Colors.grey.shade400),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
