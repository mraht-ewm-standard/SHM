"! <p class="shorttext synchronized">ABAP Unit Test Class Template</p>
CLASS lcl_aunit DEFINITION FINAL
  CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES: BEGIN OF s_tdc_data,
             wt_excluded     TYPE /scwm/tt_tanum,
             wt_excluded_add TYPE /scwm/tt_tanum,
           END OF s_tdc_data.

    CONSTANTS mc_tdc_cnt           TYPE etobj_name VALUE 'ZIAL_CL_SHM'.
    CONSTANTS mc_tdc_dflt_var_name TYPE etvar_id   VALUE 'ECATTDEFAULT'.

    CLASS-DATA mo_tdc          TYPE REF TO cl_apl_ecatt_tdc_api.
    CLASS-DATA mv_tdc_var_name TYPE etvar_id.
    CLASS-DATA ms_tdc_data     TYPE s_tdc_data.

    CLASS-METHODS class_setup
      RAISING cx_ecatt_tdc_access.

    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS t0001_set   FOR TESTING RAISING cx_root.
    METHODS t0002_get   FOR TESTING RAISING cx_root.
    METHODS t0003_add   FOR TESTING RAISING cx_root.
    METHODS t0004_clear FOR TESTING RAISING cx_root.

ENDCLASS.


CLASS lcl_aunit IMPLEMENTATION.

  METHOD class_setup.

    mo_tdc = cl_apl_ecatt_tdc_api=>get_instance( i_testdatacontainer = mc_tdc_cnt ).

    mv_tdc_var_name = |{ sy-sysid }{ sy-mandt }|.
    DATA(lt_tdc_var) = mo_tdc->get_variant_list( ).
    IF NOT line_exists( lt_tdc_var[ table_line = mv_tdc_var_name ] ).
      mv_tdc_var_name = mc_tdc_dflt_var_name.
    ENDIF.

    LOOP AT mo_tdc->get_variant_content( mv_tdc_var_name ) ASSIGNING FIELD-SYMBOL(<ls_tdc_var_content>).
      ASSIGN COMPONENT <ls_tdc_var_content>-parname OF STRUCTURE ms_tdc_data TO FIELD-SYMBOL(<lv_tdc_value>).
      CHECK <lv_tdc_value> IS ASSIGNED.
      ASSIGN <ls_tdc_var_content>-value_ref->* TO FIELD-SYMBOL(<lv_tdc_var_value>).
      CHECK <lv_tdc_var_value> IS ASSIGNED.
      <lv_tdc_value> = <lv_tdc_var_value>.
      UNASSIGN: <lv_tdc_value>, <lv_tdc_var_value>.
    ENDLOOP.

  ENDMETHOD.


  METHOD class_teardown.
  ENDMETHOD.


  METHOD setup.
  ENDMETHOD.


  METHOD teardown.
  ENDMETHOD.


  METHOD t0001_set.

    " CHECK 1 = 2. ##DEACTIVE.

    zial_cl_shm=>set( VALUE #( mfs_wts_to_exclude = ms_tdc_data-wt_excluded ) ).
    DATA(ls_data) = zial_cl_shm=>get( ).

    LOOP AT ms_tdc_data-wt_excluded ASSIGNING FIELD-SYMBOL(<ls_wt_excluded>).
      cl_abap_unit_assert=>assert_table_contains( line  = <ls_wt_excluded>
                                                  table = ls_data-mfs_wts_to_exclude ).
    ENDLOOP.

  ENDMETHOD.


  METHOD t0002_get.

    " CHECK 1 = 2. ##DEACTIVE.

    DATA(ls_data) = zial_cl_shm=>get( ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_data-mfs_wts_to_exclude ).

  ENDMETHOD.


  METHOD t0003_add.

    " CHECK 1 = 2. ##DEACTIVE.

    zial_cl_shm=>add( VALUE #( mfs_wts_to_exclude = ms_tdc_data-wt_excluded_add ) ).
    DATA(ls_data) = zial_cl_shm=>get( ).

    LOOP AT ms_tdc_data-wt_excluded_add ASSIGNING FIELD-SYMBOL(<ls_wt_excluded>).
      cl_abap_unit_assert=>assert_table_contains( line  = <ls_wt_excluded>
                                                  table = ls_data-mfs_wts_to_exclude ).
    ENDLOOP.

  ENDMETHOD.


  METHOD t0004_clear.

    " CHECK 1 = 2. ##DEACTIVE.

    zial_cl_shm=>clear( ).
    DATA(ls_shm_data) = zial_cl_shm=>get( ).

    cl_abap_unit_assert=>assert_initial( act = ls_shm_data ).

  ENDMETHOD.

ENDCLASS.
