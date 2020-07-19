import 'package:access_agent/models/policy.dart';
import 'package:access_agent/services/city_search.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/services/doctor_search.dart';
import 'package:access_agent/services/suburb_search.dart';
import 'package:flutter/material.dart';

class AddPolicyDoctorView extends StatefulWidget {
  final Policy policy;
  AddPolicyDoctorView({Key key, this.policy}) : super(key: key);

  @override
  _AddPolicyDoctorViewState createState() => _AddPolicyDoctorViewState();
}

class _AddPolicyDoctorViewState extends State<AddPolicyDoctorView> {
  TextEditingController _cityController = TextEditingController();
  TextEditingController _suburbController = TextEditingController();
  TextEditingController _doctorController = TextEditingController();
  String suburbId;
  bool _doctorState = false;
  String docId;

  @override
  void dispose() {
    _cityController.dispose();
    _suburbController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _cityController.text = widget.policy.doctor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select doctor'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Form(
            child: Column(
          children: <Widget>[
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Select city',
              ),
              onTap: () async {
                var result =
                    await showSearch(context: context, delegate: CitySearch());

                _cityController.text = result;
                _suburbController.text = '';
                setState(() {
                  _doctorState = false;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _suburbController,
              decoration: InputDecoration(
                labelText: 'Select suburb',
              ),
              onTap: () async {
                dynamic result = await showSearch(
                    context: context,
                    delegate: SuburbSearch(_cityController.text));

                _suburbController.text =
                    result.substring(result.indexOf('?') + 1);

                suburbId = result.substring(0, result.indexOf('?'));
                print(suburbId);
                setState(() {
                  _doctorState = true;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              enabled: _doctorState,
              controller: _doctorController,
              decoration: InputDecoration(
                labelText: 'Doctor',
              ),
              onTap: () async {
                var result = await showSearch(
                    context: context, delegate: DoctorSearch(suburbId));
                _doctorController.text =
                    result.substring(result.indexOf('?') + 1);
                docId = result.substring(0, result.indexOf('?'));
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: SizedBox(
                height: 50,
                width: 200,
                child: Center(
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
              color: Color(0xFF094451),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            )
          ],
        )),
      ),
    );
  }
}
