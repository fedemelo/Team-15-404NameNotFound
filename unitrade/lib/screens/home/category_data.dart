import 'package:flutter/material.dart';

class Categories {
  static const String textbooks = "Textbooks";
  static const String studyGuides = "Study_guides";
  static const String electronics = "Electronics";
  static const String laptopsTablets = "Laptops_&_tablets";
  static const String calculators = "Calculators";
  static const String chargers = "Chargers";
  static const String labMaterials = "Lab_materials";
  static const String notebooks = "Notebooks";
  static const String artDesign = "Art_&_design";
  static const String roboticKits = "Robotic_kits";
  static const String threeDPrinting = "3D_printing";
  static const String uniforms = "Uniforms";
  static const String sports = "Sports";
  static const String musicalInstruments = "Musical_instruments";
}

class Groups {
  static const String study = "Study";
  static const String technology = "Tech";
  static const String creative = "Creative";
  static const String others = "Others";
  static const String lab = "Lab";
  static const String personal = "Personal";
}

final Map<String, List<String>> productGroups = {
  Groups.study: [
    Categories.textbooks,
    Categories.studyGuides,
    Categories.notebooks,
    Categories.calculators,
    Categories.labMaterials
  ],
  Groups.technology: [
    Categories.electronics,
    Categories.laptopsTablets,
    Categories.chargers,
    Categories.calculators,
    Categories.threeDPrinting,
    Categories.roboticKits
  ],
  Groups.creative: [
    Categories.artDesign,
    Categories.threeDPrinting,
    Categories.musicalInstruments
  ],
  Groups.others: [
    Categories.sports,
    Categories.musicalInstruments,
    Categories.uniforms
  ],
  Groups.lab: [
    Categories.labMaterials,
    Categories.roboticKits,
    Categories.threeDPrinting,
    Categories.calculators
  ],
  Groups.personal: [
    Categories.uniforms,
    Categories.chargers,
    Categories.laptopsTablets
  ]
};

final Map<String, IconData> categoryIcons = {
  'For You': Icons.favorite,   // Ejemplo: Ícono para "For You"
  'Study': Icons.book,         // Ejemplo: Ícono para "Study"
  'Tech': Icons.computer,      // Ejemplo: Ícono para "Tech"
  'Creative': Icons.palette,   // Ejemplo: Ícono para "Creative"
  'Others': Icons.more_horiz,  // Ejemplo: Ícono para "Others"
  'Lab': Icons.science,        // Ejemplo: Ícono para "Lab"
  'Personal': Icons.person,    // Ejemplo: Ícono para "Personal"
};

// Función que recibe una lista de categorías y devuelve una lista de grupos
List<String> categorize(List<String> categories) {
  Set<String> groups = {};  // Usamos un Set para evitar duplicados

  for (String category in categories) {
    productGroups.forEach((group, groupCategories) {
      if (groupCategories.contains(category)) {
        groups.add(group);  // Agregamos el grupo al Set
      }
    });
  }

  return groups.toList();  // Convertimos el Set a una lista y lo retornamos
}
