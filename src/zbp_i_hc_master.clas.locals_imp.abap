CLASS lcl_buffer DEFINITION.

  PUBLIC SECTION.

    CONSTANTS: created TYPE c LENGTH 1 VALUE 'C',
               updated TYPE c LENGTH 1 VALUE 'U',
               deleted TYPE c LENGTH 1 VALUE 'D'.

    TYPES: BEGIN OF ty_buffer_master.
             INCLUDE TYPE zhc_master AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_master.

    TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master WITH UNIQUE KEY e_name.

    CLASS-DATA mt_buffer_master TYPE tt_master.

ENDCLASS.

CLASS lhc_HCMMaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:
      create         FOR MODIFY IMPORTING entities FOR CREATE HCMMaster,
      delete         FOR MODIFY IMPORTING keys     FOR DELETE HCMMaster,
      update         FOR MODIFY IMPORTING entities FOR UPDATE HCMMaster,
      read           FOR READ IMPORTING   keys     FOR READ   HCMMaster RESULT result.
*      lock_employee  FOR LOCK IMPORTING   keys     FOR LOCK   HCMMaster. " First Call (If - OK) -> Call Read Method


ENDCLASS.

CLASS lhc_HCMMaster IMPLEMENTATION.

  METHOD create.
    GET TIME STAMP FIELD DATA(lv_tsl).

    SELECT MAX( e_number ) AS e_number
        FROM zhc_master INTO @DATA(lv_e_number).

    LOOP AT entities INTO DATA(ls_entities).

      ls_entities-%data-crea_date_time = lv_tsl.
      ls_entities-%data-crea_uname     = sy-uname.
      ls_entities-%data-e_number       = lv_e_number + 1.

      INSERT VALUE #( flag = lcl_buffer=>created
                      data = CORRESPONDING #( ls_entities-%data ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF ls_entities-%cid IS NOT INITIAL.
        INSERT VALUE #( %cid     = ls_entities-%cid
                        e_number = ls_entities-e_number ) INTO TABLE mapped-hcmmaster.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_entities).
      INSERT VALUE #( flag = lcl_buffer=>deleted
                      data = VALUE #( e_number = ls_entities-e_number ) ) INTO TABLE lcl_buffer=>mt_buffer_master.
      IF ls_entities-e_number IS NOT INITIAL.
        INSERT VALUE #( %cid     = ls_entities-e_number
                        e_number = ls_entities-e_number ) INTO TABLE mapped-hcmmaster.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    LOOP AT entities INTO DATA(ls_entities).

      GET TIME STAMP FIELD ls_entities-%data-lchg_date_time.
      ls_entities-%data-lchg_uname     = sy-uname.

* CASE 2 - Only UPDATE the FIELDS posted
      SELECT SINGLE * FROM zhc_master
             WHERE e_number EQ @ls_entities-e_number
             INTO @DATA(ls_ddbb).

      IF sy-subrc EQ 0.
        INSERT VALUE #( flag = lcl_buffer=>updated
                        data = VALUE #(
                                        e_name       = COND #( WHEN ls_entities-%control-e_name = if_abap_behv=>mk-on
                                                               THEN ls_entities-e_name
                                                               ELSE ls_ddbb-e_name )
                                        e_department = COND #( WHEN ls_entities-%control-e_department = if_abap_behv=>mk-on
                                                               THEN ls_entities-e_department
                                                               ELSE ls_ddbb-e_department )
                                        status       = COND #( WHEN ls_entities-%control-status = if_abap_behv=>mk-on
                                                               THEN ls_entities-status
                                                               ELSE ls_ddbb-status )
                                        job_title    = COND #( WHEN ls_entities-%control-job_title = if_abap_behv=>mk-on
                                                               THEN ls_entities-job_title
                                                               ELSE ls_ddbb-job_title )
                                        start_date   = COND #( WHEN ls_entities-%control-start_date = if_abap_behv=>mk-on
                                                               THEN ls_entities-start_date
                                                               ELSE ls_ddbb-start_date )
                                        end_date     = COND #( WHEN ls_entities-%control-end_date = if_abap_behv=>mk-on
                                                               THEN ls_entities-end_date
                                                               ELSE ls_ddbb-end_date )
                                        email        = COND #( WHEN ls_entities-%control-email = if_abap_behv=>mk-on
                                                               THEN ls_entities-email
                                                               ELSE ls_ddbb-email )
                                        m_number     = COND #( WHEN ls_entities-%control-m_number = if_abap_behv=>mk-on
                                                               THEN ls_entities-m_number
                                                               ELSE ls_ddbb-m_number )
                                        m_name       = COND #( WHEN ls_entities-%control-m_name = if_abap_behv=>mk-on
                                                               THEN ls_entities-m_name
                                                               ELSE ls_ddbb-m_name )
                                        m_department = COND #( WHEN ls_entities-%control-m_department = if_abap_behv=>mk-on
                                                               THEN ls_entities-m_department
                                                               ELSE ls_ddbb-m_department )
                                        e_number       = ls_entities-e_number
                                        crea_date_time = ls_ddbb-crea_date_time
                                        crea_uname     = ls_ddbb-crea_uname ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

        IF ls_entities-e_number IS NOT INITIAL.
          INSERT VALUE #( %cid     = ls_entities-e_number
                          e_number = ls_entities-e_number ) INTO TABLE mapped-hcmmaster.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
