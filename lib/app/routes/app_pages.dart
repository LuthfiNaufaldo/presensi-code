import 'package:get/get.dart';

import 'package:presensi_polsri/app/modules/add_dosen/bindings/add_dosen_binding.dart';
import 'package:presensi_polsri/app/modules/add_dosen/views/add_dosen_view.dart';
import 'package:presensi_polsri/app/modules/add_presensi/bindings/add_presensi_binding.dart';
import 'package:presensi_polsri/app/modules/add_presensi/views/add_presensi_view.dart';
import 'package:presensi_polsri/app/modules/detail_mahasiswa/bindings/detail_mahasiswa_binding.dart';
import 'package:presensi_polsri/app/modules/detail_mahasiswa/views/detail_mahasiswa_view.dart';
import 'package:presensi_polsri/app/modules/dosenHome/bindings/dosen_home_binding.dart';
import 'package:presensi_polsri/app/modules/dosenHome/views/dosen_home_view.dart';
import 'package:presensi_polsri/app/modules/mahasiswaHome/bindings/mahasiswa_home_binding.dart';
import 'package:presensi_polsri/app/modules/mahasiswaHome/views/mahasiswa_home_view.dart';
import 'package:presensi_polsri/app/modules/presensi/bindings/presensi_binding.dart';
import 'package:presensi_polsri/app/modules/presensi/views/presensi_view.dart';

import '../modules/add_mahasiswa/bindings/add_mahasiswa_binding.dart';
import '../modules/add_mahasiswa/views/add_mahasiswa_view.dart';
import '../modules/all_presensi/bindings/all_presensi_binding.dart';
import '../modules/all_presensi/views/all_presensi_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/qrscan/bindings/qrscan_binding.dart';
import '../modules/qrscan/views/qrscan_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADD_MAHASISWA,
      page: () => AddMahasiswaView(),
      binding: AddMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
    GetPage(
      name: _Paths.QRSCAN,
      page: () => QrscanView(),
      binding: QrscanBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRESENSI,
      page: () => AddPresensiView(),
      binding: AddPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DOSEN,
      page: () => AddDosenView(),
      binding: AddDosenBinding(),
    ),
    GetPage(
      name: _Paths.DOSEN_HOME,
      page: () => DosenHomeView(),
      binding: DosenHomeBinding(),
    ),
    GetPage(
      name: _Paths.MAHASISWA_HOME,
      page: () => MahasiswaHomeView(),
      binding: MahasiswaHomeBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI,
      page: () => PresensiView(),
      binding: PresensiBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MAHASISWA,
      page: () => DetailMahasiswaView(),
      binding: DetailMahasiswaBinding(),
    ),
  ];
}
