import 'package:flutter/material.dart';
import '../home.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<Details> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          },
          style: TextButton.styleFrom(
            primary: Color.fromARGB(255, 255, 255, 255),
            // Background Color
          ),
          icon: Icon(
            Icons.arrow_back,
            size: 24.0,
          ),
        ),
        title: const Text(
          "Booking Details",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/map.png',
                        width: 100,
                        height: 250.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 199.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    40, 40, 40, 10),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(
                                        color: Color(0xFF00AF00),
                                        width: 3,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.location_history_sharp,
                                      color: Color(0xFF00AF00),
                                      size: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF00AC00),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  40, 40, 40, 10),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                    border: Border.all(
                                      color: Color(0xFF00AF00),
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_history_sharp,
                                    color: Color(0xFF00AF00),
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Vehicle',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF00AF00),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 50),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(2, 5, 2, 2),
                        child: Text(
                          'Name: Mang jose',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF00AF00),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(2, 5, 2, 2),
                        child: Text(
                          'Body #: 221b',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF00AC00),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text(
                        'Terminal: 6th St. TODA (GREEN TRICYCLE TERMINAL)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF00AC00),
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Phone: 09232324356',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF00AC00),
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                ),
                label: const Text('Message'),
                icon: const Icon(Icons.message),
              )
            ],
          ),
        ],
      ),
    );
  }
}
