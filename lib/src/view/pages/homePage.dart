import 'package:weather/src/models/models.dart';
import 'package:weather/src/view/widgets/background.dart';
import 'package:date_format/date_format.dart';
import 'package:weather/src/search/locationSearchDelegate.dart';
import 'package:flutter/material.dart';
import 'package:weather/src/view/styles.dart' as style;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isData =
      false; //variable para identificar si hubo una busqueda false=no, true=si
  late Location location;

  String urlImage = "https://www.metaweather.com/static/img/weather/png/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text(
          "ClimApp",
          style: style.style4,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final res = await showSearch(
                  context: context, delegate: LocationSearchDelegate());

              if (res != null) {
                setState(() {
                  location = res;
                  isData = true;
                });
              }
            },
            icon: const Icon(Icons.search),
            color: const Color.fromARGB(255, 250, 115, 4),
          )
        ],
      ),
      body: Stack(
        //clipBehavior: Clip.hardEdge,
        children: [
          const Background(),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _initialInfo(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                isData ? _anotherInfo() : _emptyContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

//metodo que muestra la parte del dia de hoy del clima
  Widget _initialInfo() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          bottomRight: Radius.circular(60.0),
        ),
      ),
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isData
                  ? Text(
                      location.title,
                      style: style.style1,
                    )
                  : Text(
                      "",
                      style: style.style1,
                    ),
              const Icon(
                Icons.thermostat,
                size: 70,
                color: Colors.orange,
              ),
              _tempText(
                  "Now ",
                  isData
                      ? location.consolidatedWeather[0].theTemp
                          .toStringAsFixed(1)
                      : "0 "),
              _tempText(
                  "Max ",
                  isData
                      ? location.consolidatedWeather[0].maxTemp
                          .toStringAsFixed(1)
                      : "0 "),
              _tempText(
                  "Min ",
                  isData
                      ? location.consolidatedWeather[0].minTemp
                          .toStringAsFixed(1)
                      : "0 "),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 75.0,
              ),
              Text(
                'Today',
                style: style.style5,
              ),
              if (isData)
                Text(
                  location.consolidatedWeather[0].weatherStateName,
                  style: style.style2,
                )
              else
                Text(
                  "",
                  style: style.style2,
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                child: isData
                    ? Image(
                        image: NetworkImage(urlImage +
                            location.consolidatedWeather[0].weatherStateAbbr +
                            ".png"),
                      )
                    : const Image(
                        image: AssetImage("images/sun.png"),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//metodo utilizado en initialInfo para construir info de temperatura
  Widget _tempText(String t1, String t2) {
    return RichText(
      text: TextSpan(
        text: '$t1: ',
        style: style.style2,
        children: [
          TextSpan(
            text: '$t2°',
            style: style.style3,
          ),
        ],
      ),
    );
  }

//metodo que construye el widget que contiene los datos del pais o ciudad buscados como dias
  Widget _anotherInfo() {
    DateTime now = DateTime.now();
    DateTime date1 = DateTime(now.year, now.month, now.day + 1);
    DateTime date2 = DateTime(now.year, now.month, now.day + 2);
    DateTime date3 = DateTime(now.year, now.month, now.day + 3);
    DateTime date4 = DateTime(now.year, now.month, now.day + 4);

    return Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(top: 20.0),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 90, 167, 0.6),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomRight: Radius.circular(30.0)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nextDays(date1, 1),
                _nextDays(date2, 2),
                _nextDays(date3, 3),
                _nextDays(date4, 4),
              ],
            ),
          ],
        ));
  }

//metodo que construye el widget que contiene los datos del pais o ciudad buscados (Vacio)
  Widget _emptyContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: const BoxDecoration(
        color: Color.fromARGB(153, 110, 44, 58),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), bottomRight: Radius.circular(30.0)),
      ),
      child: Center(
        child: Text(
          "Next days",
          style: style.style4,
        ),
      ),
    );
  }

//metodo utilizado _anotherInfo para llenar la la informacion buscada
  Widget _nextDays(DateTime time, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatDate(
            time,
            ["D"],
            //locale: const SpanishDateLocale(),
          ),
          style: style.style5,
        ),
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: FadeInImage(
            placeholder: const AssetImage('images/loading.gif'),
            image: NetworkImage(urlImage +
                location.consolidatedWeather[index].weatherStateAbbr +
                ".png"),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          location.consolidatedWeather[index].weatherStateName,
          style: style.style2.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          "${location.consolidatedWeather[index].theTemp.toStringAsFixed(1)}°",
          style: style.style3.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
