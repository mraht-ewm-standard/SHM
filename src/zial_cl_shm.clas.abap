"! <p class="shorttext synchronized">Shared memory: API class</p>
"! <p><strong>Note:</strong>
"! <ul>
"! <li>Don't use it for handling data that changes multiple times per day but
"! instead only for master and customizing data as the performance gain decreases
"! with the increase of write accesses to the SHM</li>
"! <li>Use it to share data between different server applications and processes</li>
"! <li>Use it to increase performance by avoiding database calls</li>
"! </ul></p>
"! <p><strong>Transactions:</strong><ul>
"! <li>SHMA (Administration)</li>
"! <li>SHMM (Content)</li>
"! </ul></p>
CLASS zial_cl_shm DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS get
      RETURNING VALUE(rt_shm_data) TYPE zial_tt_shm_data
      RAISING   zcx_error.

    CLASS-METHODS set
      IMPORTING it_shm_data TYPE zial_tt_shm_data
      RAISING   zcx_error.

    CLASS-METHODS free.

    CLASS-METHODS get_by_component
      IMPORTING iv_component_id   TYPE zial_de_shm_component_id
                ir_component_data TYPE REF TO data
      RAISING   zcx_error.

    CLASS-METHODS set_by_component
      IMPORTING iv_component_id   TYPE zial_de_shm_component_id
                ir_component_data TYPE REF TO data
      RAISING   zcx_error.

    CLASS-METHODS get_by_component_param
      IMPORTING iv_param_name TYPE zial_de_shm_parameter_name
                ir_param_data TYPE REF TO data
      RAISING   zcx_error.

    CLASS-METHODS set_by_component_param
      IMPORTING iv_param_name TYPE zial_de_shm_parameter_name
                ir_param_data TYPE REF TO data
      RAISING   zcx_error.

ENDCLASS.


