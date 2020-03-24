//import 'dart:html';

import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/previous_med_aid.dart';
import 'package:access_agent/screens/add_policy/add_dependent_view.dart';
import 'package:access_agent/screens/add_policy/dependents_view.dart';
import 'package:flutter/material.dart';

class AddPolicyPolicyholderView extends StatefulWidget {
  @override
  _AddPolicyPolicyholderViewState createState() => _AddPolicyPolicyholderViewState();
}

class _AddPolicyPolicyholderViewState extends State<AddPolicyPolicyholderView> {

  final Policy policy = Policy();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final _titles = [
    'Mrs',
    'Mr',
    'Miss',
    'Ms',
    'Dr',
    'Prof.',
    'Honourable',
    'Rev',
  ];

  int _male = 0;
  List<String> _gender = ['Male', 'Female'];

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => policy.firstName = _nameController.text);
    _surnameController.addListener(() => policy.surname = _surnameController.text);
    _idController.addListener(() => policy.idNumber = _idController.text);
    _emailController.addListener(() => policy.email = _emailController.text);
    _phoneController.addListener(() => policy.email = _emailController.text);
    policy.gender = 'Male';

  }

  @override
  Widget build(BuildContext context) {

    _titleController.text = policy.title;
    _nameController.text = policy.firstName;
    _surnameController.text = policy.surname;
    _dobController.text = policy.dob.toString();
    _idController.text = policy.idNumber;
    _phoneController.text = policy.phone;
    _emailController.text = policy.email;


    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Principal member details',
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
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(context: context, builder: (context) {
                        return Container(
                          height: 250,
                          child: ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemCount: _titles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        _titles[index],
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),

                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      policy.title = _titles[index];
                                    });
                                  },
                                ),

                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(),
                          ),
                        );
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
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
                              policy.gender = _gender[index];
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
                          policy.dob = date;
                          _dobController.text = policy.dob.toString();
                        });
                      }
                      );
                    },
                  ),

                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _idController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'ID Number',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20.0,),


                  FlatButton.icon(
                    onPressed: () async {
                      PreviousMedAid _previousMedAid = PreviousMedAid();

                      policy.firstName = _nameController.text;
                      policy.surname = _surnameController.text;
                      policy.title = _titleController.text;
                      policy.idNumber = _idController.text;
                      policy.phone = _phoneController.text;
                      policy.email = _emailController.text;
                      policy.dependents = [];
                      policy.previousMedAid = _previousMedAid;


                      if (policy.dependents.length <= 0) {
                        Dependent dep = Dependent(
                            firstName: policy.firstName,
                            surname: policy.surname,
                            idNumber: policy.idNumber,
                            dob: policy.dob
                        );

                        policy.dependents.add(dep);


                        dynamic result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AddPolicyAddDependentView(dep: dep,))
                        );

                        if (result != null) {
                          policy.dependents[0] = result;
                        }
                      }
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AddPolicyDependentsView(policy: policy,))
                        );


                    },
                    icon: Icon(Icons.navigate_next),
                    label: Text('Next'),
                    color: Colors.blue[200],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}


