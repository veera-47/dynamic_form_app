import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import '../models/form_model.dart';
import '../services/form_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late Future<FormData> _formData;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _radioValues = {};
  final Map<String, String?> _locationValues = {};
  final Map<String, dynamic> _selfieData = {};
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _selectedForm = 'hnicustomersmet';
  final Map<String, Map<String, String>> _formOptions = {
    'hnicustomersmet': {
      'jsonPath': 'assets/hnicustomersmet.json',
      'formName': 'hni customers met',
    },
    'nonhnicustomersmet': {
      'jsonPath': 'assets/nonhnicustomermet.json',
      'formName': 'non - hni customers met',
    },
    'activitiesconducted': {
      'jsonPath': 'assets/activitiesconducted.json',
      'formName': 'activities conducted today',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  void _loadForm() {
    setState(() {
      _formData = FormService.loadForm(
        _formOptions[_selectedForm]!['jsonPath']!,
      );
      _controllers.clear();
      _radioValues.clear();
      _locationValues.clear();
      _selfieData.clear();
    });
  }

  void _clearForm() {
    setState(() {
      _controllers.forEach((key, controller) {
        if (key != '72' && key != '74') {
          controller.clear();
        }
      });
      _radioValues.clear();
      _locationValues.clear();
      _selfieData.clear();
      _formKey.currentState?.reset();
    });
  }

  Future<void> _fetchLocation(String questionId) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _locationValues[questionId] =
            'Lat: ${position.latitude}, Lon: ${position.longitude}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location fetched: ${_locationValues[questionId]}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching location: $e')));
    }
  }

  Future<void> _takeSelfie(String questionId) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: kIsWeb ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50,
      );
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selfieData[questionId] = {'type': 'bytes', 'data': bytes};
          });
        } else {
          setState(() {
            _selfieData[questionId] = {'type': 'path', 'data': image.path};
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selfie taken successfully!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No selfie taken.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking selfie: $e')));
    }
  }

  Widget _buildQuestion(Question question) {
    switch (question.questionType) {
      case 'TEXTFORMFIELD':
        _controllers.putIfAbsent(
          question.id.toString(),
          () => TextEditingController(),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: _controllers[question.id.toString()],
            decoration: InputDecoration(
              labelText:
                  question.isMandatoryField
                      ? '${question.question}'
                      : question.question,
              hintText: question.hintText,
              labelStyle: const TextStyle(color: Colors.black54),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            maxLines: question.maxLines,
            validator: (value) {
              if (question.isMandatoryField &&
                  (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        );
      case 'MOBILENUMBER':
        _controllers.putIfAbsent(
          question.id.toString(),
          () => TextEditingController(),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: _controllers[question.id.toString()],
            decoration: InputDecoration(
              labelText:
                  question.isMandatoryField
                      ? '${question.question}'
                      : question.question,
              hintText: question.hintText,
              labelStyle: const TextStyle(color: Colors.black54),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (question.isMandatoryField &&
                  (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              if (question.reValidation != null &&
                  !RegExp(question.reValidation!).hasMatch(value ?? '')) {
                return 'Invalid phone number (must be 10 digits)';
              }
              return null;
            },
          ),
        );
      case 'RADIO':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.isMandatoryField
                    ? '${question.question}*'
                    : question.question,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              if (question.id == 91)
                Column(
                  children:
                      question.options?.map((option) {
                        return RadioListTile<String>(
                          title: Text(
                            option.option,
                            style: const TextStyle(fontSize: 14),
                          ),
                          value: option.option,
                          groupValue: _radioValues[question.id.toString()],
                          onChanged: (value) {
                            setState(() {
                              _radioValues[question.id.toString()] = value;
                            });
                          },
                          activeColor: Colors.red,
                        );
                      }).toList() ??
                      [],
                )
              else
                Row(
                  children:
                      question.options?.map((option) {
                        return Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: option.option,
                                groupValue:
                                    _radioValues[question.id.toString()],
                                onChanged: (value) {
                                  setState(() {
                                    _radioValues[question.id.toString()] =
                                        value;
                                  });
                                },
                                activeColor: Colors.red,
                              ),
                              Expanded(
                                child: Text(
                                  option.option,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList() ??
                      [],
                ),
            ],
          ),
        );
      case 'ELEVATEDBUTTON':
        if (_locationValues[question.id.toString()] != null &&
            question.answerType == 'FETCHLOCATION') {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _locationValues[question.id.toString()]!,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          );
        }
        if (_selfieData[question.id.toString()] != null &&
            question.answerType == 'FETCHCAMERA') {
          final selfie = _selfieData[question.id.toString()];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:
                kIsWeb
                    ? Image.memory(
                      selfie['data'] as Uint8List,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                    : Image.file(
                      File(selfie['data'] as String),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              if (question.answerType == 'FETCHLOCATION') {
                await _fetchLocation(question.id.toString());
              } else if (question.answerType == 'FETCHCAMERA') {
                await _takeSelfie(question.id.toString());
              }
            },
            icon: Icon(
              question.answerType == 'FETCHLOCATION'
                  ? Icons.location_on
                  : Icons.camera_alt,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              question.answerType == 'FETCHLOCATION'
                  ? 'enter location'
                  : 'take selfie',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
          ),
        );
      case 'FORM':
        return Row(
          children:
              question.nestedForms
                  ?.map(
                    (form) => Expanded(
                      child: Column(
                        children: form.questions.map(_buildQuestion).toList(),
                      ),
                    ),
                  )
                  .toList() ??
              [],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Text('add input'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedForm,
              decoration: InputDecoration(
                labelText: 'Select Form Type',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items:
                  _formOptions.keys.map((String formType) {
                    return DropdownMenuItem<String>(
                      value: formType,
                      child: Text(formType),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedForm = newValue;
                    _loadForm();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<FormData>(
              future: _formData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final form = snapshot.data!.getUserForm;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          'log in your work',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            form.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...form.questions.map(_buildQuestion),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final formData = {
                                for (var q in form.questions)
                                  q.id.toString():
                                      _controllers[q.id.toString()]?.text ??
                                      _radioValues[q.id.toString()] ??
                                      _locationValues[q.id.toString()] ??
                                      (kIsWeb
                                          ? _selfieData[q.id.toString()] != null
                                              ? 'Image captured'
                                              : null
                                          : _selfieData[q.id
                                              .toString()]?['data']),
                              };
                              await FormService.saveFormData(
                                form.formUuid ?? '',
                                formData,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Form submitted!'),
                                ),
                              );
                              _clearForm();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text(
                            'submit',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
