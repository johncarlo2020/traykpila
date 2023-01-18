import 'package:flutter/material.dart';
import 'package:traykpila/constant.dart';

class BookedDetails extends StatefulWidget {
  const BookedDetails({super.key});

  @override
  State<BookedDetails> createState() => _BookedDetailsState();
}

class _BookedDetailsState extends State<BookedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
        title: const Text(
          "Booking Details",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(37, 195, 108, 1.0)),
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.90,
              child: const Text('map here'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Color.fromARGB(169, 131, 243, 135),
                  borderRadius: BorderRadius.circular(6),
                  child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          image: AssetImage('assets/pasenger.png'),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    title: Text(
                      'Jhon lomero',
                      style: TextStyle(
                        fontSize: 20,
                        //COLOR DEL TEXTO TITULO
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    subtitle: Flexible(
                      child: Text('6th St. TODA (GREEN TRICYCLE TERMINAL)',
                          style: TextStyle(
                            fontSize: 11,
                            //COLOR DEL TEXTO TITULO
                            color: Color.fromARGB(255, 0, 151, 76),
                          )),
                    ),
                    trailing: Text(
                      '3',
                      style: TextStyle(
                        fontSize: 30,
                        //COLOR DEL TEXTO TITULO
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.width * 0.50,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        minimumSize: Size(100, 40), //////// HERE
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.message_outlined),
                          Text('Message')
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
