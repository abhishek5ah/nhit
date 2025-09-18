class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final List<String> roles;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.roles,
    required this.isActive,
  });
}
