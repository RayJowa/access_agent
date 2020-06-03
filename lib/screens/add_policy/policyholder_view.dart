
import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/previous_med_aid.dart';
import 'package:access_agent/screens/add_policy/add_dependent_view.dart';
import 'package:access_agent/screens/add_policy/dependents_view.dart';
import 'package:access_agent/screens/add_policy/policyholder_to_dependent_view.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class AddPolicyPolicyholderView extends StatefulWidget {
  @override
  _AddPolicyPolicyholderViewState createState() => _AddPolicyPolicyholderViewState();
}

class _AddPolicyPolicyholderViewState extends State<AddPolicyPolicyholderView> {

  final _formKey = GlobalKey<FormState>();
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
    'Other'
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
    _nameController.addListener(() => policy.firstName = _nameController.text.toUpperCase());
    _surnameController.addListener(() => policy.surname = _surnameController.text.toUpperCase());
    _idController.addListener(() => policy.idNumber = _idController.text.toUpperCase());
    _emailController.addListener(() => policy.email = _emailController.text);
    _phoneController.addListener(() => policy.email = _emailController.text);
    policy.gender = 'Male';
    policy.dob = DateTime(DateTime.now().year - 30);

  }

  @override
  Widget build(BuildContext context) {

    _titleController.text = policy.title;
    _nameController.text = policy.firstName;
    _surnameController.text = policy.surname;
    _dobController.text = DateFormat.yMMMMd("en_US").format(policy.dob);
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
            fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: false,
        backgroundColor: Color(0xFF094451),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover
            )
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Title',
                        hintText: 'Title'
                    ),
                    style: InputTextStyle.inputText1(context),
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
                  SizedBox(height: 16.0,),
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
                        return 'Name should have at least two characters';
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
                        Text(
                          '   Gender',
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
                            children: List.generate(2, (index) {
                              return ChoiceChip(
                                label: Text(_gender[index],
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
                                  backgroundColor: Colors.grey[700],
                                  child: Text(_gender[index][0]),
                                ),
                                selectedColor: Colors.grey[200],
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
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),
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
                        maxDateTime: DateTime(DateTime.now().year-18),
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
                          policy.dob = dateTime;
                          _dobController.text = DateFormat.yMMMMd("en_US").format(policy.dob);
                          print(_dobController.text);
                        }
                      );
                    },
                  ),
                  SizedBox(height: 16,),
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
                  TextFormField(
                    controller: _phoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10)
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Phone number',
                        hintText: 'Phone number'
                    ),
                    validator: (name) {
                      if (name.length < 9) {
                        return 'Invalid phone number';
                      }else{
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    style: InputTextStyle.inputText1(context),
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) => EmailValidator.validate(email) ?
                      null : 'Invalid email address',
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Email',
                        hintText: 'Email'
                    ),
                    style: InputTextStyle.inputText1(context),
                  ),
                  SizedBox(height: 16.0,),

                  FlatButton(
                    onPressed: () async {

                      if (_formKey.currentState.validate()) {
                        PreviousMedAid _previousMedAid = PreviousMedAid();

                        policy.firstName = _nameController.text.toUpperCase();
                        policy.surname = _surnameController.text.toUpperCase();
                        policy.title = _titleController.text;
                        policy.idNumber = _idController.text.toUpperCase();
                        policy.phone = _phoneController.text;
                        policy.email = _emailController.text;
                        policy.dependents = [];
                        policy.previousMedAid = _previousMedAid;


                        if (policy.dependents.length <= 0) {
                          Dependent dep = Dependent(
                            firstName: policy.firstName,
                            surname: policy.surname,
                            idNumber: policy.idNumber,
                            dob: policy.dob,
                            gender: policy.gender

                          );

                          policy.dependents.add(dep);


                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  PolicyholderToDependantView(
                                    dependent: dep, policy: policy,))
                          );

                          if (result != null) {
                            policy.dependents[0] = result;

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AddPolicyDependentsView(policy: policy,))
                            );
                          }
                        }
                      }
                    },
                    
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: Center(
                        child: Text(
                            'Next',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),

                    color: Color(0xFF094451),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ) ,
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}


