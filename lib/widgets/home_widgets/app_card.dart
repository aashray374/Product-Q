import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/consts.dart';

class AppCard extends StatelessWidget {
  const AppCard(this.productType, {super.key, this.isPurchased = true, required this.productName});

  final String productType;
  final bool isPurchased;
  final String productName;

  @override
  Widget build(BuildContext context) {
    final int pid = MyConsts.appTypes.indexOf(productType);
    print("product type is $pid");
    final deviceWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 15,
      child: Container(
        width: deviceWidth * 0.42,
        height: deviceWidth * 0.42,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [MyConsts.shadow1],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isPurchased
                    ? MyConsts.productColors[ productName == "Product Industry Trainer" ? 0: productName == "Product Interview Coach" ? 3 : pid ]
                    : [Colors.grey, Colors.grey])),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  productName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
                  //maxLines: 2,
                ),
              ),
              if (!isPurchased)
                const Positioned(
                  bottom: 12,
                  left: 0,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              Positioned(
                bottom: 8,
                right: 8,
                child: ColorFiltered(
                  colorFilter: isPurchased
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.saturation)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: SvgPicture.asset(
                    MyConsts.productIcons[productName == "Product Industry Trainer" ? 3: productName == "Product Interview Coach" ? 0 : pid ],
                    width: deviceWidth*0.11,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
