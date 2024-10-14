abstract class AppState {}

class InitalState extends AppState{}

class GetUserDataSuccessState extends AppState{}
class GetUserDataLoadingState extends AppState{}
class GetUserDataErrorState extends AppState{
  final String error;
  GetUserDataErrorState(this.error);
}
class ChangeBottomNavigationBarSate extends AppState{}
class NavigatToNewPostScreenState extends AppState{}
class ChangeImageSuccessState extends AppState{}
class ChangeImageErrorState extends AppState{}
class ChangeCoverImageSuccessState extends AppState{}
class ChangeCoverImageErrorState extends AppState{}
class UploadProfileImageSuccessState extends AppState{}
class UploadProfileImageErrorState extends AppState{}
class UploadCoverImageSuccessState extends AppState{}
class UploadCoverImageErrorState extends AppState{}
class UpdateUserDataSuccessState extends AppState{}
class UpdateUserDataLoadingState extends AppState{}
class UpdateUserDataErrorState extends AppState{}
class TakePostImageSuccessState extends AppState{}
class TakePostImageErrorState extends AppState{}
class UploadPostImageSuccessState extends AppState{}
class UploadPostImageErrorState extends AppState{}
