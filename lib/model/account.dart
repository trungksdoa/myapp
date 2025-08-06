import 'package:flutter/material.dart';

class Account {
  final String accountId;
  final String fullName;
  final String email;
  final String password;
  final int role;
  final bool status;
  final DateTime dateOfBirth;
  final String gender;
  final String nationality;
  final String homeTown;
  final String permanentAddress;
  final String issuedDate;
  final String issuedBy;
  final String imgUrl;

  Account({
    required this.accountId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.homeTown,
    required this.permanentAddress,
    required this.issuedDate,
    required this.issuedBy,
    required this.imgUrl,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      status: json['status'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      nationality: json['nationality'],
      homeTown: json['homeTown'],
      permanentAddress: json['permanentAddress'],
      issuedDate: json['issuedDate'],
      issuedBy: json['issuedBy'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': role,
      'status': status,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'nationality': nationality,
      'homeTown': homeTown,
      'permanentAddress': permanentAddress,
      'issuedDate': issuedDate,
      'issuedBy': issuedBy,
      'imgUrl': imgUrl,
    };
  }
}
