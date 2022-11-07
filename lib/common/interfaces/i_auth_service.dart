abstract class IAuthService {
  Future login(
    final String username,
    final String password, {
    final bool rememberDevice = true,
  });

  Future fetchSession();

  Future fetchCurrentUser();

  Future<void> logout({final bool everywhere = false});

  Future register(
    final String username,
    final String password,
  );

  Future confirmRegistration(
    final String username,
    final String confirmationCode,
  );

  Future<bool> isLogged();
}
