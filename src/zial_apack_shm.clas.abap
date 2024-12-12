"! <p class="shorttext synchronized">Metadata: Shared Memory</p>
CLASS zial_apack_shm DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apack_manifest.

    METHODS constructor.

ENDCLASS.


CLASS zial_apack_shm IMPLEMENTATION.

  METHOD constructor.

    if_apack_manifest~descriptor-group_id     = 'c-a-s.de'.
    if_apack_manifest~descriptor-artifact_id  = 'shm'.
    if_apack_manifest~descriptor-version      = '15.02.2024.001-rc'.
    if_apack_manifest~descriptor-git_url      = 'https://github.com/mraht-ewm-standard/SHM.git' ##NO_TEXT.

    if_apack_manifest~descriptor-dependencies = VALUE #(
        group_id = 'c-a-s.de'
        ( artifact_id    = 'exc-mgmt'
          target_package = 'ZIAL_EXC_MGMT'
          git_url        = 'https://github.com/mraht-ewm-standard/EXC_MGMT.git' )
        ( artifact_id    = 'aunit'
          target_package = 'ZIAL_AUNIT'
          git_url        = 'https://github.com/mraht-ewm-standard/AUNIT.git' ) ) ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.
