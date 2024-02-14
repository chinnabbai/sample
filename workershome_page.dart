import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkersHomePage extends StatefulWidget {
  @override
  _WorkersHomePageState createState() => _WorkersHomePageState();
}

class _WorkersHomePageState extends State<WorkersHomePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  DateTime? selectedDate;
  String? selectedGender;
  bool isIndian = false;
  bool formSubmitted = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "workers_home".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  "first_name".tr(),
                  firstNameController,
                  Icons.person,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_messages.empty_field'.tr();
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  "last_name".tr(),
                  lastNameController,
                  Icons.person,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_messages.empty_field'.tr();
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  "phone".tr(),
                  phoneController,
                  Icons.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_messages.empty_field'.tr();
                    } else if (value.length != 10) {
                      return 'error_messages.invalid_phone'.tr();
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                ),
                _buildTextField(
                  "email".tr(),
                  emailController,
                  Icons.email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_messages.empty_field'.tr();
                    } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return 'error_messages.invalid_email'.tr();
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  "address".tr(),
                  addressController,
                  Icons.home,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_messages.empty_field'.tr();
                    }
                    return null;
                  },
                ),
                _buildDateOfBirthField(),
                _buildGenderRadioButtons(),
                SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType:
            label == "phone" ? TextInputType.phone : TextInputType.text,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
        ),
        style: TextStyle(fontSize: 14),
        controller: controller,
        onChanged: (_) => _formKey.currentState?.validate(),
        validator: validator,
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "date_of_birth".tr(),
          hintText: 'Select Date of Birth',
          suffixIcon: IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: Icon(Icons.calendar_today),
          ),
          border: OutlineInputBorder(),
        ),
        controller: dobController,
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'error_messages.select_dob'.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("gender".tr(), style: TextStyle(fontSize: 14)),
        Row(
          children: [
            _buildGenderRadioButton("male".tr(), "Male"),
            _buildGenderRadioButton("female".tr(), "Female"),
          ],
        ),
        if (formSubmitted && selectedGender == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'error_messages.select_gender'.tr(),
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        SizedBox(height: 16),
        Row(
          children: [
            Text('are_you_indian'.tr(), style: TextStyle(fontSize: 14)),
            SizedBox(width: 16),
            CupertinoSwitch(
              value: isIndian,
              onChanged: (value) {
                setState(() {
                  isIndian = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderRadioButton(String label, String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          formSubmitted = true;
        });

        if (_formKey.currentState!.validate()) {
          if (selectedGender != null) {
            _submitForm();
          }
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: Size(150, 50),
      ),
      child: Text(
        "submit".tr(),
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  void _submitForm() {
    String submissionMessage = """
    First Name: ${firstNameController.text}
    Last Name: ${lastNameController.text}
    Phone: ${phoneController.text}
    Email: ${emailController.text}
    Address: ${addressController.text}
    Gender: $selectedGender
    Are you Indian?: $isIndian
    Date of Birth: ${dobController.text}
  """;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Submitted Data"),
          content: Text(submissionMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
