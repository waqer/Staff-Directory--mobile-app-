// lib/models/employee.dart

enum Designation {
  juniorExecutive,
  executive,
  seniorExecutive,
  assistant,
  deputyManager,
  manager,
  seniorManager,
  coo,
  ceo,
}

enum EmployeeStatus {
  onDuty,
  onLeave,
  home,
}

enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

class Employee {
  final String id;
  final String name;
  final String department;
  final Designation designation;
  final String phoneNumber;
  final String landlineShortNumber;
  final BloodGroup bloodGroup;
  EmployeeStatus status;
  final String email;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelation;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    required this.phoneNumber,
    required this.landlineShortNumber,
    required this.bloodGroup,
    required this.status,
    required this.email,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelation,
  });

  static String designationLabel(Designation d) {
    switch (d) {
      case Designation.juniorExecutive:
        return 'Junior Executive';
      case Designation.executive:
        return 'Executive';
      case Designation.seniorExecutive:
        return 'Senior Executive';
      case Designation.assistant:
        return 'Assistant';
      case Designation.deputyManager:
        return 'Deputy Manager';
      case Designation.manager:
        return 'Manager';
      case Designation.seniorManager:
        return 'Senior Manager';
      case Designation.coo:
        return 'COO';
      case Designation.ceo:
        return 'CEO';
    }
  }

  static String bloodGroupLabel(BloodGroup bg) {
    switch (bg) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
    }
  }

  static String statusLabel(EmployeeStatus s) {
    switch (s) {
      case EmployeeStatus.onDuty:
        return 'On Duty';
      case EmployeeStatus.onLeave:
        return 'On Leave';
      case EmployeeStatus.home:
        return 'Home';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'designation': designation.index,
      'phoneNumber': phoneNumber,
      'landlineShortNumber': landlineShortNumber,
      'bloodGroup': bloodGroup.index,
      'status': status.index,
      'email': email,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      department: map['department'],
      designation: Designation.values[map['designation']],
      phoneNumber: map['phoneNumber'],
      landlineShortNumber: map['landlineShortNumber'],
      bloodGroup: BloodGroup.values[map['bloodGroup']],
      status: EmployeeStatus.values[map['status']],
      email: map['email'],
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      emergencyContactRelation: map['emergencyContactRelation'],
    );
  }
}
