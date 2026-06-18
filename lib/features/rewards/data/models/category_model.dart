class CategoryModel {
  final String id;
  final String name;
  final String iconName;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
    };
  }
}
