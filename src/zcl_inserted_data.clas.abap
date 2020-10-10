CLASS zcl_inserted_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_inserted_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: lt_master TYPE TABLE OF zhc_master,
*      lt_master TYPE TABLE OF ztb_employees,
          lv_count  TYPE i VALUE 0.

    WHILE lv_count <> 10.

      SELECT MAX( e_number ) FROM zhc_master
      INTO @DATA(lv_number).

      SELECT SINGLE
        e_number, e_name, e_department, status,
        job_title, start_date, end_date, email,
        m_number, m_name, m_department,
        crea_date_time, crea_uname, lchg_date_time, lchg_uname
      FROM zhc_master
      INTO @DATA(ls_master).

      ls_master-e_number = lv_number + 1.

      APPEND VALUE #( e_number       = ls_master-e_number
                      e_name         = ls_master-e_name
                      e_department   = ls_master-e_department
                      status         = ls_master-status
                      job_title      = ls_master-job_title
                      start_date     = ls_master-start_date
                      end_date       = ls_master-end_date
                      email          = ls_master-email
                      m_number       = ls_master-m_number
                      m_name         = ls_master-m_name
                      m_department   = ls_master-m_department
                      crea_date_time = ls_master-crea_date_time
                      crea_uname     = ls_master-crea_uname
                      lchg_date_time = ls_master-lchg_date_time
                      lchg_uname     = ls_master-lchg_uname ) TO lt_master.

      INSERT zhc_master  FROM TABLE @lt_master.
*      INSERT ztb_employees  FROM TABLE @lt_master.
      DELETE FROM: ztb_employees_d,
                   ztb_employees,
                   zhc_master.

      CLEAR lt_master.

      lv_count = lv_count + 1.

    ENDWHILE.

    "Check result in console
    out->write( sy-dbcnt ).
    out->write( 'DONE!' ).
  ENDMETHOD.
ENDCLASS.
