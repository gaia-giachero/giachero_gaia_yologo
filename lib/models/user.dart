class User {
  final String email;
  final String password;
  final String username;
  final String? bio;

  const User({
    required this.email,
    required this.password,
    required this.username,
    this.bio,
  });
}