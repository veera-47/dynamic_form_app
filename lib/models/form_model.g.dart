// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormData _$FormDataFromJson(Map<String, dynamic> json) => FormData(
  getUserForm: GetUserForm.fromJson(
    json['getUserForm'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
  'getUserForm': instance.getUserForm.toJson(),
};

GetUserForm _$GetUserFormFromJson(Map<String, dynamic> json) => GetUserForm(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  formUuid: json['formUuid'] as String? ?? '',
  isEditable: json['isEditable'] as bool? ?? true,
  questions:
      (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GetUserFormToJson(GetUserForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'formUuid': instance.formUuid,
      'isEditable': instance.isEditable,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

// ignore: unused_element
Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  questionType: json['questionType'] as String,
  answerType: json['answerType'] as String,
  hintText: json['hintText'] as String,
  maxLines: (json['maxLines'] as num).toInt(),
  isMandatoryField: json['isMandatoryField'] as bool,
  reValidation: json['reValidation'] as String?,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
  nestedForms:
      (json['nestedForms'] as List<dynamic>?)
          ?.map((e) => NestedForm.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'questionType': instance.questionType,
  'answerType': instance.answerType,
  'hintText': instance.hintText,
  'maxLines': instance.maxLines,
  'isMandatoryField': instance.isMandatoryField,
  'reValidation': instance.reValidation,
  'options': instance.options?.map((e) => e.toJson()).toList(),
  'nestedForms': instance.nestedForms?.map((e) => e.toJson()).toList(),
};

Option _$OptionFromJson(Map<String, dynamic> json) =>
    Option(id: (json['id'] as num).toInt(), option: json['option'] as String);

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
  'id': instance.id,
  'option': instance.option,
};

NestedForm _$NestedFormFromJson(Map<String, dynamic> json) => NestedForm(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  formUuid: json['formUuid'] as String? ?? '',
  isEditable: json['isEditable'] as bool? ?? true,
  questions:
      (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$NestedFormToJson(NestedForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'formUuid': instance.formUuid,
      'isEditable': instance.isEditable,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };
