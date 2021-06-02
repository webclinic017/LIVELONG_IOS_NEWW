import 'package:flutter/material.dart';
import 'package:livelong/Profile.dart';
import 'package:livelong/colors.dart';
import 'package:livelong/cources.dart';
import 'package:livelong/paper_trading_home.dart';

import 'Newsfeed.dart';



class Home extends StatefulWidget {
  static  int index;
  // This widget is the root of your application.
  @override
  _HomeState createState() => _HomeState();
}

  class _HomeState extends State<Home> {
  int _currentIndex = Home.index==null?0:Home.index;
  final List<Widget> _children = [
    NewsFeed(),
    Cources(),
    Profile(),
  ];
@override
  void initState() {
    // TODO: implement initState
    print(_currentIndex.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        color: bg,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex:_currentIndex,
            selectedItemColor: navbaricon,
            unselectedItemColor: inactivenavbar,
            backgroundColor:navbarbg,
            type: BottomNavigationBarType.fixed,// this will be set when a new tab is tapped
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                  icon: Container(height: 25,child: Image.asset('assets/images/Asset 39@4x.png',color: _currentIndex==0?navbaricon:inactivenavbar,)),
                  title: Text('Home')
              ),

              BottomNavigationBarItem(
                icon: Container(height: 25,child: Image.asset('assets/images/Asset 37@4x.png',color: _currentIndex==1?navbaricon:inactivenavbar,)),
                title: Text('Courses')
              ),

              BottomNavigationBarItem(
                  icon: Container(height: 25,child: Image.asset('assets/images/Asset 35@4x.png',color: _currentIndex==2?navbaricon:inactivenavbar,)),
                  title: Text('Profile')
              ),
            ],//
          ),
        ),
      ),
      //is trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
