import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:orthoappflutter/widgets/common/app_logo_widget.dart';
import '../../../core/utils/validation_functions.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../controller/login_controller.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:orthoappflutter/widgets/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  /// Initialize the login controller
  final LoginController controller = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// Access theme and media query data
    final theme = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 31.h, vertical: 63.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo and title section
                AppLogo(),
                SizedBox(height: 14.v),
                Padding(
                  padding: EdgeInsets.only(left: 14.h),
                  child: Text(
                    "lbl_login".tr,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 20.v),

                /// Information message
                Container(
                  width: 286.h,
                  margin: EdgeInsets.only(left: 14.h, right: 25.h),
                  child: Text(
                    "msg_please_confirm_your".tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodyLargeSecondaryContainer
                        .copyWith(height: 1.37),
                  ),
                ),
                SizedBox(height: 61.v),

                /// Country code and phone number input
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.h),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _showCountryPicker(context),
                        child: Column(
                          children: [
                            /// Selected country code
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 3.h,
                                    top: 2.v,
                                    bottom: 5.v,
                                  ),
                                  child: Obx(() => Text(
                                        "+${controller.selectedCountry.value}",
                                        style: CustomTextStyles.bodyLargeLight,
                                      )),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgMdiArrowDownDrop,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  margin: EdgeInsets.only(
                                    left: 10.h,
                                    right: 6.h,
                                    bottom: 3.v,
                                  ),
                                ),
                              ],
                            ),
                            // Divider line
                            Container(
                              height: 1.v,
                              width: 70.h,
                              decoration: BoxDecoration(
                                color: appTheme.blueGray100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Phone number input field
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 18.h,
                            top: 2.v,
                          ),
                          child: CustomTextFormField(
                            width: 210.h,
                            controller: controller.phoneNumberController,
                            hintText: "lbl_mobile_number".tr,
                            hintStyle: CustomTextStyles.bodyLargeBluegray400,
                            textInputType: TextInputType.phone,
                            onTextChanged: (value) {
                              print(value.length);
                              if (value.length == 10) {
                                controller.updateEnableBtn();
                              } else {
                                controller.updateDisableBtn();
                              }
                            },
                            validator: (value) {
                              if (!isValidPhone(value)) {
                                return "err_msg_please_enter_valid_phone_number".tr;
                              }
                              return null;
                            },

                            borderDecoration:
                                TextFormFieldStyleHelper.underLineBlueGray,
                            filled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 38.v),

                /// Login button
                Obx(() => controller.isLoginButtonEnabled.value
                    ? CustomElevatedButton(
                  text: "lbl_login2".tr,
                  buttonStyle: CustomButtonStyles.fillPrimaryTL25,
                  buttonTextStyle:
                  CustomTextStyles.titleMediumWhiteA700_1,
                  onPressed: () {
                    controller.handleLogin(Get.context!);
                  },
                )
                    : Opacity(
                  opacity: 0.3,
                  child: CustomElevatedButton(
                    text: "lbl_login2".tr,
                    buttonStyle: CustomButtonStyles.fillPrimaryTL25,
                    buttonTextStyle:
                    CustomTextStyles.titleMediumWhiteA700_1,
                    onPressed: () {},
                  ),
                )),


                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Method to show the country picker
  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      showWorldWide: false,
      useSafeArea: true,
      searchAutofocus: true,
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        print('Select country: ${country.phoneCode}');
        controller.updateCode(country.phoneCode);
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.zero,
        inputDecoration: InputDecoration(
          hintText: 'Search',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: appTheme.blueGray100,
            ),
          ),
        ),
        searchTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.fSize,
        ),
        padding: EdgeInsets.all(16.h),
      ),
    );
  }
}


