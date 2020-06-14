import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable.dart';
import 'package:plannusandroidversion/models/todo/todo_main.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/models/weekly_event_adder.dart';
import 'package:plannusandroidversion/screens/drawer/notification_page.dart';
import 'package:plannusandroidversion/screens/home/messages.dart';
import 'package:plannusandroidversion/screens/home/profile.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/screens/drawer/meet_page.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;
  var tabs = [];

  int currentIndex = 0;

  final AuthService auth = AuthService();

  String header = 'Home';

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if (user == null) {
      return Loading();
    } else {
      tabs = [
        StreamProvider<TodoData>.value(
            value: DatabaseMethods(uid: user.uid).getUserTodoDataStream(),
            child: Scaffold(backgroundColor: Colors.deepOrangeAccent[100],
<<<<<<< Updated upstream
                body: ToDoPage())),
=======
                body: ToDoPage()
            ),
          catchError: (context, e) {return new TodoData();},
        ),
>>>>>>> Stashed changes
        //home
        Provider<User>.value(value: user,
            child: Scaffold(
                backgroundColor: Colors.yellow, body: TimeTableWidget())),
        //TimeTable.emptyTimeTable()))),
        Provider<User>.value(value: user, child: Messages()),
        MultiProvider(providers: [
          StreamProvider<String>(
            create: (_) => DatabaseMethods(uid: user.uid).getHandleStream(),
            catchError: (context, e) { return "(no name yet)";}),
          Provider<User>(create: (_) => user)
        ], child: Profile()),
      ];
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.deepPurple,
          appBar: AppBar(
            title: Text(header,
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: Colors.black54,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add',
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Provider<User>.value(value: user, child: WeeklyEventAdder()),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        )
                      );
                    }
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              FlatButton.icon(
                  icon: Icon(Icons.person,
                    color: Colors.yellow,
                  ),
                  label: Text('logout',
                      style: TextStyle(color: Colors.yellow)
                  ),
                  onPressed: () async {
                    Constants.myName = null;
                    Constants.myHandle = null;
                    Constants.myProfilePhoto = null;
                    await auth.googleSignIn.isSignedIn().then((value) async {
                      if (value) {
                        AuthService.googleSignInAccount = null;
                        AuthService.googleUserId = null;
                        await auth.googleSignOut();
                      } else {
                        AuthService.currentUser = null;
                        await auth.signOut();
                      }
                    });
                  }
              )
            ],
          ),
          //********************DRAWER***********************//
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.deepOrange,
                      Colors.orangeAccent,
                    ])
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(image: AssetImage('assets/planNUS.png')),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                  child: InkWell(
                    splashColor: Colors.orange,
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                child: Provider<User>.value(value: user, child: MeetPage()),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))));
                          });
                    },
                    child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.people),
                          SizedBox(width: 20),
                          Text('Meet', style: TextStyle(fontSize: 20.0),)
                        ],
                      ),
                    )
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                    child: InkWell(
                        splashColor: Colors.orange,
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Provider<User>.value(
                                    value: user,
                                    child: NotificationPage(),
                                  ),
                                );
                              });
                        },
                        child: Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.notifications),
                                SizedBox(width: 20),
                                Text('Notifications', style: TextStyle(fontSize: 20.0),),
                                SizedBox(width: 100),
                                Text(user.unread.length.toString(),
                                    style: TextStyle(fontSize: 20.0, color: Colors.red[800]))
                              ],
                            )
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  child: InkWell(
                    splashColor: Colors.orange,
                    onTap: () {},
                    child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.settings),
                          SizedBox(width: 20),
                          Text('Settings', style: TextStyle(fontSize: 20.0),)
                        ],
                      )
                    )
                  )
                ),
              ],
            ),
          ),
          body: tabs[currentIndex],
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: currentIndex,
            showElevation: true,
            itemCornerRadius: 8,
            curve: Curves.easeInBack,
            onItemSelected: (index) =>
              setState(() {
                print(index); //remove
                currentIndex = index;
                switch (index) {
                  case 0: { header = 'Home'; } break;
                  case 1: { header = 'Timetable'; } break;
                  case 2: { header = 'Messages'; } break;
                  case 3: { header = 'Profile'; } break;
                }
              }
            ),
            backgroundColor: Colors.white,
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Home'),
                activeColor: Colors.red,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Timetable'),
                activeColor: Colors.purpleAccent,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages',
                ),
                activeColor: Colors.pink,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.perm_identity),
                title: Text('Profile'),
                activeColor: Colors.blue,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
