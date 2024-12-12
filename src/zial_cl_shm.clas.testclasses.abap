"! <p class="shorttext synchronized">ABAP Unit Test Class Template</p>
CLASS ltc_shm DEFINITION FINAL
  CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES: BEGIN OF s_tdc_data,
             param TYPE zial_de_shm_parameter_name,
             value TYPE bux_dummy_tabtype,
           END OF s_tdc_data.

    CONSTANTS mc_tdc_cnt TYPE etobj_name VALUE 'ZIAL_TDC_SHM'.

    CLASS-DATA mo_aunit    TYPE REF TO zial_cl_aunit.
    CLASS-DATA ms_tdc_data TYPE s_tdc_data.

    CLASS-METHODS class_setup
      RAISING cx_ecatt_tdc_access.

    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS t0001_set  FOR TESTING RAISING cx_static_check.
    METHODS t0002_get  FOR TESTING RAISING cx_static_check.
    METHODS t0003_free FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_shm IMPLEMENTATION.

  METHOD class_setup.

    mo_aunit = zial_cl_aunit=>on_class_setup( iv_tdc_cnt  = mc_tdc_cnt
                                              ir_tdc_data = REF #( ms_tdc_data ) ).

  ENDMETHOD.


  METHOD setup.

    mo_aunit->on_setup( ).

  ENDMETHOD.


  METHOD teardown.

    mo_aunit->on_teardown( ).

  ENDMETHOD.


  METHOD class_teardown.

    mo_aunit->on_class_teardown( ).

  ENDMETHOD.


  METHOD t0001_set.

    CHECK mo_aunit->active( abap_true ).

    DATA(lt_shm_data) = VALUE zial_tt_shm_data( ( param = ms_tdc_data-param
                                                  value = REF #( ms_tdc_data-value ) ) ).
    zial_cl_shm=>set( lt_shm_data ).

    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = 1 ).

  ENDMETHOD.


  METHOD t0002_get.

    CHECK mo_aunit->active( abap_true ).

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_shm_data ).

  ENDMETHOD.


  METHOD t0003_free.

    CHECK mo_aunit->active( abap_true ).

    zial_cl_shm=>free( ).
    DATA(lt_shm_data) = zial_cl_shm=>get( ).

    cl_abap_unit_assert=>assert_initial( act = lt_shm_data ).

  ENDMETHOD.

ENDCLASS.
