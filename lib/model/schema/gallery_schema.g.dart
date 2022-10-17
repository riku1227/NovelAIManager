// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class GalleryData extends _GalleryData with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  GalleryData(
    Uuid id,
    String title,
    DateTime createdAt,
    DateTime updatedAt, {
    bool isFolder = false,
    PromptData? promptData,
    FolderData? folderData,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<GalleryData>({
        'isFolder': false,
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'title', title);
    RealmObject.set(this, 'createdAt', createdAt);
    RealmObject.set(this, 'updatedAt', updatedAt);
    RealmObject.set(this, 'isFolder', isFolder);
    RealmObject.set(this, 'promptData', promptData);
    RealmObject.set(this, 'folderData', folderData);
  }

  GalleryData._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  String get title => RealmObject.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObject.set(this, 'title', value);

  @override
  DateTime get createdAt =>
      RealmObject.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) => RealmObject.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObject.get<DateTime>(this, 'updatedAt') as DateTime;
  @override
  set updatedAt(DateTime value) => RealmObject.set(this, 'updatedAt', value);

  @override
  bool get isFolder => RealmObject.get<bool>(this, 'isFolder') as bool;
  @override
  set isFolder(bool value) => RealmObject.set(this, 'isFolder', value);

  @override
  PromptData? get promptData =>
      RealmObject.get<PromptData>(this, 'promptData') as PromptData?;
  @override
  set promptData(covariant PromptData? value) =>
      RealmObject.set(this, 'promptData', value);

  @override
  FolderData? get folderData =>
      RealmObject.get<FolderData>(this, 'folderData') as FolderData?;
  @override
  set folderData(covariant FolderData? value) =>
      RealmObject.set(this, 'folderData', value);

  @override
  Stream<RealmObjectChanges<GalleryData>> get changes =>
      RealmObject.getChanges<GalleryData>(this);

  @override
  GalleryData freeze() => RealmObject.freezeObject<GalleryData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(GalleryData._);
    return const SchemaObject(GalleryData, 'GalleryData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
      SchemaProperty('isFolder', RealmPropertyType.bool),
      SchemaProperty('promptData', RealmPropertyType.object,
          optional: true, linkTarget: 'PromptData'),
      SchemaProperty('folderData', RealmPropertyType.object,
          optional: true, linkTarget: 'FolderData'),
    ]);
  }
}

class FolderData extends _FolderData with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  FolderData(
    Uuid id, {
    String name = "",
    String description = "",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<FolderData>({
        'name': "",
        'description': "",
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'description', description);
  }

  FolderData._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  String get description =>
      RealmObject.get<String>(this, 'description') as String;
  @override
  set description(String value) => RealmObject.set(this, 'description', value);

  @override
  Stream<RealmObjectChanges<FolderData>> get changes =>
      RealmObject.getChanges<FolderData>(this);

  @override
  FolderData freeze() => RealmObject.freezeObject<FolderData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(FolderData._);
    return const SchemaObject(FolderData, 'FolderData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
    ]);
  }
}

