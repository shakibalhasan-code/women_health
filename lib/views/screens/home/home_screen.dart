import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_history_graph.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_cycle_phase_view.dart';
import 'package:menstrual_cycle_widget/utils/enumeration.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.5)
              ]),
            ),
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person,color: Colors.white),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Congratulations',style: AppTheme.titleSmall.copyWith(color: Colors.white),),
                      Text('You\'r next period on 26Feb',style: AppTheme.titleSmall.copyWith(color: Colors.white),),

                    ],
                  ),
                  const Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white))
                ],
              ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Nirbhoya',style: AppTheme.titleLarge,),
      centerTitle: true,
      leading: const SizedBox(),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.person))
      ],
    );
  }
}
