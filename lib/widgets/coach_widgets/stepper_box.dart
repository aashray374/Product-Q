import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class StepperBox extends StatelessWidget {
  const StepperBox(
      {super.key,this.apptitle,required this.isCompleted, required this.title, required this.subtitle, this.rating, required this.isLocked});
  final String title;
  final bool isCompleted;
  final String subtitle;
  final String ?apptitle;
  final double? rating;
  final bool isLocked;

  Color getColorByRating(double rating) {
    if (rating <= 0.5) {
      return MyConsts.primaryRed;
    }
    if (rating <= 0.75) {
      return MyConsts.primaryOrange;
    }
    return MyConsts.primaryGreen;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color:apptitle=="Product Industry Trainer"? MyConsts.productColors[0][0].withOpacity(isLocked ? 0.7 : 1):MyConsts.productColors[3][0].withOpacity(isLocked ? 0.7 : 1),

          // color: MyConsts.productColors[3][0].withOpacity(isLocked ? 0.7 : 1),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(left: 64.0, top: 18, bottom: 18, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 170,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                  ),
                ),
                if(isLocked)
                  const Icon(Icons.lock, color: Colors.white, size: 20,)
                else
                     /*rating == null || rating == 0.0 */isCompleted == false ?SizedBox(): Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: 38,height: 20,
                  child: Text( rating.toString(),style: TextStyle(fontWeight: FontWeight.w600,color: getColorByRating(double.parse(rating.toString())/10),fontSize: 12),),
                  )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