CLASS zial_cl_shm IMPLEMENTATION.

  METHOD free.

    zial_cl_shm_area=>detach_all_areas( ).
    zial_cl_shm_area=>invalidate_area( ).
    zial_cl_shm_area=>free_area( ).

  ENDMETHOD.


  METHOD get.

    DATA(lv_retried) = abap_false.

    TRY.
        DATA(lo_area) = zial_cl_shm_area=>attach_for_read( ).
        rt_shm_data = lo_area->root->unbind_data_ref_from_area( lo_area ).
        lo_area->detach( ).

      CATCH cx_root INTO DATA(lx_error).
        CASE lv_retried.
          WHEN abap_true.
            RAISE EXCEPTION TYPE zcx_error
              EXPORTING previous = lx_error.

          WHEN abap_false.
            lv_retried = abap_true.
            zial_cl_shm_area=>build( ).
            RETRY.

        ENDCASE.

    ENDTRY.

  ENDMETHOD.


  METHOD set.

    DATA(lv_retried) = abap_false.

    TRY.
        DATA(lo_area) = zial_cl_shm_area=>attach_for_update( ).
        DATA(lt_shm_data) = lo_area->root->bind_data_ref_to_area( io_area     = lo_area
                                                                  it_shm_data = it_shm_data ).
        lo_area->root->set_shm_data( lt_shm_data ).
        lo_area->detach_commit( ).

      CATCH cx_root INTO DATA(lx_error).
        CASE lv_retried.
          WHEN abap_true.
            RAISE EXCEPTION TYPE zcx_error
              EXPORTING previous = lx_error.

          WHEN abap_false.
            lv_retried = abap_true.
            zial_cl_shm_area=>build( ).
            RETRY.

        ENDCASE.

    ENDTRY.

  ENDMETHOD.


  METHOD get_by_component.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).

    ASSIGN ir_component_data->* TO FIELD-SYMBOL(<ls_component_data>).
    CHECK <ls_component_data> IS ASSIGNED.

    DATA(lo_abap_structdescr) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( <ls_component_data> ) ).
    LOOP AT lo_abap_structdescr->components ASSIGNING FIELD-SYMBOL(<ls_abap_component>).

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE <ls_component_data> TO FIELD-SYMBOL(<rx_data>).
      CHECK <rx_data> IS ASSIGNED.

      DATA(lv_param) = CONV zial_de_shm_parameter_name( |{ iv_component_id }_{ <ls_abap_component>-name }| ).
      ASSIGN lt_shm_data[ param = lv_param ]-value TO FIELD-SYMBOL(<lr_shm_value>).
      CHECK <lr_shm_value> IS ASSIGNED.

      ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
      CHECK <l_shm_value> IS ASSIGNED.

      <rx_data> = CORRESPONDING #( <l_shm_value> ). " To avoid dumps in case of changed structures

      UNASSIGN: <rx_data>, <l_shm_value>, <lr_shm_value>.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_by_component_param.

    ASSIGN ir_param_data->* TO FIELD-SYMBOL(<l_param_data>).
    CHECK <l_param_data> IS ASSIGNED.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = iv_param_name ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    CHECK <lr_shm_value> IS ASSIGNED.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_param_data> = CORRESPONDING #( <l_shm_value> ). " To avoid dumps in case of changed structures

  ENDMETHOD.


  METHOD set_by_component.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    DATA(lt_shm_data_bck) = lt_shm_data.

    ASSIGN ir_component_data->* TO FIELD-SYMBOL(<ls_component_data>).
    CHECK <ls_component_data> IS ASSIGNED.

    DATA(lo_abap_structdescr) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( <ls_component_data> ) ).
    LOOP AT lo_abap_structdescr->components ASSIGNING FIELD-SYMBOL(<ls_abap_component>).

      ASSIGN COMPONENT <ls_abap_component>-name OF STRUCTURE <ls_component_data> TO FIELD-SYMBOL(<i_component_data>).
      CHECK <i_component_data> IS ASSIGNED.

      DATA(lv_param_name) = CONV zial_de_shm_parameter_name( |{ iv_component_id }_{ <ls_abap_component>-name }| ).
      ASSIGN lt_shm_data[ param = lv_param_name ]-value TO FIELD-SYMBOL(<lr_shm_value>).
      IF <lr_shm_value> IS NOT ASSIGNED.
        INSERT VALUE #( param = lv_param_name ) INTO TABLE lt_shm_data ASSIGNING FIELD-SYMBOL(<ls_shm_data>).
        CREATE DATA <ls_shm_data>-value LIKE <i_component_data>.
        ASSIGN <ls_shm_data>-value TO <lr_shm_value>.
      ENDIF.

      ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
      CHECK <l_shm_value> IS ASSIGNED.

      <l_shm_value> = CORRESPONDING #( <i_component_data> ). " To avoid dumps in case of changed structures

      UNASSIGN: <i_component_data>, <l_shm_value>, <lr_shm_value>, <ls_shm_data>.

    ENDLOOP.

    CHECK lt_shm_data NE lt_shm_data_bck.
    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.


  METHOD set_by_component_param.

    ASSIGN ir_param_data->* TO FIELD-SYMBOL(<l_param_data>).
    CHECK <l_param_data> IS ASSIGNED.

    DATA(lt_shm_data) = zial_cl_shm=>get( ).
    ASSIGN lt_shm_data[ param = iv_param_name ]-value TO FIELD-SYMBOL(<lr_shm_value>).
    IF <lr_shm_value> IS NOT ASSIGNED.
      INSERT VALUE #( param = iv_param_name ) INTO TABLE lt_shm_data ASSIGNING FIELD-SYMBOL(<ls_shm_data>).
      CREATE DATA <ls_shm_data>-value LIKE <l_param_data>.
      ASSIGN <ls_shm_data>-value TO <lr_shm_value>.
    ENDIF.

    ASSIGN <lr_shm_value>->* TO FIELD-SYMBOL(<l_shm_value>).
    CHECK <l_shm_value> IS ASSIGNED.

    <l_shm_value> = CORRESPONDING #( <l_param_data> ). " To avoid dumps in case of changed structures

    zial_cl_shm=>set( lt_shm_data ).

  ENDMETHOD.

ENDCLASS.
