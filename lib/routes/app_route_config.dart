import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/models/answer.dart';
import 'package:product_iq/models/learning.dart';
import 'package:product_iq/models/worktool_skill.dart';
import 'package:product_iq/models/worktools_result.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/coach_screens/coach_home_screen.dart';
import 'package:product_iq/screens/coach_screens/coach_modules_screen.dart';
import 'package:product_iq/screens/coach_screens/module_details_screen.dart';
import 'package:product_iq/screens/coach_screens/module_report.dart';
import 'package:product_iq/screens/coach_screens/problem_screen.dart';
import 'package:product_iq/screens/coach_screens/success_screen.dart';
import 'package:product_iq/screens/crash_error_screen.dart';
import 'package:product_iq/screens/help_&_support_screen/help_&_support.dart';
import 'package:product_iq/screens/home_screen/app_screen.dart';
import 'package:product_iq/screens/home_screen/home_screen.dart';
import 'package:product_iq/screens/home_screen/payment_failure.dart';
import 'package:product_iq/screens/home_screen/payment_success.dart';
import 'package:product_iq/screens/home_screen/trending_screen3.dart';
import 'package:product_iq/screens/iq_screens/iq_onboarding_screen.dart';
import 'package:product_iq/screens/login/firebase_signup.dart';
import 'package:product_iq/screens/login/forgot_password_web.dart';
import 'package:product_iq/screens/profile_screens/edit_profile.dart';
import 'package:product_iq/screens/profile_screens/profile_screen.dart';
import 'package:product_iq/screens/home_screen/search_screen.dart';
import 'package:product_iq/screens/home_screen/splash_screen.dart';
import 'package:product_iq/screens/iq_screens/iq_home_screen.dart';
import 'package:product_iq/screens/iq_screens/learning_detail_screen.dart';
import 'package:product_iq/screens/login/login_screen.dart';
import 'package:product_iq/screens/login/signup_screen.dart';
import 'package:product_iq/screens/profile_screens/purchases_screen.dart';
import 'package:product_iq/screens/sales_screens/main_sales_screen.dart';
import 'package:product_iq/screens/sales_screens/payment_screen.dart';
import 'package:product_iq/screens/sales_screens/subsription_screen.dart';
import 'package:product_iq/screens/worktools_screens/card_details_screen.dart';
import 'package:product_iq/screens/worktools_screens/skill_gap_analysis.dart';
import 'package:product_iq/screens/worktools_screens/worktools_home_screen.dart';
import 'package:product_iq/screens/worktools_screens/worktools_onboarding_screen.dart';
import 'package:product_iq/services/app_service.dart';
import 'package:product_iq/widgets/home_widgets/navigation_widget.dart';
import 'package:product_iq/screens/coach_screens/review_screen.dart';
import 'package:product_iq/screens/iq_screens/learnings_screen.dart';

import '../screens/refer_&_earn_screen/refer_earn.dart';

class MyAppRouter {
  late final AppService appService;
  bool isOnboarded = false;

  GoRouter get router => _goRouter;

  MyAppRouter(this.appService);

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: MyAppRouteConst.homeRoute);
  static final _rootNavigatorApps =
      GlobalKey<NavigatorState>(debugLabel: MyAppRouteConst.appsRoute);
  static final _rootNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: MyAppRouteConst.profileRoute);
  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
          path: '/splash',
          name: MyAppRouteConst.splashRoute,
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: '/refer-earn',
          name: MyAppRouteConst.referEarnRoute,
          builder: (context, state) =>  ReferEarnScreen()),
      GoRoute(
          path: '/help-support',
          name: MyAppRouteConst.helpSupportRoute,
          builder: (context, state) =>  HelpSupportScreen()),
      GoRoute(
          path: '/sales',
          name: MyAppRouteConst.salesRoute,
          builder: (context, state) => MainSalesScreen(
                appService: appService,
              )),
      GoRoute(
          path: '/signup',
          name: MyAppRouteConst.signupRoute,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(
          path: '/signin',
          name: MyAppRouteConst.signinRoute,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/forgot-password',
          name: MyAppRouteConst.forgotPasswordRoute,
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
          path: '/search',
          name: MyAppRouteConst.searchRoute,
          builder: (context, state) => SearchScreen(
                searchResults: state.extra as Widget?,
              )),
      GoRoute(
          path: '/subscription',
          name: MyAppRouteConst.subscriptionRoute,
          builder: (context, state) => SubscriptionScreen(
                index: state.extra as int,
                //useless passed value
              )),
      GoRoute(
          path: '/additional-details',
          name: MyAppRouteConst.additionalDetailsRoute,
          builder: (context, state) => AdditionalDetailsScreen(
                userDetails: state.extra as Map<String, String?>,
                //useless passed value
              )),
      GoRoute(
          path: '/trending',
          name: MyAppRouteConst.trendingRoute,
          builder: (context, state) {
            Map<String, dynamic> args = state.extra as Map<String, dynamic>;
            return TrendingScreen3(
              headings: args['headings'],
              body: args['body'],
              buttonText: args['buttonText'],
              onTap: args['onTap'],
              appName: args['appName'],
            );
          }),
      GoRoute(
          path: '/payment',
          name: MyAppRouteConst.paymentRoute,
          builder: (context, state) =>
              StripePaymentScreen(state.extra as String)),
      GoRoute(
          path: '/payment-success',
          name: MyAppRouteConst.paymentSuccessRoute,
          builder: (context, state) => const PaymentSuccessScreen()),
      GoRoute(
          path: '/payment-failure',
          name: MyAppRouteConst.paymentFailureRoute,
          builder: (context, state) => const PaymentFailureScreen()),
      GoRoute(
          path: '/crash-error',
          name: MyAppRouteConst.crashErrorRoute,
          builder: (context, state) => const CrashErrorScreen()),
      GoRoute(
          path: '/apps/coach/review/:appId/:isPrevious/:completedPercent/:totalPercent',
          name: MyAppRouteConst.coachReviewRoute,
          builder: (context, state) => ReviewScreen(
            completedPercent: state.pathParameters['completedPercent']!,
            totalPercent : state.pathParameters['totalPercent']!,
                appId: int.parse(state.pathParameters['appId']!),
                answers: state.extra as List<Answer>,
                isOnlyPrevious: state.pathParameters['isPrevious'] == 'true',
              )),
      GoRoute(
          path: '/apps/coach/success',
          name: MyAppRouteConst.coachSuccessRoute,
          builder: (context, state) => const SuccessScreen()),
      GoRoute(
          path: '/result',
          name: MyAppRouteConst.coachResultRoute,
          builder: (context, state) => const ModuleReport()),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavigationWidget(
              navigationShell: navigationShell,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(navigatorKey: _rootNavigatorHome, routes: [
              GoRoute(
                  path: '/',
                  name: MyAppRouteConst.homeRoute,
                  builder: (context, state) => HomeScreen(
                        key: state.pageKey,
                      )),
            ]),
            StatefulShellBranch(navigatorKey: _rootNavigatorApps, routes: [
              GoRoute(
                  path: '/apps',
                  name: MyAppRouteConst.appsRoute,
                  builder: (context, state) => AppsScreen(
                        key: state.pageKey,
                      ),
                  routes: [
                    GoRoute(
                        path: 'coach/:appId',
                        name: MyAppRouteConst.coachRoute,
                        builder: (context, state) => CoachHomeScreen(
                              appId: int.parse(state.pathParameters['appId']!),
                            ),
                        routes: [
                          GoRoute(
                              path: 'modules',
                              name: MyAppRouteConst.coachModulesRoute,
                              builder: (context, state) => CoachModulesScreen(
                                    appId: int.parse(
                                        state.pathParameters['appId']!),
                                  ),
                              routes: [
                                GoRoute(
                                  path:
                                      'problem/:problemId/:moduleId/:problemTitle',
                                  name: MyAppRouteConst.coachProblemRoute,
                                  builder: (context, state) => ProblemScreen(

                                    appId: int.parse(
                                        state.pathParameters['appId']!),
                                    problem: state.extra as Map<String, dynamic>,
                                    // topics: state.extra['topics'] as List<dynamic>,
                                    problemTitle:
                                        state.pathParameters['problemTitle']!,
                                    problemId:
                                        state.pathParameters['problemId']!,
                                    moduleId: state.pathParameters['moduleId']!,
                                  ),
                                ),
                              ]),
                          GoRoute(
                              path: 'modules_info/:id/:moduleTitle/:completedPercent/:totalPercent',
                              name: MyAppRouteConst.coachModulesInfoRoute,
                              builder: (context, state) => ModuleDetailsScreen(
                                    appId: int.parse(
                                        state.pathParameters['appId']!),
                                    percent: state.extra as double,
                                    moduleTitle:
                                        state.pathParameters['moduleTitle']!,
                                    moduleId: state.pathParameters['id']!,
                                completedPercent:  int.parse(state.pathParameters['completedPercent']!),
                                totalPercent:  int.parse(state.pathParameters['totalPercent']!),
                                  )),
                        ]),
                    GoRoute(
                        path: 'worktools/:appId',
                        name: MyAppRouteConst.worktoolsRoute,
                        builder: (context, state) => WorktoolsHomeScreen(
                              appId: int.parse(state.pathParameters['appId']!),
                              initialCategory: state.extra as int? ?? 1,
                            ),
                        routes: [
                          GoRoute(
                              path: 'onboarding',
                              name: MyAppRouteConst.worktoolsOnboardingRoute,
                              builder: (context, state) =>
                                  WorktoolsOnboardingScreen(
                                    appId: int.parse(
                                        state.pathParameters['appId']!),
                                  )),
                          GoRoute(
                            path: 'card_details/:cardTitle/:id',
                            name: MyAppRouteConst.worktoolsDetailsRoute,
                            builder: (context, state) => CardDetailsScreen(
                              appId: int.parse(state.pathParameters['appId']!),
                              id: state.pathParameters['id']!,
                              cardTitle: state.pathParameters['cardTitle']!,
                              questions:
                                  state.extra as List<QuestionSuggestion>?,
                            ),
                          ),
                          GoRoute(
                            path: 'skill_gap_analysis/:title',
                            name:
                                MyAppRouteConst.worktoolsSkillGapAnalysisRoute,
                            builder: (context, state) => SkillGapAnalysis(
                                title: state.pathParameters['title']!,
                                result: state.extra as WorktoolsResult),
                          )
                        ]),
                    GoRoute(
                        path: 'iq/:appId',
                        name: MyAppRouteConst.iqRoute,
                        builder: (context, state) => IQHomeScreen(
                              appId: int.parse(state.pathParameters['appId']!),
                              initialSection: state.extra as int? ?? 1,
                            ),
                        routes: [
                          GoRoute(
                            path: 'onboarding',
                            name: MyAppRouteConst.iqOnboardingRoute,
                            builder: (context, state) =>
                                IqOnboardingScreen(appId: int.parse(state.pathParameters['appId']!),),
                          ),
                          GoRoute(
                            path: 'learnings/:index/:title',
                            name: MyAppRouteConst.iqLearningsRoute,
                            builder: (context, state) => LearningsScreen(
                              appId: int.parse(state.pathParameters['appId']!),
                                index: state.pathParameters['index']!,
                                title: state.pathParameters['title']!),
                          ),
                          GoRoute(
                            path: 'learnings_details/:index',
                            name: MyAppRouteConst.iqLearningsDetailRoute,
                            builder: (context, state) => LearningDetailScreen(
                                appId: int.parse(state.pathParameters['appId']!),
                                index:
                                    int.parse(state.pathParameters['index']!),
                                learnings: state.extra as List<Learning>),
                          )
                        ])
                  ]),
            ]),
            StatefulShellBranch(navigatorKey: _rootNavigatorProfile, routes: [
              GoRoute(
                  path: '/profile',
                  name: MyAppRouteConst.profileRoute,
                  builder: (context, state) => ProfileScreen(
                        key: state.pageKey,
                        reload: state.extra as bool?,
                      ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: MyAppRouteConst.editProfileRoute,
                      builder: (context, state) => EditProfileScreen(
                        details: state.extra as Map<String, String>,
                      ),
                    ),
                    GoRoute(
                        path: 'purchases',
                        name: MyAppRouteConst.purchasesRoute,
                        builder: (context, state) => PurchasesScreen()),
                  ]),
            ])
          ])
    ],
  );
}
