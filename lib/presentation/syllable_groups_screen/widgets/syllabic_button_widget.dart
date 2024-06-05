import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import '../../../theme/app_decoration.dart';
import '../controller/syllable_groups_controller.dart';

class SyllabicButtonWidget extends StatelessWidget {
  /// Variables Declarations
  String syllabicType;
  String imageId;

  /// Constructor to initialize variables
  SyllabicButtonWidget({
    required this.syllabicType,
    required this.imageId,
  });

  /// Create instance of SyllableGroupsController
  SyllableGroupsController syllableGroupsController = SyllableGroupsController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: syllabicType == 'Mono'
          ? _buildMonoSyllabicButtons(context)
          : syllabicType == 'Bi'
          ? _buildBiSyllabicButtons(context)
          : syllabicType == 'Tri'
          ? _buildTriSyllabicButtons(context)
          : _buildPolySyllabicButtons(context),
    );
  }

  /// Widget to build Mono Syllabic Buttons
  Widget _buildMonoSyllabicButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _syllabicButton(
              context,
              text: 'BI SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(2, imageId, context),
            ),
            _syllabicButton(
              context,
              text: 'TRI SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(3, imageId, context),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Center(
          child: _syllabicButton(
            context,
            text: 'POLY SYLLABIC',
            onTap: () => syllableGroupsController.uploadSyllable(4, imageId, context),
          ),
        ),
      ],
    );
  }

  /// Widget to build Bi Syllabic Buttons
  Widget _buildBiSyllabicButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _syllabicButton(
              context,
              text: 'MONO SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(1, imageId, context),
            ),
            _syllabicButton(
              context,
              text: 'TRI SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(3, imageId, context),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Center(
          child: _syllabicButton(
            context,
            text: 'POLY SYLLABIC',
            onTap: () => syllableGroupsController.uploadSyllable(4, imageId, context),
          ),
        ),
      ],
    );
  }

  /// Widget to build Tri Syllabic Buttons
  Widget _buildTriSyllabicButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _syllabicButton(
              context,
              text: 'MONO SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(1, imageId, context),
            ),
            _syllabicButton(
              context,
              text: 'BI SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(2, imageId, context),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Center(
          child: _syllabicButton(
            context,
            text: 'POLY SYLLABIC',
            onTap: () => syllableGroupsController.uploadSyllable(4, imageId, context),
          ),
        ),
      ],
    );
  }

  /// Widget to build Poly Syllabic Buttons
  Widget _buildPolySyllabicButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _syllabicButton(
              context,
              text: 'MONO SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(1, imageId, context),
            ),
            _syllabicButton(
              context,
              text: 'BI SYLLABIC',
              onTap: () => syllableGroupsController.uploadSyllable(2, imageId, context),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Center(
          child: _syllabicButton(
            context,
            text: 'TRI SYLLABIC',
            onTap: () => syllableGroupsController.uploadSyllable(3, imageId, context),
          ),
        ),
      ],
    );
  }

  /// Widget to build Syllabic Buttons
  Widget _syllabicButton(BuildContext context,
      {required String text, required VoidCallback onTap}) {
    return Material(
      child: InkWell(
        splashColor: Color(0xffDEDCDCFF),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 36.h,
          width: 120.v,
          margin: EdgeInsets.symmetric(horizontal: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 10.v),
          decoration: AppDecoration.outlineLightBlue.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder5,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.fSize,
              color: Color(0xFF2684FF),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

