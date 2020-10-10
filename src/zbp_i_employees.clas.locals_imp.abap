CLASS lhc_Employees DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES IMPORTING keys REQUEST requested_features FOR Employees RESULT result.

ENDCLASS.

CLASS lhc_Employees IMPLEMENTATION.


  METHOD get_features.

  ENDMETHOD.

ENDCLASS.
