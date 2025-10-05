// lib/features/appointment/services/interface/i_appointment_service.dart

import 'package:myapp/features/shop/service/interface/appointment-interface.dart';

abstract class IAppointmentService {
  Future<AppointmentListResponse> getAllAppointments({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
  });

  Future<AppointmentDetailResponse> getAppointmentById(String id);

  Future<CreateAppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  );

  Future<UpdateAppointmentResponse> updateAppointment(
    String id,
    UpdateAppointmentRequest request,
  );

  Future<void> deleteAppointment(String id);

  Future<void> updateAppointmentTotalAmount(String id, double totalAmount);
}
