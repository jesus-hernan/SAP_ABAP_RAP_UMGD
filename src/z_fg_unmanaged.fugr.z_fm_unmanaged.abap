FUNCTION z_fm_unmanaged.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MODE) TYPE  C DEFAULT 'E'
*"     VALUE(CLIENT) TYPE  ZHC_MASTER-CLIENT DEFAULT SY-MANDT
*"     VALUE(E_NUMBER) TYPE  ZHC_MASTER-E_NUMBER OPTIONAL
*"     VALUE(X_E_NUMBER) DEFAULT SPACE
*"     VALUE(_SCOPE) DEFAULT '2'
*"     VALUE(_WAIT) DEFAULT SPACE
*"     VALUE(_COLLECT) TYPE  C DEFAULT ' '
*"  EXCEPTIONS
*"      FOREIGN_LOCK
*"      SYSTEM_FAILURE
*"----------------------------------------------------------------------




ENDFUNCTION.
