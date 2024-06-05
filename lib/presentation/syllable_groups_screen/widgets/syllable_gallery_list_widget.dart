import 'package:flutter/material.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/syllable_groups_controller.dart';
import 'syllabic_widget.dart';

class SyllableGroupList extends StatelessWidget {
  const SyllableGroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SyllableGroupsController>(builder: (controller) {
      return Skeletonizer(
        enabled: controller.isLoading.value,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 22.v, top: 39.v, right: 26.v),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// MONO Syllabic
                    SyllabicRowWidget(
                      SyllabicName: 'Mono',
                      SyllabicList: controller.Monosyllables,
                      SyllabicNumber: 1,
                    ),
                    SizedBox(height: 37.v,),
                    /// BI Syllabic
                    SyllabicRowWidget(
                      SyllabicName: 'Bi',
                      SyllabicList: controller.Bisyllables,
                      SyllabicNumber: 2,
                    ),
                    SizedBox(height: 37.v,),
                    /// TRI Syllabic
                    SyllabicRowWidget(
                      SyllabicName: 'Tri',
                      SyllabicList: controller.Trisyllables,
                      SyllabicNumber: 3,
                    ),
                    SizedBox(height: 37.v,),
                    /// Poly Syllabic
                    SyllabicRowWidget(
                      SyllabicName: 'Poly',
                      SyllabicList: controller.Polysyllables,
                      SyllabicNumber: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

