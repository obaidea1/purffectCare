class UserModel {
   String? name;
   String? email;
   String? phone;
   String? image;
   String? bio;
   String? coverImage;
   String? uId;
   bool? isEmailVerification;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uId,
      required this.bio,
      required this.isEmailVerification,
      required this.image,
      required this.coverImage,});

  UserModel.fromJson(Map<String,dynamic> json){
    image = json['image'];
    bio = json['bio'];
    coverImage = json['coverImage'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerification = json['isEmailVerification'];
  }
  Map<String,dynamic> toMap () => {
    'image' : image,
    'bio' : bio,
    'coverImage':coverImage,
    'name' : name,
    'email':email,
    'phone':phone,
    'uId':uId,
    'isEmailVerification':isEmailVerification,
  };
}
