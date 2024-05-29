import 'package:cuttack/presentation/resources/generalFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GeneralFunction generalFunction = GeneralFunction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Puri One',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.titleSmall,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: Colors.white),
          ),
          // title: Text('Puri One'),
          centerTitle: true,
        ),
        drawer: generalFunction.drawerFunction(context, 'Soyab Ali', '9871950881'),
        body: Stack(
          fit: StackFit.expand, // Make the stack fill the entire screen
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.invert_colors_on_sharp,size: 20),
                SizedBox(width: 5),
                Text('Functional Activities',style: TextStyle(color: Colors.grey,fontSize: 16),)

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25,left: 10,right: 10,bottom: 10),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                          ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.green, width: 0.5),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                        
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                      //color: Colors.green
                                     color: Color(0xFFD3D3D3),
                                    ),
                                    child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                         height: 30,)),
                                  ),
                                            Text('Raise Grievance',
                                              style: GoogleFonts.lato(
                                                textStyle: Theme.of(context).textTheme.titleSmall,
                                               fontSize: 14,
                                               fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                               color:Colors.green
                                               ),
                                            ),
                                ],
                              ),
                            )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                        
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Grievance Status',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Garbage Pickup Request',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Sewerge Lifting Request',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Book Advertisement',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Know Your Ward',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Marriage Certificate',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Birth & Death Certificate',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Garbage Vehicle Locator',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Public Utilites Locator',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Park Locator',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Householding Tax',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Emergency Contacts',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Events/Newsletter',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.orange, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5.0),
                              shadowColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('Help Line / Feedback',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.orange
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width/2-14,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.green, // Specify your desired border color here
                                width: 5.0, // Adjust the width of the border
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0), // Adjust the radius for the top-left corner
                              bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            ),
                          ),
                          // color: Colors.black,
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25), // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(child: Image(image: AssetImage('assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,)),
                                    ),
                                    Text('About CMS',
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context).textTheme.titleSmall,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
