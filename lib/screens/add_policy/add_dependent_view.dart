import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:flutter/material.dart';

class AddPolicyAddDependentView extends StatefulWidget {

  final Dependent dep;
  AddPolicyAddDependentView({this.dep});

  @override
  _AddPolicyAddDependentViewState createState() => _AddPolicyAddDependentViewState();
}

class _AddPolicyAddDependentViewState extends State<AddPolicyAddDependentView> {

  // final Policy policy = Policy();
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
    }
      _nameController.addListener(() =>
      dependent.firstName = _nameController.text);
      _surnameController.addListener(() =>
      dependent.surname = _surnameController.text);
      _idController.addListener(() => dependent.idNumber = _idController.text);
      dependent.gender = 'Male';
      dependent.package = 'Bronze';
  }

  @override
  Widget build(BuildContext context) {

    _nameController.text = dependent.firstName;
    _surnameController.text = dependent.surname;
    _dobController.text = dependent.dob.toString();
    _idController.text = dependent.idNumber;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dependent member details',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 25,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'Surname',
                  ),

                ),
                SizedBox(height: 20.0,),
                Text('Gender', textAlign: TextAlign.left,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(2, (index) {
                    return ChoiceChip(
                      label: Text(_gender[index]),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.lightBlue[200],
                        child: Text(_gender[index][0]),
                      ),
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
                SizedBox(height: 20,),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of birth',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year - 30),
                        firstDate: DateTime(DateTime.now().year - 100),
                        lastDate: DateTime(DateTime.now().year-18)
                    ).then((date) {
                      setState(() {
                        dependent.dob = date;
                        _dobController.text =dependent.dob.toString();
                      });
                    }
                    );
                  },
                ),
                SizedBox(height: 20.0,),

                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'ID Number',
                  ),
                ),
                SizedBox(height: 20.0,),
                Text('Select package', textAlign: TextAlign.left,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(packages.length, (index) {
                    return ChoiceChip(
                      label: Text(packages[index]),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.lightBlue[200],
                        child: Text(packages[index][0]),
                      ),
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
                Divider(),
                SizedBox(height: 20.0,),
                Text('Additional options'),
                Wrap(
                  spacing: 12.0,
                  children: <Widget>[
                    InputChip(
                      padding: EdgeInsets.all(6.0),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text('J'),
                      ),
                      label: Text('Joining fee'),
                      selected: dependent.joiningFee,
                      selectedColor: Colors.blueAccent,
                      onSelected: (bool selected) {
                        setState(() {
                          dependent.joiningFee = selected;
                        });
                      },
                    ),
                    InputChip(
                      padding: EdgeInsets.all(6.0),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text('C'),
                      ),
                      label: Text('Chronic add-on'),
                      selected: dependent.chronicAddOn,
                      selectedColor: Colors.blueAccent,
                      onSelected: (bool selected) {
                        setState(() {
                          dependent.chronicAddOn = selected;
                          print(dependent.chronicAddOn.toString());
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _doctorController,
                  decoration: InputDecoration(
                    labelText: 'Choose doctor',
                  ),
                  onTap:() async {
                    dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyDoctorView()));

                    setState(() {
                      _doctorController.text = result['docName'];
                      docId = result['docId'];
                    });

                  },
                ),


                FlatButton.icon(
                  onPressed: () {

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
                  },
                  icon: Icon(Icons.navigate_next),
                  label: Text('Save dependent'),
                  color: Colors.blue[200],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
