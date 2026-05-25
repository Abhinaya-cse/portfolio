import 'package:flutter/material.dart';
import '../models/models.dart';

class PortfolioData {
  static const String name = 'Abhinaya B';
  static const String title = 'Software Developer';
  static const String tagline = 'Flutter · Firebase · Full-Stack';
  static const String bio =
      'Computer Science graduate with hands-on industry experience as a Software Developer at '
      'Antano & Harini, where I built and delivered production-grade Flutter mobile apps '
      'integrated with Firebase. Strong technical foundation, problem-solving aptitude, '
      'and a team-oriented professional committed to continuous learning.';

  static const String email = 'abhinaya03.b@gmail.com';
  static const String phone = '9789834802';
  static const String linkedin = 'https://www.linkedin.com/in/abhinaya03b';
  static const String github = 'https://github.com/Abhinaya-cse';
  static const String cgpa = '8.74';
  static const String college = 'Meenakshi Sundararajan Engineering College';
  static const String degree = 'B.E Computer Science and Engineering';
  static const String collegeDuration = 'Sep 2021 – May 2025';

  static final List<Project> projects = [
    const Project(
      title: 'AHCRM',
      subtitle: 'Customer Relationship Management App',
      description:
          'A Flutter CRM with Firebase Auth, role-based access, real-time Firestore sync, '
          'participant management, journey tracking, and support ticket chat with file attachments.',
      tech: ['Flutter', 'Dart', 'Firebase', 'Firestore', 'Auth', 'FCM', 'SharedPreferences'],
      bullets: [
        'Role-based access control with real-time data sync',
        'Push notifications via FCM with grouped notification log',
        'Analytics dashboard with sales & finance KPIs',
        'Support ticket chat with file attachments',
      ],
      color: Color(0xFF6C63FF),
    ),
    const Project(
      title: 'SALESCRM',
      subtitle: 'Sales Pipeline & Lead Management App',
      description:
          'Flutter app for multi-pipeline lead management with stage-wise progression '
          'tracking and real-time Firestore sync.',
      tech: ['Flutter', 'Dart', 'Firebase', 'Firestore', 'Auth', 'FCM'],
      bullets: [
        'Multi-pipeline lead management with stage tracking',
        'Call, consultation scheduling, sale & offer management',
        'Role-based access with real-time Firestore sync',
      ],
      color: Color(0xFF00D4AA),
    ),
    const Project(
      title: 'Smart Serve',
      subtitle: 'Modern Slotted Ration Distribution App',
      description:
          'Dual-role Flutter app for User & Ration Shop with Firebase Auth, smart slot booking, '
          'live inventory tracking, and cross-shop purchasing.',
      tech: ['Flutter', 'Dart', 'Firebase', 'Realtime DB', 'Storage', 'Auth'],
      bullets: [
        'Real-time availability tracking per product',
        'Payment summary and shop registration',
        'Firebase Storage for license upload',
        'Cross-shop purchasing support',
      ],
      color: Color(0xFFFF7043),
    ),
    const Project(
      title: 'EVENTVISTAS',
      subtitle: 'Conference Management System',
      description:
          'Networking platform for students and job seekers showcasing skills in project '
          'management, UX design, and data analytics. Won 3rd prize at Project Demo Day.',
      tech: ['HTML', 'CSS', 'PHP'],
      bullets: [
        'Networking platform for students and job seekers',
        'UX-focused design with data analytics',
        '🏆 Won 3rd prize at Project Demo Day',
      ],
      color: Color(0xFFAB47BC),
    ),
  ];

  static final List<Experience> experience = [
    const Experience(
      role: 'Software Developer',
      company: 'Antano & Harini',
      duration: 'Nov 2025 – Apr 2026',
      description:
          'Developed and delivered production-grade Flutter mobile apps (AHCRM & SALESCRM) '
          'integrated with Firebase. Built role-based access control, real-time data sync, '
          'push notifications, analytics dashboard, and support ticket system.',
      isFirst: true,
    ),
    const Experience(
      role: 'Intern Trainee',
      company: 'Mission Samriddhi',
      duration: 'Aug 2025 – Sept 2025',
      description: 'Developed a Flutter app to manage NGO programs and activities.',
    ),
    const Experience(
      role: 'MERN Stack Intern Trainee',
      company: 'EY GDS & AICTE',
      duration: 'Feb 2025 – Mar 2025',
      description: 'Focused on full-stack development and built modern web applications using the MERN stack.',
    ),
    const Experience(
      role: 'Web Development Intern',
      company: 'Kumari Tech',
      duration: 'Jan 2025 – Feb 2025',
      description: 'Focused on front-end development and developed a web application using HTML, CSS, JavaScript.',
    ),
    const Experience(
      role: 'UI/UX Intern',
      company: 'Jeevisoft Solutions',
      duration: 'Jul 2024 – Aug 2024',
      description: 'Gained hands-on experience in website design using Figma. Responsive Web Design, UI Design.',
      isLast: true,
    ),
  ];

  static final List<Skill> skills = [
    const Skill(name: 'Flutter', level: 0.92, category: 'Mobile'),
    const Skill(name: 'Dart', level: 0.90, category: 'Mobile'),
    const Skill(name: 'Firebase', level: 0.88, category: 'Backend'),
    const Skill(name: 'Firestore', level: 0.85, category: 'Backend'),
    const Skill(name: 'JavaScript', level: 0.78, category: 'Web'),
    const Skill(name: 'HTML & CSS', level: 0.82, category: 'Web'),
    const Skill(name: 'MERN Stack', level: 0.72, category: 'Web'),
    const Skill(name: 'Figma', level: 0.80, category: 'Design'),
    const Skill(name: 'SQL', level: 0.75, category: 'Backend'),
    const Skill(name: 'Git', level: 0.85, category: 'Tools'),
  ];

  static final List<Map<String, String>> certifications = [
    {
      'title': 'Walmart Advanced Software Engineering Virtual Experience',
      'org': 'Forage',
      'date': 'May 2026',
    },
    {
      'title': 'MERN Stack Full-Stack Development',
      'org': 'EY GDS & AICTE',
      'date': 'Mar 2025',
    },
  ];

  static final List<String> achievements = [
    'Won 3rd prize in Project Demo Day for EVENTVISTAS',
    'Awarded merit scholarship for securing 2nd highest score in board exams',
    'Promoted as Higher Education Scholar in Ullas Trust in 2022',
    'Passed and awarded scholarship as a Young Achiever in Ullas Trust in 2018',
  ];
}
