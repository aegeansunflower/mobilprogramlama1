import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue'] as int),
    );
  }

  static const List<CategoryModel> defaultCategories = [
    CategoryModel(
      id: 'work',
      name: 'İş ve Projeler',
      icon: Icons.work_outline,
      color: Colors.blue,
    ),
    CategoryModel(
      id: 'personal',
      name: 'Kişisel Yaşam',
      icon: Icons.person_outline,
      color: Colors.purple,
    ),
    CategoryModel(
      id: 'health',
      name: 'Sağlık ve Spor',
      icon: Icons.fitness_center_outlined,
      color: Colors.green,
    ),
    CategoryModel(
      id: 'study',
      name: 'Eğitim ve Ders',
      icon: Icons.menu_book_outlined,
      color: Colors.orange,
    ),
    CategoryModel(
      id: 'mindful',
      name: 'Zihin ve Dinlenme',
      icon: Icons.self_improvement_outlined,
      color: Colors.teal,
    ),
    CategoryModel(
      id: 'household',
      name: 'Ev ve İşler',
      icon: Icons.home_outlined,
      color: Colors.amber,
    ),
  ];

  static CategoryModel getById(String id) {
    return defaultCategories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => defaultCategories[0],
    );
  }
}
