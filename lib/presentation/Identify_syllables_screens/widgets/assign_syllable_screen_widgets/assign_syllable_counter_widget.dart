import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../controller/image_gallery_controller.dart';

class CounterWidget extends StatelessWidget {
  final ImageGalleryController _controller = Get.put(ImageGalleryController());
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        /// Check if the keyboard is visible
        if (!isKeyboardVisible) {
          /// Unfocus the focus node and reset keypad visibility on keyboard hide
          _focusNode.unfocus();
          _controller.shouldKeyPad.value = false;
          /// Scroll to the top when the keyboard hides
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          });
        }
        return GetBuilder<ImageGalleryController>(
          builder: (controller) {
            return SizedBox(
              height: 273.v,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  /// Preview image
                  CustomImageView(
                    imagePath: ImageConstant.imgRectangle163,
                    height: 114.v,
                    width: 360.h,
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 42.v),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 88.v,
                      width: 206.h,
                      child: Row(
                        children: [
                          /// Decrease counter button
                          CustomIconButton(
                            height: 30.adaptSize,
                            width: 30.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            onTap: () => _decrementCounter(),
                            decoration: IconButtonStyleHelper.fillIndigoA,
                            child: CustomImageView(
                              imagePath: 'assets/images/minus.svg',
                            ),
                          ),
                          /// Counter display, editable when keypad is visible
                          Obx((){
                            return Expanded(
                              child: InkWell(
                                onTap: () => _toggleCounterEdit(),
                                child: _controller.shouldKeyPad.value
                                    ? _buildEditableCounter()
                                    : _buildStaticCounter(),
                              ),
                            );
                          }),
                          /// Increase counter button
                          CustomIconButton(
                            height: 30.adaptSize,
                            width: 30.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            onTap: () => _incrementCounter(),
                            decoration: IconButtonStyleHelper.fillIndigoA,
                            child: CustomImageView(
                              imagePath: 'assets/images/img_plus.svg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds the editable counter text field
  Widget _buildEditableCounter() {
    return TextField(
      controller: _controller.textController,
      onChanged: (val) {
        _controller.counter.value = int.parse(val);
        _controller.updateOnTapValue();
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0XFF222222),
        fontSize: 85.fSize,
        fontWeight: FontWeight.w400,
      ),
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  /// Builds the static counter text or displays the counter value
  Widget _buildStaticCounter() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "${_controller.imageGalleryList[_controller.selectedImgIndex.value].onTap.toString()}",
        style: TextStyle(
          fontSize: 85.fSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Toggles the counter edit mode
  void _toggleCounterEdit() {
    _controller.updateVal(true);
  }

  /// Decrements the counter value
  void _decrementCounter() {
    _focusNode.unfocus();
    _controller.shouldKeyPad.value = false;
    if (_controller.counter == 0) {
      print('not clicked');
    } else {
      _controller.shouldKeyPad.value = false;
      _controller.counter--;
      _controller.textController.text = _controller.counter.toString();
      _controller.updateOnTapValue();
    }
  }

  /// Increments the counter value
  void _incrementCounter() {
    _focusNode.unfocus();
    _controller.shouldKeyPad.value = false;
    if (_controller.counter.value > 8) {
      /// Handle maximum counter value
    } else {
      _controller.counter++;
      _controller.textController.text = _controller.counter.toString();
      _controller.updateOnTapValue();
    }
  }
}
