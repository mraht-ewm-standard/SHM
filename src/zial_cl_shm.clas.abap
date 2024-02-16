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
      IMPORTING it_r_params        TYPE rseloption OPTIONAL
      RETURNING VALUE(rt_shm_data) TYPE zial_tt_shm_data
      RAISING   zcx_error.

    CLASS-METHODS set
      IMPORTING it_shm_data TYPE zial_tt_shm_data
      RAISING   zcx_error.

    CLASS-METHODS free.

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
        rt_shm_data = lo_area->root->unbind_data_ref_from_area( io_area     = lo_area
                                                                it_r_params = it_r_params ).
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

ENDCLASS.
