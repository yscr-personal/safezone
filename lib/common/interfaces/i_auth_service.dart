abstract class IAuthService {
  Future login(
    final String username,
    final String password, {
    final bool rememberDevice = true,
  });

  Future fetchSession();

  Future fetchCurrentUser();

  Future logout({final bool everywhere = false});

  Future register(
    final String username,
    final String password, {
    final bool rememberDevice = true,
  });

  Future confirmRegistration(
    final String username,
    final String confirmationCode,
  );
}
