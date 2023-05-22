import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/controller/auth_controller.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/view/base/custom_small_button.dart';
import 'package:six_cash/view/screens/onboarding/chose_login_registration/widget/indicator_section.dart';

class ChoiceScreen extends StatelessWidget {
  ChoiceScreen({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.getWhiteAndBlack(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 15,
                  child: PageView.builder(
                      itemCount: AppConstants.onboardList.length,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (page) {
                        Get.find<AuthController>().change(page);
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                            Container(
                              height: size.width,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Image.asset(
                                      AppConstants.onboardList[index].backgroundImage,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.width * 0.6,
                                        child: Image.asset(AppConstants.onboardList[index].image, fit: BoxFit.fitHeight))
                                  )
                                ],
                              ),
                            ),
                              Spacer(),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Column(
                                  children: [
                                    Text(AppConstants.onboardList[index].title, style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,), textAlign: TextAlign.center,),
                                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.RADIUS_SIZE_SMALL),
                                      child: Text(AppConstants.onboardList[index].subtitle, maxLines: 2,overflow: TextOverflow.ellipsis, style: rubikMedium.copyWith(color: ColorResources.getOnboardGreyColor(), fontSize: Dimensions.FONT_SIZE_LARGE,), textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
                            ],
                          ),
                        );
                      }),
                ),

                IndicatorSection(),
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              ],
            ),

          ),
          Column(
            children: [
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: rubikRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                      ),
                      text: 'by_proceeding_you'.tr,
                    ),
                    TextSpan(
                      style: rubikRegular.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        decoration: TextDecoration.underline,

                      ),
                      text: 'privacy_policy'.tr,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async => Get.toNamed(RouteHelper.privacy),
                    ),

                  ],
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              Container(
                width: context.width * 0.7,
                padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, right: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                child: CustomSmallButton(
                  onTap: () => Get.toNamed(RouteHelper.getRegistrationRoute()),
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  text: 'login_registration'.tr,
                  textColor:Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
