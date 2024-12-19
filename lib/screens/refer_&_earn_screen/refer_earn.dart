import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:product_iq/screens/refer_&_earn_screen/refer_earn_controller.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import '../../widgets/common_widgets/my_elevated_button.dart';

class ReferEarnScreen extends GetView<ReferEarnController> {
  // const EditProfileScreen({super.key, required this.details});
ReferEarnController controller = Get.put(ReferEarnController());
  // final Map<String,String> details;


  @override
  Widget build(BuildContext context) {
    controller.loadDetails();
    return MainAppScreen(
        title: "Refer & Earn",
        body: SafeArea(
          minimum: EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/elements/refer.png",width: 250,height: 250,),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Refer to grow with your community and save together #growTogether",
                      textAlign: TextAlign.center,
                      maxLines: null, // Allow the text to wrap and use multiple lines
                      overflow: TextOverflow.visible, // Ensure text overflow is visible if it exceeds the container
                      softWrap: true, // Allow text to wrap at word boundaries
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize:15,
                        color: MyConsts.productColors[3][0] ,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(left: 20,right: 20,top: 20,bottom: 10),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "When they sign up using your unique code, both of you will get 35% discount.",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      // Allow the text to wrap and use multiple lines
                      overflow: TextOverflow.visible, // Ensure text overflow is visible if it exceeds the container
                      softWrap: true, // Allow text to wrap at word boundaries
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize:12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(left: 30,right: 30,bottom: 20),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MyConsts.productColors[3][0].withOpacity(0.2),width: 1.5)
                ),
                child:Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                            () {
                        return Flexible(
                          child: Text(controller.name.value,maxLines: 1,softWrap: true,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),),
                        );
                      }
                    ),

                    TextButton(onPressed: (){
                      copyToClipboard(context);
                    }, child: Text("Copy",style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 16,
                        color: MyConsts.productColors[3][0].withOpacity(0.7), fontWeight: FontWeight.w500)))
                  ],
                ),
              ).paddingOnly(bottom: 20),
              MyElevatedButton(
                  shadow: MyConsts.shadow1,
                  width: double.infinity,colorFrom: MyConsts.primaryColorFrom,
                  colorTo: MyConsts.primaryColorTo,

                  child: const Text(
                    "Share",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: MyConsts.bgColor),
                  ),
                  onTap: () {
                    Share.share("Hey buddy, boost your product mindset with the ProductQ app with Self-paced learning, real-time skill report and get end-to-end product lifecycle experience. Use the code ${controller.name.value} to get a 35% discount now. \n Download the app here: https://www.productq.app/ ");
                    // Share.share("Hey buddy, boost your product mindset with the ProductQ app with Self-paced learning, real-time skill report and get end-to-end product lifecycle experience. Use the code ${controller.name} to get a 30% discount now. \n Download the app here: https://www.productq.app/ ");
                  }),
              // EditProfileForm(details: details,),
            ],
          ),
        ));
  }
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: controller.name.value)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Referral code copied to clipboard!')),
      );
    });
  }
}
