CLASS zial_cl_cnf_shm DEFINITION
  PUBLIC
  INHERITING FROM zial_cl_shm FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_rul
      RETURNING VALUE(rt_cnf_rul) TYPE zial_tt_cnf_rul_int
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

    DATA(lt_shm_data) = get( ).

    ASSIGN lt_shm_data[ param = mc_params-par ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    rt_cnf_rul = <l_shm_value>.

  ENDMETHOD.

ENDCLASS.
