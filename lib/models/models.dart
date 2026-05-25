
import 'package:flutter/material.dart';

class Project {
  final String title;
  final String subtitle;
  final String description;
  final List<String> tech;
  final List<String> bullets;
  final String? githubUrl;
  final Color color;

  const Project({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tech,
    required this.bullets,
    this.githubUrl,
    required this.color,
  });
}

class Experience {
  final String role;
  final String company;
  final String duration;
  final String description;
  final bool isFirst;
  final bool isLast;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    this.isFirst = false,
    this.isLast = false,
  });
}

class Skill {
  final String name;
  final double level;
  final String category;

  const Skill({required this.name, required this.level, required this.category});
}
