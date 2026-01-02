class ServerConfig {
  static const baseUrl = "http://51.112.131.120/api/";
  // static const baseUrl = "http://192.168.1.13:4000/";
  // Below are the all api that are use in our system
  static const login = "${baseUrl}auth/signIn";
  static const register = "${baseUrl}auth/signUp";
  static const verifyOtp = "${baseUrl}auth/verifyOtp";
  static const refreshToken = "${baseUrl}auth/refreshToken";
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

  // Cutscenes
  static String getCutscenesByGame(String gameId) =>
      "${baseUrl}cutscenes/game/$gameId";
  static String getCutsceneById(String cutsceneId) =>
      "${baseUrl}cutscenes/$cutsceneId";

  // Suspects
  static String getSuspectsByGame(String gameId) =>
      "${baseUrl}suspects/game/$gameId";
  static String getSuspectById(String suspectId) =>
      "${baseUrl}suspects/$suspectId";

  // Evidences
  static String getEvidencesByGame(String gameId) =>
      "${baseUrl}evidences/game/$gameId";
  static String getEvidenceById(String evidenceId) =>
      "${baseUrl}evidences/$evidenceId";

  // Questions
  static String getQuestionsByGame(String gameId) =>
      "${baseUrl}questions/game/$gameId";
  static String getQuestionById(String questionId) =>
      "${baseUrl}questions/$questionId";

  // User Answers
  static const userAnswers = "${baseUrl}user-answers";

  // Game Sessions
  static String getGameSessionDetails(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId/details";
  static String getGameSessionById(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId";
  static String getGameSessionPlayers(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId/players";
  static String getGameSessionScoreboard(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId/scoreboard";
  static String getGameSessionResult(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId/result";
  static String getGameSessionStatus(String sessionId) =>
      "${baseUrl}game-sessions/$sessionId/status";

  // User Balance
  static const userBalance = "${baseUrl}games/balance";
}
