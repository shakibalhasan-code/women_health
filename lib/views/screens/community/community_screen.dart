import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';

import '../../../utils/helper/app_helper.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community',style: AppTheme.titleLarge),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                color: Colors.grey.shade100,
                border: Border.all(width: 0.5,color: Colors.grey)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [

                        ///icon of person
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                            child: Image.asset(AppConstant.avatarIcon,fit: BoxFit.cover,),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ///text-field
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'What\'s on your mind ?',
                                  hintStyle: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                maxLines: 2,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    MyButton(onTap: (){}, child: Text('Ask Now',style: AppTheme.titleMedium.copyWith(color: Colors.white,fontWeight: FontWeight.bold)))
                  ],
                )
              ),
            ),
            const SizedBox(height: 8),
            Text('Latest Questions',style: AppTheme.titleMedium),
            Expanded(child: ListView.builder(
              itemCount: 15,
                itemBuilder: (context,index){
              return Container(
                height: 150,
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                  color: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///icon of person
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                                child: Image.asset(AppConstant.avatarIcon,fit: BoxFit.cover,),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tasa Rehman',style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Expanded(child: Text('Recent i have faced some physical issue on my body, idk how to resolve it, please help. My age around 21 living at dhaka city',style: AppTheme.titleSmall.copyWith(color: Colors.black)))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(height: 0.5,color: Colors.grey,),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          build_post_action('Support',HeroIcons.handThumbUp),
                          build_post_action('Reply',HeroIcons.chatBubbleBottomCenter),
                          build_post_action('Share',HeroIcons.share),
                        ],
                      )

                    ],
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }

  Row build_post_action(String text, HeroIcons heroIcons) {
    return Row(
                          children: [
                            HeroIcon(heroIcons,color: Colors.grey,size: 16),
                            const SizedBox(width: 5),
                            Text(text,style: AppTheme.titleSmall)
                          ],
                        );
  }
}
