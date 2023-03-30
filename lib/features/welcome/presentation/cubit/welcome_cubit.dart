import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(WelcomeInitial());
}
