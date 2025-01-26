import 'package:flutter/cupertino.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class NoResultSearch extends StatelessWidget {
  final String initialContext;
  const NoResultSearch({Key? key, required this.initialContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    
          SizedBox(height: 60,),
    
          Text('No result, show a sleek image here!', style: AppThemeConstants.APP_HEADING_TEXT,),
    
        ],
      ),
    );
  }
}