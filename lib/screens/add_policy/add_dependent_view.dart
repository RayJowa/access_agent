import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class AddPolicyAddDependentView extends StatefulWidget {

  final Dependent dep;
  AddPolicyAddDependentView({this.dep});

  @override
  _AddPolicyAddDependentViewState createState() => _AddPolicyAddDependentViewState();
}

class _AddPolicyAddDependentViewState extends State<AddPolicyAddDependentView> {

  // final Policy policy = Policy();
  final _formKey = GlobalKey<FormState>();
  Dependent dependent = Dependent();


  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _doctorController = TextEditingController();

  int _male = 0;
  int _selectedPackage = 0;
  List<String> _gender = ['Male', 'Female'];
  List packages = ['Bronze', 'Gold', 'Diamond'];
  String docId;


  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    _idController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dep !=null) {
      dependent = widget.dep;
      _selectedPackage = packages.indexOf(dependent.package);
      _doctorController.text = dependent.doctor['name'];
    }else{
      dependent.gender = 'Male';
      dependent.package = 'Bronze';
      dependent.dob = DateTime(DateTime.now().year - 30);
    }
      _nameController.addListener(() =>
      dependent.firstName = _nameController.text);
      _surnameController.addListener(() =>
      dependent.surname = _surnameController.text);
      _idController.addListener(() => dependent.idNumber = _idController.text);
  }

  @override
  Widget build(BuildContext context) {

    _nameController.text = dependent.firstName;
    _surnameController.text = dependent.surname;
    _dobController.text = DateFormat.yMMMMd("en_US").format(dependent.dob);
    _idController.text = dependent.idNumber;



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add dependent details',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 25,
              fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: false,
        backgroundColor: Color(0xFF094451),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover
              )
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  validator: (name) {
                    if (name.length < 2) {
                      return 'Name should have at least two characters';
                    }else{
                      return null;
                    }
                  },
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Name',
                      hintText: 'Name'
                  ),
                  style: InputTextStyle.inputText1(context),
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _surnameController,
                  textCapitalization: TextCapitalization.characters,
                  validator: (name) {
                    if (name.length < 2) {
                      return 'Surname should have at least two characters';
                    }else{
                      return null;
                    }
                  },
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Surname',
                      hintText: 'Surname'
                  ),
                  style: InputTextStyle.inputText1(context),
                ),
                SizedBox(height: 16.0,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey[900],
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Gender',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(2, (index) {
                            return ChoiceChip(
                              label: Text(
                                _gender[index],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey[600]
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey[600],),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: Colors.transparent,
                              avatar: CircleAvatar(
                                backgroundColor: Color(0xFF094451),
                                child: Text(_gender[index][0]),
                              ),
                              selectedColor: Colors.white,
                              selected: _male == index,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _male = index;
                                    dependent.gender = _gender[index];
                                  });
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16,),
                TextFormField(
                  controller: _dobController,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Date of birth',
                      hintText: 'Date of birth'
                  ),
                  style: InputTextStyle.inputText1(context),
                  readOnly: true,
                  onTap: () {

                    DatePicker.showDatePicker(
                        context,

                        minDateTime: DateTime(DateTime.now().year - 100),
                        maxDateTime: DateTime.now(),
                        initialDateTime: DateTime(DateTime.now().year - 30),
                        dateFormat: 'yyyy-MMM-d',
                        pickerTheme: DateTimePickerTheme(
                            showTitle: true,
                            confirm: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF094451),
                                ),

                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),
                            cancel: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.redAccent,
                                ),

                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),

                            itemTextStyle: InputTextStyle.inputText2(context)
                        ),
                        onConfirm: (dateTime, List<int> index) {
                          dependent.dob = dateTime;
                          _dobController.text =DateFormat.yMMMMd("en_US").format(dependent.dob);
                        }
                    );
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _idController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(14),
                    WhitelistingTextInputFormatter(RegExp('([0-9A-Z-])')),
                  ],
                  validator: (name) {
                    if (name.length < 10) {
                      return 'Invalid ID number';
                    }else{
                      return null;
                    }
                  },
                  decoration: textInputDecoration.copyWith(
                      labelText: 'ID number',
                      hintText: 'ID number'
                  ),
                  style: InputTextStyle.inputText1(context),
                ),
                SizedBox(height: 16.0,),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey[900],
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('  Select package',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0
                      ),),
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.transparent ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(packages.length, (index) {
                            return ChoiceChip(
                              label: Text(
                                packages[index],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey[600]
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey[800]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.transparent,
                              avatar: CircleAvatar(
                                backgroundColor: Color(0xFF094451),
                                child: Text(packages[index][0]),
                              ),
                              selectedColor: Colors.white,
                              selected: _selectedPackage == index,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedPackage = index;
                                    dependent.package = packages[index];
                                  });
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey[900],
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Additional options',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.transparent ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InputChip(
                              padding: EdgeInsets.all(6.0),
                              avatar: CircleAvatar(
                                backgroundColor: Color(0xFF094451),
                                child: Text('J'),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey[800]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: Text('Joining fee',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey[600]
                                ),
                              ),
                              selected: dependent.joiningFee,
                              backgroundColor: Colors.transparent,
                              selectedColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  dependent.joiningFee = selected;
                                });
                              },

                            ),
                            InputChip(
                              padding: EdgeInsets.all(6.0),
                              avatar: CircleAvatar(
                                backgroundColor: Color(0xFF094451),
                                child: Text('C'),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey[800]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: Text('Chronic add-on',
                                  style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[600]
                              ),
                              ),
                              selected: dependent.chronicAddOn,
                              backgroundColor: Colors.transparent,
                              selectedColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  dependent.chronicAddOn = selected;
                                  print(dependent.chronicAddOn.toString());
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _doctorController,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Choose a doctor',
                      hintText: 'Choose a doctor'
                  ),
                  //TODO: Set readOnly: true to disable typing of doctor
                  validator: (doctor) {
                    if (doctor == '') {
                      return 'Please select a doctor';
                    }else{
                      return null;
                    }
                  },
                  style: InputTextStyle.inputText1(context),
                  onTap:() async {
                    dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyDoctorView()));

                    setState(() {
                      _doctorController.text = result['docName'];
                      docId = result['docId'];
                    });

                  },
                ),
                SizedBox(height: 16.0,),

                FlatButton.icon(

                  onPressed: () {
                    if (_formKey.currentState.validate()) {

                      Map doctor = {
                        'name': _doctorController.text,
                        'docid': docId
                      };

                      dependent.firstName = _nameController.text;
                      dependent.surname = _surnameController.text;
                      dependent.idNumber = _idController.text;
                      dependent.doctor = doctor;


                      Navigator.pop(
                          context,
                          dependent
                      );
                    }
                  },
                  icon: Icon(Icons.navigate_next),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    child: Text('Save dependent',
                        style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700
                    ),
                    ),
                  ),
                  color: Color(0xFF094451),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ) ,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
