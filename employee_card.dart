// lib/widgets/employee_card.dart

import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../theme/app_theme.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final designation = Employee.designationLabel(employee.designation);
    final statusLabel = Employee.statusLabel(employee.status);
    final statusColor = AppTheme.statusColor(statusLabel);
    final desigColor = AppTheme.designationColor(designation);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: desigColor.withOpacity(0.12),
                    child: Text(
                      employee.name.split(' ').take(2).map((e) => e[0]).join(),
                      style: TextStyle(
                        color: desigColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: statusColor.withOpacity(0.4), width: 0.8),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      designation,
                      style: TextStyle(
                        color: desigColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.business_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(
                          employee.department,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.phone_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(
                          'Ext. ${employee.landlineShortNumber}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _BloodGroupBadge(
                            group: Employee.bloodGroupLabel(employee.bloodGroup)),
                        const SizedBox(width: 6),
                        Icon(Icons.badge_outlined,
                            size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 3),
                        Text(
                          employee.id,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right,
                  color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BloodGroupBadge extends StatelessWidget {
  final String group;
  const _BloodGroupBadge({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade200, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bloodtype, size: 10, color: Colors.red.shade400),
          const SizedBox(width: 2),
          Text(
            group,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
