CLASS zial_cl_cnf_shm DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS get
      RETURNING VALUE(rs_cnf_data) TYPE zial_s_cnf_shm_data
      RAISING   zcx_error.

    CLASS-METHODS set
      IMPORTING is_cnf_data TYPE zial_s_cnf_shm_data
      RAISING   zcx_error.

    CLASS-METHODS get_rul
      RETURNING VALUE(rt_cnf_rul) TYPE zial_tt_cnf_rul_int
      RAISING   zcx_error.

    CLASS-METHODS set_rul
      IMPORTING it_cnf_rul TYPE zial_tt_cnf_rul_int
      RAISING   zcx_error.

    CLASS-METHODS get_var
      RETURNING VALUE(rt_cnf_var) TYPE zial_tt_cnf_var_int
      RAISING   zcx_error.

    CLASS-METHODS set_var
      IMPORTING it_cnf_var TYPE zial_tt_cnf_var_int
      RAISING   zcx_error.

    CLASS-METHODS get_par
      RETURNING VALUE(rt_cnf_par) TYPE zial_tt_cnf_par_int
      RAISING   zcx_error.

    CLASS-METHODS set_par
      IMPORTING it_cnf_par TYPE zial_tt_cnf_par_int
      RAISING   zcx_error.

    CLASS-METHODS get_val
      RETURNING VALUE(rt_cnf_val) TYPE zial_tt_cnf_val_int
      RAISING   zcx_error.

    CLASS-METHODS set_val
      IMPORTING it_cnf_val TYPE zial_tt_cnf_val_int
      RAISING   zcx_error.

  PROTECTED SECTION.
    CONSTANTS: BEGIN OF mc_params,
                 rul TYPE zial_de_shm_parameter_name VALUE 'CNF_RUL',
                 var TYPE zial_de_shm_parameter_name VALUE 'CNF_VAR',
                 par TYPE zial_de_shm_parameter_name VALUE 'CNF_PAR',
                 val TYPE zial_de_shm_parameter_name VALUE 'CNF_VAL',
               END OF mc_params.

ENDCLASS.


CLASS zial_cl_cnf_shm IMPLEMENTATION.

  METHOD get_rul.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-rul ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    rt_cnf_rul = <l_shm_value>.

  ENDMETHOD.


  METHOD set_rul.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-rul ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_shm_value> = it_cnf_rul.

    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.


  METHOD get_var.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-var ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    rt_cnf_var = <l_shm_value>.

  ENDMETHOD.


  METHOD set_var.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-var ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_shm_value> = it_cnf_var.

    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.


  METHOD get_par.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-par ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    rt_cnf_par = <l_shm_value>.

  ENDMETHOD.


  METHOD set_par.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-par ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_shm_value> = it_cnf_par.

    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.


  METHOD get_val.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-val ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    rt_cnf_val = <l_shm_value>.

  ENDMETHOD.


  METHOD set_val.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = mc_params-val ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_shm_value> = it_cnf_val.

    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.


  METHOD get.

    DATA lo_abap_structdescr TYPE REF TO cl_abap_structdescr.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).

    lo_abap_structdescr ?= cl_abap_structdescr=>describe_by_data( rs_cnf_data ).
    LOOP AT lo_abap_structdescr->components ASSIGNING FIELD-SYMBOL(<ls_abap_component>).

      DATA(lv_param) = |CNF_{ <ls_abap_component>-name }|.

      ASSIGN COMPONENT lv_param OF STRUCTURE rs_cnf_data TO FIELD-SYMBOL(<rx_data>).
      CHECK <rx_data> IS ASSIGNED.

      ASSIGN lt_shm_data[ param = lv_param ]-value TO FIELD-SYMBOL(<lr_shm_value>).
      CHECK <lr_shm_value> IS ASSIGNED.

      ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
      CHECK <l_shm_value> IS ASSIGNED.

      <rx_data> = <l_shm_value>.

      UNASSIGN: <rx_data>, <l_shm_value>, <lr_shm_value>.

    ENDLOOP.

  ENDMETHOD.


  METHOD set.

  ENDMETHOD.

ENDCLASS.
