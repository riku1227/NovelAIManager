// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class GalleryData extends _GalleryData
    with RealmEntity, RealmObjectBase, RealmObject {
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
      _defaultsSet = RealmObjectBase.setDefaults<GalleryData>({
        'isFolder': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'isFolder', isFolder);
    RealmObjectBase.set(this, 'promptData', promptData);
    RealmObjectBase.set(this, 'folderData', folderData);
  }

  GalleryData._();

  @override
  Uuid get id => RealmObjectBase.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;
  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  bool get isFolder => RealmObjectBase.get<bool>(this, 'isFolder') as bool;
  @override
  set isFolder(bool value) => RealmObjectBase.set(this, 'isFolder', value);

  @override
  PromptData? get promptData =>
      RealmObjectBase.get<PromptData>(this, 'promptData') as PromptData?;
  @override
  set promptData(covariant PromptData? value) =>
      RealmObjectBase.set(this, 'promptData', value);

  @override
  FolderData? get folderData =>
      RealmObjectBase.get<FolderData>(this, 'folderData') as FolderData?;
  @override
  set folderData(covariant FolderData? value) =>
      RealmObjectBase.set(this, 'folderData', value);

  @override
  Stream<RealmObjectChanges<GalleryData>> get changes =>
      RealmObjectBase.getChanges<GalleryData>(this);

  @override
  GalleryData freeze() => RealmObjectBase.freezeObject<GalleryData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(GalleryData._);
    return const SchemaObject(
        ObjectType.realmObject, GalleryData, 'GalleryData', [
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

class FolderData extends _FolderData
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  FolderData(
    Uuid id, {
    String name = "",
    String description = "",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<FolderData>({
        'name': "",
        'description': "",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
  }

  FolderData._();

  @override
  Uuid get id => RealmObjectBase.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Stream<RealmObjectChanges<FolderData>> get changes =>
      RealmObjectBase.getChanges<FolderData>(this);

  @override
  FolderData freeze() => RealmObjectBase.freezeObject<FolderData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(FolderData._);
    return const SchemaObject(
        ObjectType.realmObject, FolderData, 'FolderData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
    ]);
  }
}

class PromptData extends _PromptData
    with RealmEntity, RealmObjectBase, RealmObject {
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
      _defaultsSet = RealmObjectBase.setDefaults<PromptData>({
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
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'baseModel', baseModel);
    RealmObjectBase.set(this, 'width', width);
    RealmObjectBase.set(this, 'height', height);
    RealmObjectBase.set(this, 'strength', strength);
    RealmObjectBase.set(this, 'noise', noise);
    RealmObjectBase.set(this, 'undesiredContent', undesiredContent);
    RealmObjectBase.set(this, 'addQualityTag', addQualityTag);
    RealmObjectBase.set(this, 'steps', steps);
    RealmObjectBase.set(this, 'scale', scale);
    RealmObjectBase.set(this, 'seed', seed);
    RealmObjectBase.set(this, 'sampling', sampling);
    RealmObjectBase.set<RealmList<ImageData>>(
        this, 'generatedImageList', RealmList<ImageData>(generatedImageList));
    RealmObjectBase.set<RealmList<String>>(
        this, 'prompt', RealmList<String>(prompt));
    RealmObjectBase.set<RealmList<String>>(
        this, 'undesiredPrompt', RealmList<String>(undesiredPrompt));
  }

  PromptData._();

  @override
  Uuid get id => RealmObjectBase.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  RealmList<ImageData> get generatedImageList =>
      RealmObjectBase.get<ImageData>(this, 'generatedImageList')
          as RealmList<ImageData>;
  @override
  set generatedImageList(covariant RealmList<ImageData> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get prompt =>
      RealmObjectBase.get<String>(this, 'prompt') as RealmList<String>;
  @override
  set prompt(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get baseModel =>
      RealmObjectBase.get<String>(this, 'baseModel') as String;
  @override
  set baseModel(String value) => RealmObjectBase.set(this, 'baseModel', value);

  @override
  int get width => RealmObjectBase.get<int>(this, 'width') as int;
  @override
  set width(int value) => RealmObjectBase.set(this, 'width', value);

  @override
  int get height => RealmObjectBase.get<int>(this, 'height') as int;
  @override
  set height(int value) => RealmObjectBase.set(this, 'height', value);

  @override
  double get strength =>
      RealmObjectBase.get<double>(this, 'strength') as double;
  @override
  set strength(double value) => RealmObjectBase.set(this, 'strength', value);

  @override
  double get noise => RealmObjectBase.get<double>(this, 'noise') as double;
  @override
  set noise(double value) => RealmObjectBase.set(this, 'noise', value);

  @override
  RealmList<String> get undesiredPrompt =>
      RealmObjectBase.get<String>(this, 'undesiredPrompt') as RealmList<String>;
  @override
  set undesiredPrompt(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get undesiredContent =>
      RealmObjectBase.get<String>(this, 'undesiredContent') as String;
  @override
  set undesiredContent(String value) =>
      RealmObjectBase.set(this, 'undesiredContent', value);

  @override
  bool get addQualityTag =>
      RealmObjectBase.get<bool>(this, 'addQualityTag') as bool;
  @override
  set addQualityTag(bool value) =>
      RealmObjectBase.set(this, 'addQualityTag', value);

  @override
  int get steps => RealmObjectBase.get<int>(this, 'steps') as int;
  @override
  set steps(int value) => RealmObjectBase.set(this, 'steps', value);

  @override
  int get scale => RealmObjectBase.get<int>(this, 'scale') as int;
  @override
  set scale(int value) => RealmObjectBase.set(this, 'scale', value);

  @override
  double? get seed => RealmObjectBase.get<double>(this, 'seed') as double?;
  @override
  set seed(double? value) => RealmObjectBase.set(this, 'seed', value);

  @override
  String get sampling =>
      RealmObjectBase.get<String>(this, 'sampling') as String;
  @override
  set sampling(String value) => RealmObjectBase.set(this, 'sampling', value);

  @override
  Stream<RealmObjectChanges<PromptData>> get changes =>
      RealmObjectBase.getChanges<PromptData>(this);

  @override
  PromptData freeze() => RealmObjectBase.freezeObject<PromptData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PromptData._);
    return const SchemaObject(
        ObjectType.realmObject, PromptData, 'PromptData', [
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

class ImageData extends _ImageData
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  ImageData(
    Uuid id,
    String imagePath, {
    String description = "",
    double? imgSeed,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<ImageData>({
        'description': "",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'imagePath', imagePath);
    RealmObjectBase.set(this, 'imgSeed', imgSeed);
  }

  ImageData._();

  @override
  Uuid get id => RealmObjectBase.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get imagePath =>
      RealmObjectBase.get<String>(this, 'imagePath') as String;
  @override
  set imagePath(String value) => RealmObjectBase.set(this, 'imagePath', value);

  @override
  double? get imgSeed =>
      RealmObjectBase.get<double>(this, 'imgSeed') as double?;
  @override
  set imgSeed(double? value) => RealmObjectBase.set(this, 'imgSeed', value);

  @override
  Stream<RealmObjectChanges<ImageData>> get changes =>
      RealmObjectBase.getChanges<ImageData>(this);

  @override
  ImageData freeze() => RealmObjectBase.freezeObject<ImageData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ImageData._);
    return const SchemaObject(ObjectType.realmObject, ImageData, 'ImageData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('imagePath', RealmPropertyType.string),
      SchemaProperty('imgSeed', RealmPropertyType.double, optional: true),
    ]);
  }
}
