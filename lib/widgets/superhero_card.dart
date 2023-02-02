import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superhero_colors.dart';
import 'package:superheroes/resources/superhero_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: SuperheroColors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              color: Colors.white24,
              child: CachedNetworkImage(
                imageUrl: superheroInfo.imageUrl,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) {
                  return Container(
                    alignment: Alignment.center,
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: SuperheroColors.blue,
                      value: progress.progress,
                    ),
                  );
                },
                errorWidget: (context, url, progress) {
                  return Center(
                    child: Image.asset(
                      SuperheroImages.unknown,
                      height: 62,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superheroInfo.name.toUpperCase(),
                    style: const TextStyle(
                      color: SuperheroColors.whiteText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    superheroInfo.realName,
                    style: const TextStyle(
                      color: SuperheroColors.whiteText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
