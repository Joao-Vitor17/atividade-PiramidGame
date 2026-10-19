class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String provider;
  final String? personId;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.provider = 'password',
    this.personId,
  });

  AppUser copyWith({String? personId}) => AppUser(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        provider: provider,
        personId: personId ?? this.personId,
      );
}