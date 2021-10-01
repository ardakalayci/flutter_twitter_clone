import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';


class RouteCreatePage extends StatefulWidget {
  final Function(DetailsResult) setRoute;
  @override
  RouteCreatePage({Key key, this.setRoute}) : super(key: key);

  _RouteCreatePageState createState() => _RouteCreatePageState();
}

class _RouteCreatePageState extends State<RouteCreatePage> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    String apiKey = "AIzaSyBe97C7V7cJ1YTHanrMqvzfhTZFq1fHwaE";
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }
  DetailsResult setResult(result){
    setState(() {
      try{
        widget.setRoute(result);

      }
      catch(e){
        print(e.toString());
      }
       print("fonk");

    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Ara",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                    print("arda");
                  } else {
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description),
                      onTap: () async {
                        debugPrint(predictions[index].placeId);
                        DetailsResult result=  await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              placeId: predictions[index].placeId,
                              googlePlace: googlePlace,
                              setRoute:setResult,
                            ),
                          ),
                        );
                      print(result);
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("assets/images/icon-white-480.png",color: Colors.deepOrange,width: MediaQuery.of(context).size.width*.35,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}

class DetailsPage extends StatefulWidget {
  final String placeId;
  final GooglePlace googlePlace;
  final Function(DetailsResult) setRoute;
  DetailsPage({Key key, this.placeId, this.googlePlace, this.setRoute}) : super(key: key);

  @override
  _DetailsPageState createState() =>
      _DetailsPageState(this.placeId, this.googlePlace);
}

class _DetailsPageState extends State<DetailsPage> {
  final String placeId;
  final GooglePlace googlePlace;

  _DetailsPageState(this.placeId, this.googlePlace);

  DetailsResult detailsResult;
  List<String> images = [];
  DetailsResult setRoute(result){
    setState(() {
      widget.setRoute(result);

    });
Navigator.pop(context);
  }
  @override
  void initState() {
    getDetils(this.placeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detay"),
          backgroundColor: Colors.blueAccent,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Detaylar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        detailsResult != null && detailsResult.types != null
                            ? Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: detailsResult.types.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Chip(
                                  label: Text(
                                    detailsResult.types[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              );
                            },
                          ),
                        )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.location_on),
                            ),
                            title: Text(
                              detailsResult != null &&
                                  detailsResult.formattedAddress != null
                                  ? 'Address: ${detailsResult.formattedAddress}'
                                  : "Address: null",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.location_searching),
                            ),
                            title: Text(
                              detailsResult != null &&
                                  detailsResult.geometry != null &&
                                  detailsResult.geometry.location != null
                                  ? 'Geometry: ${detailsResult.geometry.location.lat.toString()},${detailsResult.geometry.location.lng.toString()}'
                                  : "Geometry: null",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.timelapse),
                            ),
                            title: Text(
                              detailsResult != null &&
                                  detailsResult.utcOffset != null
                                  ? 'UTC offset: ${detailsResult.utcOffset.toString()} min'
                                  : "UTC offset: null",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.rate_review),
                            ),
                            title: Text(
                              detailsResult != null &&
                                  detailsResult.rating != null
                                  ? 'Rating: ${detailsResult.rating.toString()}'
                                  : "Rating: null",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.attach_money),
                            ),
                            title: Text(
                              detailsResult != null &&
                                  detailsResult.priceLevel != null
                                  ? 'Price level: ${"₺"*(detailsResult.priceLevel)}'
                                  : "Price level: null",
                            ),
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            setRoute(detailsResult);

                          });
                        }, child:Text("Seç"))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Image.asset("assets/images/icon-white-480.png",color: Colors.deepOrange,width: MediaQuery.of(context).size.width*.35,),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
       await Navigator.pop(context,detailsResult);
        return true;
      },
    );
  }

  void getDetils(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result;
        images = [];
      });
      if (result.result.photos != null) {
        for (var photo in result.result.photos) {
          getPhoto(photo.photoReference);
        }
      }
    }
  }

  void getPhoto(String photoReference) async {
    var result = await this.googlePlace.photos.get(photoReference, null, null);
    setState(() {
      images.add("""https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=AIzaSyBe97C7V7cJ1YTHanrMqvzfhTZFq1fHwaE""");
    });
    if (result != null && mounted) {
      setState(() {
        //images.add(result);
      });
    }
  }
}