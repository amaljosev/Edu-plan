import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget {
  Widget classDataLoadingShimmer() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: appbarColor,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          height: 200,
          width: double.infinity,
          child: ShimmerWidget.rectangular(
              isRound: false,
              height: 200,
              baseColor: appbarColor,
              highlightColor: Colors.purple.shade50)));
  Widget studentCircleShimmer() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              child: ShimmerWidget.circular(
                  isRound: true,
                  height: 40,
                  width: 40,
                  baseColor: appbarColor,
                  highlightColor: Colors.purple.shade50),
            ),
          ),
        ),
      ));
  Widget studentHomeLoading(Size size) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.05,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Colors.indigo.shade100,
                highlightColor: Colors.indigo.shade50,
                child: const CircleAvatar(
                  radius: 60,
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(35.0),
              child: SizedBox(
                height: size.height * 0.25,
                width: double.infinity,
                child: ListView.separated(
                    itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Colors.indigo.shade100,
                        highlightColor: Colors.indigo.shade50,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 122, 109, 109),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          height: 25,
                          width: 80,
                        )),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15, 
                        ),
                    itemCount: 5),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.indigo.shade100,
                      highlightColor: Colors.indigo.shade50,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 120,
                        width: 120,
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.indigo.shade100,
                      highlightColor: Colors.indigo.shade50,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 120,
                        width: 120,
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: size.height * 0.01,
                    width: double.infinity,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.indigo.shade100,
                      highlightColor: Colors.indigo.shade50,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 120,
                        width: 120,
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.indigo.shade100,
                      highlightColor: Colors.indigo.shade50,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 120,
                        width: 120,
                      )),
                ],
              ),
              Container(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
