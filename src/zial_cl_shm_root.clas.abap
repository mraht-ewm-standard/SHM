CLASS zial_cl_shm_root DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  SHARED MEMORY ENABLED.

  PUBLIC SECTION.
    INTERFACES if_shm_build_instance.

    METHODS set
      IMPORTING is_data TYPE zial_s_shm_data.

    METHODS get
      RETURNING VALUE(rs_data) TYPE zial_s_shm_data.

    METHODS add
      IMPORTING is_data TYPE zial_s_shm_data.

  PROTECTED SECTION.
    DATA ms_data TYPE zial_s_shm_data.

ENDCLASS.


CLASS zial_cl_shm_root IMPLEMENTATION.

  METHOD if_shm_build_instance~build.

    DATA lo_root TYPE REF TO zial_cl_shm_root.

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


  METHOD add.

    DATA lo_abap_structdescr TYPE REF TO cl_abap_structdescr.

    FIELD-SYMBOLS <mt_data> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.

    lo_abap_structdescr ?= cl_abap_structdescr=>describe_by_data( is_data ).
    LOOP AT lo_abap_structdescr->components ASSIGNING FIELD-SYMBOL(<ls_abap_component>).

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE me->ms_data TO FIELD-SYMBOL(<mx_data>).
      CHECK <mx_data> IS ASSIGNED.

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE is_data TO FIELD-SYMBOL(<ix_data>).
      CHECK <ix_data> IS ASSIGNED
        AND <ix_data> IS NOT INITIAL.

      CASE <ls_abap_component>-type_kind.
        WHEN cl_abap_datadescr=>typekind_table.
          ASSIGN <mx_data> TO <mt_data>.
          CHECK <mt_data> IS ASSIGNED.

          ASSIGN <ix_data> TO <lt_data>.
          CHECK <lt_data> IS ASSIGNED.

          LOOP AT <lt_data> ASSIGNING FIELD-SYMBOL(<ls_data>).
            DATA(lv_exists) = abap_false.
            LOOP AT <mt_data> ASSIGNING FIELD-SYMBOL(<ms_data>).
              CHECK <ms_data> EQ <ls_data>.
              lv_exists = abap_true.
              <ms_data> = <ls_data>.
              EXIT.
            ENDLOOP.

            IF lv_exists EQ abap_false.
              INSERT <ls_data> INTO TABLE <mt_data>.
            ENDIF.
          ENDLOOP.

        WHEN OTHERS.
          <mx_data> = <ix_data>.

      ENDCASE.

      UNASSIGN: <mx_data>, <ix_data>.

    ENDLOOP.

  ENDMETHOD.


  METHOD get.

    rs_data = me->ms_data.

  ENDMETHOD.


  METHOD set.

    DATA lo_abap_structdescr TYPE REF TO cl_abap_structdescr.

    lo_abap_structdescr ?= cl_abap_structdescr=>describe_by_data( is_data ).
    LOOP AT lo_abap_structdescr->components ASSIGNING FIELD-SYMBOL(<ls_abap_component>).

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE me->ms_data TO FIELD-SYMBOL(<mx_data>).
      CHECK <mx_data> IS ASSIGNED.

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE is_data TO FIELD-SYMBOL(<ix_data>).
      CHECK <ix_data> IS ASSIGNED.

      <mx_data> = <ix_data>.

      UNASSIGN: <mx_data>, <ix_data>.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
