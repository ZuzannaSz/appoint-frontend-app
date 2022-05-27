class User{
  late String username;
  late String token;
  late DateTime dateOfRegister;
  late String refreshToken;
  User();
  User.withData(this.username,this.token,this.refreshToken);
}