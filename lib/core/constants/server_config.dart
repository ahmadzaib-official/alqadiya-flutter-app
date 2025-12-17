class ServerConfig {
  // static const baseUrl = "http://192.168.1.10:4000/";
  static const baseUrl = "http://51.112.131.120/api/";
  // Below are the all api that are use in our system
  static const login = "${baseUrl}auth/signIn";
  static const register = "${baseUrl}auth/signUp";
  static const verifyOtp = "${baseUrl}auth/verifyOtp";
  static const sendOtp = "${baseUrl}users/public/sendOTP";
  static const forgetPassword = "${baseUrl}auth/forgetPassword";
  static const currentUser = "${baseUrl}users/currentUser";
  static const deleteUser = "${baseUrl}users";
  static const updateProfile = "${baseUrl}users/updateProfile";
  static const uploadPhotoLink = "${baseUrl}users/profile/upload-link";
  static const resetPassword = "${baseUrl}auth/resetPassword";
  static const resetUserPassword = "${baseUrl}users/resetUserPassword";
  static const games = "${baseUrl}games/";
  static const createTeam = "${baseUrl}games/createTeam";
  static const getPlayers = "${baseUrl}users/availablePlayers";
  static const assignPlayers = "${baseUrl}games/assignPlayers";
  static const chooseLeader = "${baseUrl}games/chooseLeader";
  static const joinGame = "${baseUrl}games/joinGame";
  static const notifications = "${baseUrl}notifications";
  static const transactions = "${baseUrl}transactions";
  static const packages = "${baseUrl}points/packages";
  static const paymentMethods = "${baseUrl}points/payment-methods";
  static const purchasePoints = "${baseUrl}points/purchase";
  static const createGameSession = "${baseUrl}game-sessions";
  static const joinGameSession = "${baseUrl}game-sessions/join-player";
  static const teams = "${baseUrl}teams";
  static const assignMembers = "${baseUrl}teams/assign-members";
  static String getReceipt(String id) => "${baseUrl}transactions/$id/receipt";
}
