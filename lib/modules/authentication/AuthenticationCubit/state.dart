abstract class AuthenticationState  {}
class AuthenticationInitalState extends AuthenticationState{}
class LoginSuccessState extends AuthenticationState{}
class LoginLoadingState extends AuthenticationState{}
class LoginErrorState extends AuthenticationState{
  final String error;
  LoginErrorState({required this.error});
}
class RegisterLoadingState extends AuthenticationState{}
class RegisterSuccessState extends AuthenticationState{}
class RegisterErrorState extends AuthenticationState{
  final String error;
  RegisterErrorState({required this.error});
}
class CreateUserSuccessState extends AuthenticationState{}
class CreateUserErrorState extends AuthenticationState{
  final String error;
  CreateUserErrorState({required this.error});
}

class ChangeAbscureState extends AuthenticationState{}