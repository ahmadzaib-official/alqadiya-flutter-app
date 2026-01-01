import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/auth/forgotpassword/forgetpassword_screen.dart';
import 'package:alqadiya_game/features/auth/forgotpassword/newPasswordScreen.dart';
import 'package:alqadiya_game/features/auth/otp_screen.dart';
import 'package:alqadiya_game/features/auth/signin_screen.dart';
import 'package:alqadiya_game/features/auth/signup_screen.dart';
import 'package:alqadiya_game/features/auth/verification_successful_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/add_case_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/case_detail_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/case_store_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/case_video_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/choose_team_leader_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/create_team_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/player_selection_screen.dart';
import 'package:alqadiya_game/features/casestore/screen/start_game_screen.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/screen/game_screen.dart';
import 'package:alqadiya_game/features/game/screen/suspect_detail_screen.dart';
import 'package:alqadiya_game/features/game/screen/suspects_list_screen.dart';
import 'package:alqadiya_game/features/game/screen/evidence_list_screen.dart';
import 'package:alqadiya_game/features/game/screen/clue_detail_screen.dart';
import 'package:alqadiya_game/features/game/screen/scoreboard_screen.dart';
import 'package:alqadiya_game/features/game/screen/game_result_summary_screen.dart';
import 'package:alqadiya_game/features/notifcation/screen/notifications_list_screen.dart';
import 'package:alqadiya_game/features/payment/controller/payment_provider.dart';
import 'package:alqadiya_game/features/settings/controller/settings_provider.dart';
import 'package:alqadiya_game/features/transactions/screen/transactions_list_screen.dart';
import 'package:alqadiya_game/features/settings/screen/settings_screen.dart';
import 'package:alqadiya_game/features/buy_points/screen/buy_points_screen.dart';
import 'package:alqadiya_game/features/payment/screen/payment_screen.dart';
import 'package:alqadiya_game/features/payment/screen/payment_done_screen.dart';
import 'package:alqadiya_game/features/home/screen/home_screen.dart';
import 'package:alqadiya_game/features/joingame/screen/join_game_screen.dart';
import 'package:alqadiya_game/features/onboard/controller/onbording_controller.dart';
import 'package:alqadiya_game/features/onboard/onboarding_screen.dart';
import 'package:alqadiya_game/features/splash/controller/splash_controller.dart';
import 'package:alqadiya_game/features/splash/splash_screen.dart';
import 'package:alqadiya_game/features/tutorial/screen/tutorial_screen.dart';
import 'package:alqadiya_game/features/transactions/screen/transaction_receipt_screen.dart';
import 'package:alqadiya_game/features/notifcation/controller/notifications_provider.dart';
import 'package:alqadiya_game/features/transactions/controller/transactions_provider.dart';
import 'package:alqadiya_game/features/transactions/controller/transaction_receipt_controller.dart';
import 'package:alqadiya_game/features/buy_points/controller/buy_points_provider.dart';
import 'package:alqadiya_game/features/auth/controller/signup_controller.dart';
import 'package:alqadiya_game/features/home/controller/home_controller.dart';
import 'package:alqadiya_game/features/joingame/controller/join_game_controller.dart';
import 'package:alqadiya_game/features/casestore/controller/add_case_controller.dart';
import 'package:alqadiya_game/features/casestore/controller/player_selection_controller.dart';
import 'package:alqadiya_game/features/casestore/controller/choose_team_leader_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_result_provider.dart';
import 'package:alqadiya_game/features/game/controller/scoreboard_provider.dart';
import 'package:alqadiya_game/features/game/controller/suspect_detail_provider.dart';
import 'package:alqadiya_game/features/game/controller/clue_detail_provider.dart';
import 'package:alqadiya_game/features/game/controller/cutscene_controller.dart';
import 'package:alqadiya_game/features/game/controller/question_controller.dart';
import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';
import 'package:alqadiya_game/features/game/controller/suspect_controller.dart';
import 'package:alqadiya_game/features/game/controller/evidence_controller.dart';
import 'package:alqadiya_game/features/payment/controller/payment_done_provider.dart';
import 'package:alqadiya_game/features/change_language/controller/language_controller.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(fenix: true, () => SplashController());
        }),
      ],
    ),
    GetPage(
      name: AppRoutes.tutorial,
      page: () => const TutorialScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.onbordingScreen,
      page: () => OnboardingScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(fenix: true, () => OnboardingController());
        }),
      ],
    ),
    GetPage(
      name: AppRoutes.sigin,
      page: () => SigninScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignupScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => SignupController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => const OtpScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.verifcationSussesfulscreen,
      page: () => const VerificationSuccessfulScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgetpasswordScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),

    GetPage(
      name: AppRoutes.newPasswordScreen,
      page: () => NewPasswordScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.homescreen,
      page: () => HomeScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => HomeController());
          Get.lazyPut(() => UserController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.caseStoreScreen,
      page: () => CaseStoreScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(fenix: true, () => GameController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.caseDetailScreen,
      page: () => CaseDetailScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.addCaseScreen,
      page: () => AddCaseScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => AddCaseController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.startGameScreen,
      page: () => StartGameScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.createTeamScreen,
      page: () => CreateTeamScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.playerSelectionScreen,
      page: () => PlayerSelectionScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => PlayerSelectionController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.chooseTeamLeaderScreen,
      page: () => ChooseTeamLeaderScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => ChooseTeamLeaderController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.joinGameScreen,
      page: () => JoinGameScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => JoinGameController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),

    GetPage(
      name: AppRoutes.caseVideoScreen,
      page: () => CaseVideoScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => CutsceneController());
          Get.lazyPut(fenix: true, () => GameController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.gameScreen,
      page: () => GameScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => QuestionController());
          Get.lazyPut(() => UserAnswerController());
          Get.lazyPut(fenix: true, () => GameController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.suspectDetailScreen,
      page: () => SuspectDetailScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => SuspectController());
          Get.lazyPut(() => SuspectDetailController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.suspectsListScreen,
      page: () => SuspectsListScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => SuspectController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.evidenceListScreen,
      page: () => EvidenceListScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => EvidenceController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.clueDetailScreen,
      page: () => ClueDetailScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => EvidenceController());
          Get.lazyPut(() => ClueDetailController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.scoreboardScreen,
      page: () => ScoreboardScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => ScoreboardController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.gameResultSummaryScreen,
      page: () => GameResultSummaryScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => GameResultController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.notificationsListScreen,
      page: () => NotificationsListScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => NotificationsController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.transactionsListScreen,
      page: () => TransactionsListScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => TransactionsController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => SettingsScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => SettingsController());
          Get.lazyPut(() => UserController());
          Get.lazyPut(() => ChangeLanguageController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.buyPointsScreen,
      page: () => BuyPointsScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => BuyPointsController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.paymentScreen,
      page: () => PaymentScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => PaymentController());
        }),
      ],
      // transition: Transition.circularReveal,
      // transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.paymentDoneScreen,
      page: () => PaymentDoneScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => PaymentDoneController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.transactionReceiptScreen,
      page: () => const TransactionReceiptScreen(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut(() => TransactionReceiptController());
        }),
      ],
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 600),
    ),
  ];
}
