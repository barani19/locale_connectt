import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/users/Shop.dart';
import 'package:locale_connectt/utils/textfield.dart';

class SearchPage extends StatefulWidget {
  final bool pdt; 
  final double? lat;
  final double? long;
   SearchPage({super.key, required this.pdt, this.lat, this.long});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String pname = '';

  @override
  Widget build(BuildContext context) {

  TextEditingController search = TextEditingController();
  CollectionReference decref = FirebaseFirestore.instance.collection('vendors');
  Stream<QuerySnapshot> stream =  decref.snapshots();

    void setpname(){
    setState(() {
      pname = search.text.toString().toLowerCase();
    });
  }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back)),
              ),
              Row(
                children:[ SizedBox(
                  width: MediaQuery.of(context).size.width-70,
                  child: Mytextfield(hint: 'Search...', obscuretext: false, controll: search)),
                              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blue),
                child: IconButton(
                  onPressed: (){
                    setpname();
                  }, icon: Icon(Icons.search)),
              ),
                  ]
              ),
          
              StreamBuilder(stream: stream,
               builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasError){
                    return Center(child: Text('error'),);
                  }
                  List spdt = [];
                   List<Map<String,dynamic>> products = [];
                  List<DocumentSnapshot> all = snapshot.data!.docs;
                  if(widget.pdt){
                  for(var data in all){
                     List<Map<String,dynamic>> products = [];
                     for(var product in data['products']){
                        print(all);
                      if(pname == product['iname'].toString().toLowerCase()){
                        spdt.add(product);
                      }
                     }
                  }
                  }
                  else{
                    for(var data in all){
                      if(pname == data['Store name'].toString().toLowerCase()){
                        products.add({
                           'Store name': data['Store name'],
                            'username': data['username'],
                            'email': data['email'],
                            'role': data['role'],
                            'password': data['password'],
                            'products': data['products']
                        });
                      }
                    }
                  }
                  String iname = '';
                  String iprice = '';
                  String iimage = '';
                  String email = '';
                  String sname = '';
                  if(snapshot.hasData){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: widget.pdt ? spdt.length : products.length,
                        itemBuilder: (context, index) {
                          if(spdt.length>0){
                          iname = spdt[index]['iname'];
                          iprice = spdt[index]['iprice'];
                          iimage = spdt[index]['iimage'];
                          }
                          if(products.length>0){
                              sname = products[index]['Store name'];
                           email = products[index]['email'];
                          }
                         
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: GestureDetector(
                              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>ShopApp(shop: products[index]))),
                              // onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => widget.pdt ?  ItemPage(iname: iname, lat: widget.lat,long: widget.long,) : ShopApp(shop: products[index]),)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5,),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        border: Border.all(color: Color.fromARGB(255, 233, 238, 240)),
                                        boxShadow: [
                                          new BoxShadow(
                                            color: const Color.fromARGB(255, 210, 207, 207),
                                            spreadRadius: 1,
                                            blurRadius: 5
                                          )
                                        ]
                                      ),
                                  child: ListTile(
                                    title: Text(widget.pdt ? iname : sname),
                                    subtitle: Text(widget.pdt ? iprice : email),
                                    leading: widget.pdt ?  Image.network(iimage,height: 100,width: 100,fit: BoxFit.fill,) : Text(''),
                                  ),
                                ),
                              ),
                            ),
                          );
                      },),
                    );
                  }
                  return Center(child: Text('data'),);
              },)
            ],
          ),
        ) 
        ),
    );
  }
}