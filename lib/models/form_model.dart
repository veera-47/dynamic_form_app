import 'package:json_annotation/json_annotation.dart';

part 'form_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FormData {
  final GetUserForm getUserForm;

  FormData({required this.getUserForm});

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);
  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetUserForm {
  final int id;
  final String name;
  @JsonKey(defaultValue: '')
  final String? formUuid;
  @JsonKey(defaultValue: true)
  final bool? isEditable;
  final List<Question> questions;

  GetUserForm({
    required this.id,
    required this.name,
    this.formUuid,
    this.isEditable,
    required this.questions,
  });

  factory GetUserForm.fromJson(Map<String, dynamic> json) =>
      _$GetUserFormFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserFormToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Question {
  final int id;
  final String question;
  final String questionType;
  final String answerType;
  final String hintText;
  final int maxLines;
  final bool isMandatoryField;
  final String? reValidation;
  final List<Option>? options;
  final List<NestedForm>? nestedForms;

  Question({
    required this.id,
    required this.question,
    required this.questionType,
    required this.answerType,
    required this.hintText,
    required this.maxLines,
    required this.isMandatoryField,
    this.reValidation,
    this.options,
    this.nestedForms,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>?;
    List<Option>? parsedOptions;
    List<NestedForm>? parsedNestedForms;

    if (json['questionType'] == 'RADIO') {
      parsedOptions =
          rawOptions
              ?.map((opt) => Option.fromJson(opt as Map<String, dynamic>))
              .toList();
    } else if (json['questionType'] == 'FORM') {
      parsedNestedForms =
          rawOptions
              ?.map((form) => NestedForm.fromJson(form as Map<String, dynamic>))
              .toList();
    }

    return Question(
      id: json['id'] as int,
      question: json['question'] as String,
      questionType: json['questionType'] as String,
      answerType: json['answerType'] as String,
      hintText: json['hintText'] as String,
      maxLines: json['maxLines'] as int,
      isMandatoryField: json['isMandatoryField'] as bool,
      reValidation: json['reValidation'] as String?,
      options: parsedOptions,
      nestedForms: parsedNestedForms,
    );
  }

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Option {
  final int id;
  final String option;

  Option({required this.id, required this.option});

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NestedForm {
  final int id;
  final String name;
  @JsonKey(defaultValue: '')
  final String? formUuid;
  @JsonKey(defaultValue: true)
  final bool? isEditable;
  final List<Question> questions;

  NestedForm({
    required this.id,
    required this.name,
    this.formUuid,
    this.isEditable,
    required this.questions,
  });

  factory NestedForm.fromJson(Map<String, dynamic> json) =>
      _$NestedFormFromJson(json);
  Map<String, dynamic> toJson() => _$NestedFormToJson(this);
}
