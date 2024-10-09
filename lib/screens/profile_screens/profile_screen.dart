
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/services/recently_visited_provider.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:product_iq/widgets/profile_widgets/profile_info.dart';
import 'package:product_iq/widgets/profile_widgets/profile_options.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.reload});

  final bool? reload;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String name = '';
  String phoneNum = '';
  String email = '';
  String jobTitle = '';
  String company = '';
  bool loggingOut = false;

  @override
  void initState() {
    loadDetails();
    super.initState();
  }

  void loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNum = prefs.getString('phone_no') ?? '';
      jobTitle = prefs.getString('job_title') ?? '';
      company = prefs.getString('company') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reload ?? false) {
      loadDetails();
    }
    return MainAppScreen(
        title: "Profile",
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(

                  children: [
                    Column(children: [
                      Container(
                        width: 88,
                        height: 88,
                        //decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(100),
                        // border: Border.all(
                        //     color: MyConsts.primaryColorTo, width: 3)),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: //random for each user
                              const Color(0xFFF8D082),
                          child: Text(
                            name.isEmpty ? 'A' : name[0],
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: MyConsts.primaryDark,
                                  fontSize: 40,
                                ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: MyConsts.primaryDark,
                            fontWeight: FontWeight.w600),
                      )
                    ]),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(jobTitle.isNotEmpty || company.isNotEmpty)
                        ProfileInfo(icon: Icons.work, text: "$jobTitle $company"),
                        if(jobTitle.isNotEmpty || company.isNotEmpty)
                        const SizedBox(
                          height: 4,
                        ),
                        if(phoneNum.isNotEmpty)
                        ProfileInfo(icon: Icons.phone, text: phoneNum),
                        if(phoneNum.isNotEmpty)
                        const SizedBox(
                          height: 4,
                        ),
                        ProfileInfo(icon: Icons.mail, text: email),
                      ],
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 12,
                // ),
                // MyElevatedButton(
                //     width: double.infinity,
                //     colorFrom: MyConsts.primaryColorFrom,
                //     colorTo: MyConsts.primaryColorTo,
                //     child: Text(
                //       "APT",
                //       style: Theme.of(context).textTheme.bodyLarge,
                //     ),
                //     onTap: () {}),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Options",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20, color: MyConsts.primaryDark),
                ),
                const SizedBox(
                  height: 12,
                ),
                for (int option = 0;
                    option < MyConsts.settingsOptions.length;
                    ++option)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ProfileOptions(
                        onTap: () {
                          if (option == 0) {
                            GoRouter.of(context)
                                .pushNamed(MyAppRouteConst.purchasesRoute);
                          }
                          if (option == 1) {
                            GoRouter.of(context).pushNamed(
                                MyAppRouteConst.editProfileRoute,
                                extra: {
                                  'name': name,
                                  'email': email,
                                  'phone_no': phoneNum,
                                  'company': company,
                                  'job_title': jobTitle
                                });
                          }
                          if (option == 2) {
                            GoRouter.of(context)
                                .pushNamed(MyAppRouteConst.referEarnRoute);
                          }
                          if (option == 3) {
                            GoRouter.of(context)
                                .pushNamed(MyAppRouteConst.helpSupportRoute);
                          }

                        },
                        icon: MyConsts.settingsOptionsIcons[option],
                        text: MyConsts.settingsOptions[option]),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ProfileOptions(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text(
                                  "Are you sure ?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: MyConsts.primaryDark),
                                ),
                                content: Text("Do you want to log out ?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: MyConsts.primaryDark)),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          loggingOut = true;
                                        });
                                        //String token = '';
                                        MyConsts.token = '';
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        String token = prefs.getString('token') ?? '';
                                        debugPrint(token);
                                        await prefs.clear();
                                        final logoutUrl = Uri.parse(
                                            "${MyConsts.baseUrl}/auth/logout");
                                        http.Response response = await http
                                            .post(logoutUrl, headers: {
                                          'Content-type': 'application/json',
                                          'Authorization': 'bearer $token'
                                        });

                                        debugPrint(response.body);
                                        ref.read(recentlyVisitedProvider.notifier).removeRecentlyVisited();
                                        GoRouter.of(context).goNamed(
                                            MyAppRouteConst.signinRoute);
                                      },
                                      child: loggingOut
                                          ? const CircularProgressIndicator()
                                          : const Text("Yes")),
                                  TextButton(
                                      onPressed: () {
                                        GoRouter.of(ctx).pop();
                                      },
                                      child: const Text("No")),
                                ],
                              ));
                    },
                    icon: Icons.logout_outlined,
                    text: "Log Out",
                    textColor: MyConsts.primaryColorTo,
                    showArrow: false,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
