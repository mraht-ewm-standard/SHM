CLASS zial_cl_shm_data DEFINITION
  PUBLIC FINAL
  CREATE PROTECTED
  SHARED MEMORY ENABLED.

  PUBLIC SECTION.
    INTERFACES if_shm_build_instance.

    METHODS get_shm_data
      RETURNING VALUE(rt_shm_data) TYPE zial_tt_shm_data.

    METHODS set_shm_data
      IMPORTING it_shm_data TYPE zial_tt_shm_data.

    METHODS add_shm_data
      IMPORTING is_shm_data TYPE zial_s_shm_data.

    METHODS bind_data_ref_to_area
      IMPORTING io_area            TYPE REF TO zial_cl_shm_area
                it_shm_data        TYPE zial_tt_shm_data
      RETURNING VALUE(rt_shm_data) TYPE zial_tt_shm_data.

    METHODS unbind_data_ref_from_area
      IMPORTING io_area            TYPE REF TO zial_cl_shm_area
                it_r_params        TYPE rseloption
      RETURNING VALUE(rt_shm_data) TYPE zial_tt_shm_data.

  PROTECTED SECTION.
    DATA mt_shm_data TYPE zial_tt_shm_data.

ENDCLASS.


CLASS zial_cl_shm_data IMPLEMENTATION.

  METHOD if_shm_build_instance~build.

    DATA lo_root TYPE REF TO zial_cl_shm_data.

    TRY.
        zial_cl_shm_area=>detach_area( ).
        DATA(lo_area) = zial_cl_shm_area=>attach_for_write( ).

        CREATE OBJECT lo_root AREA HANDLE lo_area.
        lo_area->set_root( lo_root ).

        lo_area->detach_commit( ).

      CATCH cx_root INTO DATA(lx_error).
        RAISE EXCEPTION TYPE cx_shm_build_failed
          EXPORTING previous = lx_error.

    ENDTRY.

  ENDMETHOD.


  METHOD get_shm_data.

    rt_shm_data = mt_shm_data.

  ENDMETHOD.


  METHOD set_shm_data.

    mt_shm_data = it_shm_data.

  ENDMETHOD.


  METHOD add_shm_data.

    CHECK is_shm_data-param CN ' _0'.

    IF line_exists( mt_shm_data[ param = is_shm_data-param ] ).
      MODIFY TABLE mt_shm_data FROM is_shm_data.
    ELSE.
      INSERT is_shm_data INTO TABLE mt_shm_data.
    ENDIF.

  ENDMETHOD.


  METHOD bind_data_ref_to_area.

    LOOP AT it_shm_data ASSIGNING FIELD-SYMBOL(<is_shm_data>).
      INSERT VALUE #( param = <is_shm_data>-param ) INTO TABLE rt_shm_data ASSIGNING FIELD-SYMBOL(<rs_shm_data>).
      ASSIGN <is_shm_data>-value->* TO FIELD-SYMBOL(<is_value>).
      CREATE DATA <rs_shm_data>-value AREA HANDLE io_area LIKE <is_value>.
      ASSIGN <rs_shm_data>-value->* TO FIELD-SYMBOL(<rs_value>).
      <rs_value> = <is_value>.
    ENDLOOP.

  ENDMETHOD.


  METHOD unbind_data_ref_from_area.

    DATA(lt_shm_data) = io_area->root->get_shm_data( ).
    LOOP AT lt_shm_data ASSIGNING FIELD-SYMBOL(<ls_shm_data>) WHERE param IN it_r_params.
      INSERT VALUE #( param = <ls_shm_data>-param ) INTO TABLE rt_shm_data ASSIGNING FIELD-SYMBOL(<rs_shm_data>).
      ASSIGN <ls_shm_data>-value->* TO FIELD-SYMBOL(<ls_value>).
      CREATE DATA <rs_shm_data>-value LIKE <ls_value>.
      ASSIGN <rs_shm_data>-value->* TO FIELD-SYMBOL(<rs_value>).
      <rs_value> = <ls_value>.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