*      DATA: ls_travel_out  TYPE /dmo/travel,
*            lt_booking_out TYPE /dmo/t_booking,
*            lt_message     TYPE /dmo/t_message.
*      "Only one function call for each requested travelid
*      LOOP AT it_booking_read ASSIGNING FIELD-SYMBOL(<fs_travel_read>)
*      GROUP BY <fs_travel_read>-travelid .
*        CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
*          EXPORTING
*            iv_travel_id = <fs_travel_read>-travelid
*          IMPORTING
*            es_travel    = ls_travel_out
*            et_booking   = lt_booking_out
*            et_messages  = lt_message.
*        IF lt_message IS INITIAL.
*          "For each travelID find the requested bookings
*          LOOP AT GROUP <fs_travel_read> ASSIGNING FIELD-SYMBOL(<fs_booking_read>).
*            READ TABLE lt_booking_out INTO DATA(ls_booking) WITH KEY travel_id = <fs_booking_read>-%key-TravelID
*            booking_id = <fs_booking_read>-%key-BookingID .
*            "if read was successfull
*            IF sy-subrc = 0.
*              "fill result parameter with flagged fields
*              INSERT
*              VALUE #( travelid = ls_booking-travel_id
*              bookingid = ls_booking-booking_id
*              bookingdate = COND #( WHEN <fs_booking_read>-%control-BookingDate = cl_abap_behv=>flag_changed THEN ls_booking-booking_date )
*              customerid = COND #( WHEN <fs_booking_read>-%control-CustomerID = cl_abap_behv=>flag_changed THEN ls_booking-customer_id )
*              airlineid = COND #( WHEN <fs_booking_read>-%control-AirlineID = cl_abap_behv=>flag_changed THEN ls_booking-carrier_id )
*              connectionid = COND #( WHEN <fs_booking_read>-%control-ConnectionID = cl_abap_behv=>flag_changed THEN ls_booking-connection_id )
*              flightdate = COND #( WHEN <fs_booking_read>-%control-FlightDate = cl_abap_behv=>flag_changed THEN ls_booking-flight_date )
*              flightprice = COND #( WHEN <fs_booking_read>-%control-FlightPrice = cl_abap_behv=>flag_changed THEN ls_booking-flight_price )
*              currencycode = COND #( WHEN <fs_booking_read>-%control-CurrencyCode = cl_abap_behv=>flag_changed THEN ls_booking-currency_code )
** lastchangedat = COND #( WHEN <fs_booking_read>-%control-LastChangedAt = cl_abap_behv=>flag_changed THEN ls_travel_out-lastchangedat )
*              ) INTO TABLE et_booking.
*            ELSE.
*              "BookingID not found
*              INSERT
*              VALUE #( travelid = <fs_booking_read>-TravelID
*              bookingid = <fs_booking_read>-BookingID
*              %fail-cause = if_abap_behv=>cause-not_found )
*              INTO TABLE failed-booking.
*            ENDIF.
*          ENDLOOP.
*        ELSE.
*          "TravelID not found or other fail cause
*          LOOP AT GROUP <fs_travel_read> ASSIGNING <fs_booking_read>.
*            failed-booking = VALUE #( BASE failed-booking
*            FOR msg IN lt_message ( %key-TravelID = <fs_booking_read>-TravelID
*            %key-BookingID = <fs_booking_read>-BookingID
*            %fail-cause = COND #( WHEN msg-msgty = 'E' AND msg-msgno = '016'
*            THEN if_abap_behv=>cause-not_found
*            ELSE if_abap_behv=>cause-unspecific ) ) ).
*          ENDLOOP.
*        ENDIF.
*      ENDLOOP.
*
  ENDMETHOD.

*  METHOD lock_employee.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_employee>).
*      CALL FUNCTION 'ENQUEUE_/DMO/ETRAVEL'
*        EXPORTING
*          travel_id      = <ls_employee>-e_number
*        EXCEPTIONS
*          foreign_lock   = 1
*          system_failure = 2
*          OTHERS         = 3.
*      ASSERT sy-subrc < 2.
*      IF sy-subrc = 1.
*        INSERT zcl_messages=>map_travel_message(
*           iv_travel_id = <fs_travel>-travel_id
*           is_message   = VALUE #( msgid = '/DMO/CM_FLIGHT_LEGAC'
*                                   msgty = 'E'
*                                   msgno = '032'
*                                   msgv1 = <fs_travel>-travel_id
*                                   msgv2 = sy-msgv1 ) )
*          INTO TABLE reported-travel.
*        APPEND VALUE #( travel_id = <fs_travel>-travel_id )
*               TO failed-travel.
*      ENDIF.
*
*      APPEND VALUE #( e_number = <ls_employee>-e_number )
*             TO failed-hcmmaster.
*      CLEAR failed.
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_z_i_hc_master DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS:
      check_before_save REDEFINITION,
      finalize          REDEFINITION,
      save              REDEFINITION.

ENDCLASS.

CLASS lsc_z_i_hc_master IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.

    DATA: lt_data_created TYPE STANDARD TABLE OF zhc_master,
          lt_data_updated TYPE STANDARD TABLE OF zhc_master,
          lt_data_deleted TYPE STANDARD TABLE OF zhc_master.

    lt_data_created = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master WHERE ( flag = lcl_buffer=>created ) ( <row>-data ) ).

    IF lt_data_created IS NOT INITIAL.
      INSERT zhc_master FROM TABLE @lt_data_created.
    ENDIF.

    lt_data_updated = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master WHERE ( flag = lcl_buffer=>updated ) ( <row>-data ) ).

    IF lt_data_updated IS NOT INITIAL.
      UPDATE zhc_master FROM TABLE @lt_data_updated.
    ENDIF.

    lt_data_deleted = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master WHERE ( flag = lcl_buffer=>deleted ) ( <row>-data ) ).

    IF lt_data_deleted IS NOT INITIAL.
      DELETE zhc_master FROM TABLE @lt_data_deleted.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
