import 'package:bloc/bloc.dart';
import 'package:thyme_to_cook/services/auth/auth_provider.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {

    Future<void> onInitialize(AuthEventInitialize event, Emitter<AuthState> emit) async {
    await provider.refreshUser();
    final user = provider.currentUser;
    if (user == null) {
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification(isLoading: false));
    } else {
      emit( AuthStateLoggedIn(
        user: user,
        isLoading: false,
      ));
    }
  }
  on<AuthEventInitialize>(onInitialize);
    
  on<AuthEventRegisterEmailAndPassword>((event, emit) async {
        emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while we register you',
      ));
        final email = event.email;
        final password = event.password;
        
        try {
          await provider.registerUser(
            email: email, 
            password: password);
            emit(const AuthStateRegisterUsername(isLoading: false)) ;  
        } on Exception catch (e) {
          emit(AuthStateRegisterEmailAndPassword(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });
    on<AuthEventShouldLogin>((event, emit) async {
      emit(const AuthStateLoggingIn(isLoading: false));
    });
    
on<AuthEventRegister>((event, emit) async {
        emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait',
      ));
        final email = event.email;
        final username = event.username;
        final userPreferences = event.userPreferences;
        try {
          await provider.createUserDoc(
            email: email,
            username: username,
            userPreferences: userPreferences,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
  );
    
  on<AuthEventLogIn>(
  (event, emit) async {
    emit(const AuthStateLoggedOut(
      exception: null,
      isLoading: true,
      loadingText: 'Please wait while we log you in',
    ));
    final email = event.email;
    final password = event.password;
    try {
      final user = await provider.logIn(email: email, password: password);
      if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(
        exception: e,
        isLoading: false,
      ));
    }
  },
);
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          return;
        }
        try {
          await provider.sendPasswordReset(toEmail: email);
          emit(const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: true,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateForgotPassword(
            exception: e,
            hasSentEmail: false,
            isLoading: false,
          ));
        }
      },
    );

    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
      exception: null,
      isLoading: true,
      loadingText: 'Please wait while we log you out',
    ));
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