class PromptData extends _PromptData with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  PromptData(
    Uuid id, {
    String description = "",
    String baseModel = "nai_diffusion_anime_full",
    int width = 512,
    int height = 768,
    double strength = 0.5,
    double noise = 0,
    String undesiredContent = "lowquality_plus_badanatomy",
    bool addQualityTag = true,
    int steps = 28,
    int scale = 11,
    double? seed,
    String sampling = "k_euler_ancestral",
    Iterable<ImageData> generatedImageList = const [],
    Iterable<String> prompt = const [],
    Iterable<String> undesiredPrompt = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<PromptData>({
        'description': "",
        'baseModel': "nai_diffusion_anime_full",
        'width': 512,
        'height': 768,
        'strength': 0.5,
        'noise': 0,
        'undesiredContent': "lowquality_plus_badanatomy",
        'addQualityTag': true,
        'steps': 28,
        'scale': 11,
        'sampling': "k_euler_ancestral",
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'description', description);
    RealmObject.set(this, 'baseModel', baseModel);
    RealmObject.set(this, 'width', width);
    RealmObject.set(this, 'height', height);
    RealmObject.set(this, 'strength', strength);
    RealmObject.set(this, 'noise', noise);
    RealmObject.set(this, 'undesiredContent', undesiredContent);
    RealmObject.set(this, 'addQualityTag', addQualityTag);
    RealmObject.set(this, 'steps', steps);
    RealmObject.set(this, 'scale', scale);
    RealmObject.set(this, 'seed', seed);
    RealmObject.set(this, 'sampling', sampling);
    RealmObject.set<RealmList<ImageData>>(
        this, 'generatedImageList', RealmList<ImageData>(generatedImageList));
    RealmObject.set<RealmList<String>>(
        this, 'prompt', RealmList<String>(prompt));
    RealmObject.set<RealmList<String>>(
        this, 'undesiredPrompt', RealmList<String>(undesiredPrompt));
  }

  PromptData._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  String get description =>
      RealmObject.get<String>(this, 'description') as String;
  @override
  set description(String value) => RealmObject.set(this, 'description', value);

  @override
  RealmList<ImageData> get generatedImageList =>
      RealmObject.get<ImageData>(this, 'generatedImageList')
          as RealmList<ImageData>;
  @override
  set generatedImageList(covariant RealmList<ImageData> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get prompt =>
      RealmObject.get<String>(this, 'prompt') as RealmList<String>;
  @override
  set prompt(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get baseModel => RealmObject.get<String>(this, 'baseModel') as String;
  @override
  set baseModel(String value) => RealmObject.set(this, 'baseModel', value);

  @override
  int get width => RealmObject.get<int>(this, 'width') as int;
  @override
  set width(int value) => RealmObject.set(this, 'width', value);

  @override
  int get height => RealmObject.get<int>(this, 'height') as int;
  @override
  set height(int value) => RealmObject.set(this, 'height', value);

  @override
  double get strength => RealmObject.get<double>(this, 'strength') as double;
  @override
  set strength(double value) => RealmObject.set(this, 'strength', value);

  @override
  double get noise => RealmObject.get<double>(this, 'noise') as double;
  @override
  set noise(double value) => RealmObject.set(this, 'noise', value);

  @override
  RealmList<String> get undesiredPrompt =>
      RealmObject.get<String>(this, 'undesiredPrompt') as RealmList<String>;
  @override
  set undesiredPrompt(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get undesiredContent =>
      RealmObject.get<String>(this, 'undesiredContent') as String;
  @override
  set undesiredContent(String value) =>
      RealmObject.set(this, 'undesiredContent', value);

  @override
  bool get addQualityTag =>
      RealmObject.get<bool>(this, 'addQualityTag') as bool;
  @override
  set addQualityTag(bool value) =>
      RealmObject.set(this, 'addQualityTag', value);

  @override
  int get steps => RealmObject.get<int>(this, 'steps') as int;
  @override
  set steps(int value) => RealmObject.set(this, 'steps', value);

  @override
  int get scale => RealmObject.get<int>(this, 'scale') as int;
  @override
  set scale(int value) => RealmObject.set(this, 'scale', value);

  @override
  double? get seed => RealmObject.get<double>(this, 'seed') as double?;
  @override
  set seed(double? value) => RealmObject.set(this, 'seed', value);

  @override
  String get sampling => RealmObject.get<String>(this, 'sampling') as String;
  @override
  set sampling(String value) => RealmObject.set(this, 'sampling', value);

  @override
  Stream<RealmObjectChanges<PromptData>> get changes =>
      RealmObject.getChanges<PromptData>(this);

  @override
  PromptData freeze() => RealmObject.freezeObject<PromptData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(PromptData._);
    return const SchemaObject(PromptData, 'PromptData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('generatedImageList', RealmPropertyType.object,
          linkTarget: 'ImageData', collectionType: RealmCollectionType.list),
      SchemaProperty('prompt', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('baseModel', RealmPropertyType.string),
      SchemaProperty('width', RealmPropertyType.int),
      SchemaProperty('height', RealmPropertyType.int),
      SchemaProperty('strength', RealmPropertyType.double),
      SchemaProperty('noise', RealmPropertyType.double),
      SchemaProperty('undesiredPrompt', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('undesiredContent', RealmPropertyType.string),
      SchemaProperty('addQualityTag', RealmPropertyType.bool),
      SchemaProperty('steps', RealmPropertyType.int),
      SchemaProperty('scale', RealmPropertyType.int),
      SchemaProperty('seed', RealmPropertyType.double, optional: true),
      SchemaProperty('sampling', RealmPropertyType.string),
    ]);
  }
}

class ImageData extends _ImageData with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  ImageData(
    Uuid id,
    String imagePath, {
    String description = "",
    double? imgSeed,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<ImageData>({
        'description': "",
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'description', description);
    RealmObject.set(this, 'imagePath', imagePath);
    RealmObject.set(this, 'imgSeed', imgSeed);
  }

  ImageData._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  String get description =>
      RealmObject.get<String>(this, 'description') as String;
  @override
  set description(String value) => RealmObject.set(this, 'description', value);

  @override
  String get imagePath => RealmObject.get<String>(this, 'imagePath') as String;
  @override
  set imagePath(String value) => RealmObject.set(this, 'imagePath', value);

  @override
  double? get imgSeed => RealmObject.get<double>(this, 'imgSeed') as double?;
  @override
  set imgSeed(double? value) => RealmObject.set(this, 'imgSeed', value);

  @override
  Stream<RealmObjectChanges<ImageData>> get changes =>
      RealmObject.getChanges<ImageData>(this);

  @override
  ImageData freeze() => RealmObject.freezeObject<ImageData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(ImageData._);
    return const SchemaObject(ImageData, 'ImageData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('imagePath', RealmPropertyType.string),
      SchemaProperty('imgSeed', RealmPropertyType.double, optional: true),
    ]);
  }
}
