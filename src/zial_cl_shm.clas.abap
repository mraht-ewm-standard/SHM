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
    "! <p class="shorttext synchronized">Set buffered data</p>
    "!
    "! @parameter is_data   | <p class="shorttext synchronized">Data to be buffered</p>
    "! @raising   zcx_error | <p class="shorttext synchronized">Error</p>
    CLASS-METHODS set
      IMPORTING is_data TYPE zial_s_shm_data
      RAISING   zcx_error.

    "! <p class="shorttext synchronized">Add data to buffered data</p>
    "!
    "! @parameter is_data   | <p class="shorttext synchronized">Data to be added to buffered data</p>
    "! @raising   zcx_error | <p class="shorttext synchronized">Error</p>
    CLASS-METHODS add
      IMPORTING is_data TYPE zial_s_shm_data
      RAISING   zcx_error.

    "! <p class="shorttext synchronized">Get buffered data</p>
    "!
    "! @parameter rs_data   | <p class="shorttext synchronized">Buffered data</p>
    "! @raising   zcx_error | <p class="shorttext synchronized">Error</p>
    CLASS-METHODS get
      RETURNING VALUE(rs_data) TYPE zial_s_shm_data
      RAISING   zcx_error.

    "! <p class="shorttext synchronized">Clear all data in buffer</p>
    "!
    "! @raising zcx_error | <p class="shorttext synchronized">Error</p>
    CLASS-METHODS clear
      RAISING zcx_error.

    CLASS-METHODS close.

ENDCLASS.


CLASS zial_cl_shm IMPLEMENTATION.

  METHOD set.

    DATA(lv_retried) = abap_false.

    TRY.
        DATA(lo_area) = zial_cl_shm_area=>attach_for_update( ).
        lo_area->root->set( is_data ).
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


  METHOD get.

    DATA(lv_retried) = abap_false.

    TRY.
        DATA(lo_area) = zial_cl_shm_area=>attach_for_read( ).
        rs_data = lo_area->root->get( ).
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


  METHOD add.

    DATA(lv_retried) = abap_false.

    TRY.
        DATA(lo_area) = zial_cl_shm_area=>attach_for_update( ).
        lo_area->root->add( is_data ).
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


  METHOD clear.

    set( VALUE #( ) ).

  ENDMETHOD.


  METHOD close.

    zial_cl_shm_area=>detach_all_areas( ).
    zial_cl_shm_area=>invalidate_area( ).
    zial_cl_shm_area=>free_area( ).

  ENDMETHOD.

ENDCLASS.
