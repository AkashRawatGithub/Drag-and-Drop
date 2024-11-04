import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trello Card Slider',
      home: Scaffold(
          backgroundColor:Colors.black,
        body: SafeArea(child: UserDashboard()),
      ),
    );
  }
}

class CardContent {
  final String id;
  final String title;
  final String comp;
  final int investmentAmount;
  final int remainingInstallments;
  final int investedAmount;
  final int cycle;
  final int endsOn;
  final int estimatedReturn;

  CardContent({
    required this.id,
    required this.title,
    required this.comp,
    required this.investmentAmount,
    required this.remainingInstallments,
    required this.investedAmount,
    required this.cycle,
    required this.endsOn,
    required this.estimatedReturn,
  });
}

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<AnimatedListState> _listKey1 = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKey2 = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKey3 = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKey4 = GlobalKey<AnimatedListState>();

  List<CardContent> box1Items = [];
  List<CardContent> box2Items = [];
  List<CardContent> box3Items = [];
  List<CardContent> box4Items = [];

  final ScrollController _scrollController = ScrollController();
   Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    box1Items = fetchStaticPlans();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  var maincolor = Colors.green;
  var textcolor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDragTarget(1, "Your Investment", null, _listKey1, box1Items),
            SizedBox(width: 15),
            buildDragTarget(2, "Home", Icons.home_outlined, _listKey2, box2Items),
            SizedBox(width: 15),
            buildDragTarget(3, "Car", CupertinoIcons.car_detailed, _listKey3, box3Items),
            SizedBox(width: 15),
            buildDragTarget(4, "Education", CupertinoIcons.building_2_fill, _listKey4, box4Items),
          ],
        ),
      ),
    );
  }

  Widget buildDragTarget(
      int boxNumber,
      String title,
      IconData? icon,
      GlobalKey<AnimatedListState> listKey,
      List<CardContent> boxItems,
      ) {
    return DragTarget<CardContent>(
      onWillAccept: (_) {
        return true;
      },
      onAccept: (item) {
        if (!boxItems.contains(item)) {
          updatePreviousBoxItems(item);
          setState(() {
            boxItems.add(item);
            listKey.currentState?.insertItem(boxItems.length - 1);
          });
        }
      },
      builder: (context, accepted, rejected) {
        return buildContainerContent(title, icon, boxItems, listKey);
      },
    );
  }

  Widget buildContainerContent(String title, IconData? icon, List<CardContent> boxItems, GlobalKey<AnimatedListState> listKey) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: boxItems.isEmpty ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: title == "Your Investment" ? Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          buildTitleBar(title, icon),
          boxItems.isEmpty ? buildEmptyPlaceholder() : buildAnimatedList(listKey, boxItems),
        ],
      ),
    );
  }

  Widget buildTitleBar(String title, IconData? icon) {
    return Container(
      decoration: BoxDecoration(
        color: title == "Your Investment" ? maincolor : Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      padding: EdgeInsets.all(8.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) FaIcon(icon, color: Colors.grey),
          if (icon != null) SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: title == "Your Investment" ? Colors.white : textcolor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyPlaceholder() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_box_outlined, color: Colors.grey[400], size: 40),
            Text(
              "Add",
              style: GoogleFonts.poppins(color: Colors.grey[400], fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedList(GlobalKey<AnimatedListState> listKey, List<CardContent> boxItems) {
    return Expanded(
      child: AnimatedList(
        key: listKey,
        initialItemCount: boxItems.length,
        itemBuilder: (context, index, animation) => _buildAnimatedItem(context, boxItems[index], animation),
      ),
    );
  }

  void updatePreviousBoxItems(CardContent item) {
    removeItemFromBox(item, box1Items, _listKey1);
    removeItemFromBox(item, box2Items, _listKey2);
    removeItemFromBox(item, box3Items, _listKey3);
    removeItemFromBox(item, box4Items, _listKey4);
  }

  void removeItemFromBox(CardContent item, List<CardContent> boxItems, GlobalKey<AnimatedListState> listKey) {
    if (boxItems.contains(item)) {
      int index = boxItems.indexOf(item);
      boxItems.remove(item);
      listKey.currentState?.removeItem(index, (context, animation) => _buildAnimatedItem(context, item, animation));
    }
  }

  Widget _buildAnimatedItem(BuildContext context, CardContent content, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: LongPressDraggable<CardContent>(
        data: content,
        feedback: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(0.1), // Adjust this angle for the tilt (in radians)
          child: MfCards(content: content),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3, // Adjust the opacity value to control the fade effect
          child: MfCards(content: content),
        ),
        child: MfCards(content: content),
        onDragUpdate: (details) => autoScrollOnDrag(details),
        onDragEnd: (_) => stopAutoScroll(),
      ),
    );
  }

  void autoScrollOnDrag(DragUpdateDetails details) {
    const edgeScrollMargin = 50.0; // Distance from edge to trigger scrolling
    const scrollSpeed = 10.0; // Scroll speed for auto-scrolling

    // Check if drag is near the right edge
    if (details.globalPosition.dx > MediaQuery.of(context).size.width - edgeScrollMargin) {
      // Start scrolling to the right
      if (_scrollTimer == null || !_scrollTimer!.isActive) {
        _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
          if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
            _scrollController.jumpTo(
              _scrollController.position.pixels + scrollSpeed,
            );
          }
        });
      }
    }
    // Check if drag is near the left edge
    else if (details.globalPosition.dx < edgeScrollMargin) {
      // Start scrolling to the left
      if (_scrollTimer == null || !_scrollTimer!.isActive) {
        _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
          if (_scrollController.position.pixels > _scrollController.position.minScrollExtent) {
            _scrollController.jumpTo(
              _scrollController.position.pixels - scrollSpeed,
            );
          }
        });
      }
    } else {
      // Stop auto-scrolling when card is near the center
      stopAutoScroll();
    }
  }

  void stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }


  Widget MfCards({CardContent? content}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),


                  borderRadius:BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      topLeft: Radius.circular(5.0)
                  ),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        content!.comp.toString() ,
                        style: GoogleFonts.poppins(
                          color: textcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      Container(
                        color: maincolor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                          child: Text(
                            "STP",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: .1)
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: content.title=="Yours Investment"?Colors.white:Color(0xFFFAFAFA),
                    borderRadius:BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5)
                    )
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Investment Amount",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.investmentAmount.toString(),
                                style: GoogleFonts.poppins(
                                  color: textcolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Remaining Installments",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.remainingInstallments.toString(),
                                style: GoogleFonts.poppins(
                                  color: textcolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Invested Amount",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.investedAmount.toString(),
                                style: GoogleFonts.poppins(
                                  color: textcolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cycle",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.cycle.toString(),
                                style: GoogleFonts.poppins(
                                  color: textcolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Ends On",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.endsOn.toString(),
                                style: GoogleFonts.poppins(
                                  color: textcolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Estimated Return",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                content.estimatedReturn.toString(),
                                style: GoogleFonts.poppins(
                                  color: maincolor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CardContent> fetchStaticPlans() {
    return [
      CardContent(
        id: "1",
        title: "Investment Plan 1",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "7",
        title: "Investment Plan 7",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "6",
        title: "Investment Plan 6",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "5",
        title: "Investment Plan 5",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "4",
        title: "Investment Plan 4",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "3",
        title: "Investment Plan 33",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      CardContent(
        id: "2",
        title: "Investment Plan 2",
        comp: "Company A",
        investmentAmount: 5000,
        remainingInstallments: 3,
        investedAmount: 2000,
        cycle: 6,
        endsOn: 30,
        estimatedReturn: 1000,
      ),
      // Add more static plans if needed
    ];
  }
}