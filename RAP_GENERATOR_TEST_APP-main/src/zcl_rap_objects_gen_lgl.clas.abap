CLASS zcl_rap_objects_gen_lgl DEFINITION
INHERITING FROM zcl_rap_extensions_gen_lgl
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_rap_objects_gen_lgl IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    debug_modus = abap_true.

*    transport = 'D23K900976'. " <-- maintain your transport request here
    package_name           = co_prefix && unique_suffix.
    extension_package_name = package_name && '_EXT' .

    DATA(lo_transport_target) = xco_lib->get_package( co_software_component_base_bo
              )->read( )-property-transport_layer->get_transport_target( ).

    DATA(new_transport_object) = xco_cp_cts=>transports->workbench( lo_transport_target->value  )->create_request( |Package name: { package_name } | ).
    transport = new_transport_object->value.


    DATA(lo_transport_target_ext) = xco_lib->get_package( co_software_component_ext_bo
              )->read( )-property-transport_layer->get_transport_target( ).

    DATA(new_transport_object_ext) = xco_cp_cts=>transports->workbench( lo_transport_target_ext->value  )->create_request( |Package name: { extension_package_name } | ).
    transport_extensions = new_transport_object_ext->value.

    out->write( | { co_session_name } exercise generator | ).
    out->write( | ------------------------------------- | ).
    .

    "database tables
    table_name_root               = to_upper( |{ co_prefix }ashop{ unique_suffix }| ).
    draft_table_name_root         = to_upper( |{ co_prefix }dshop{ unique_suffix }| ).
    "CDS views
    r_view_name_travel            = to_upper( |{ co_prefix }R_{ co_entity_name }TP_{ unique_suffix }| ).
    c_view_name_travel            = to_upper( |{ co_prefix }C_{ co_entity_name }TP_{ unique_suffix }| ).
    i_view_name_travel            = |{ co_prefix }I_{ co_entity_name }TP_{ unique_suffix }|.
    i_view_basic_name_travel      = |{ co_prefix }I_{ co_entity_name }_{ unique_suffix }|.
    "behavior pools
    beh_impl_name_travel          = |{ co_prefix }BP_{ co_entity_name }TP_{ unique_suffix }|.
    "business service
    srv_definition_name           = |{ co_prefix }UI_{ co_entity_name }_{ unique_suffix }|.
    srv_binding_o4_name           = |{ co_prefix }UI_{ co_entity_name }_O4_{ unique_suffix }|.


    " to upper
    package_name  = to_upper( package_name ).
    unique_suffix = to_upper( unique_suffix ).

    out->write( | Use transport { transport }| ).

    DATA(my_package) = xco_lib->get_package( package_name ).
    IF my_package->exists( ) = abap_false.
      out->write( | Info: Suffix "{ unique_suffix }" will be used. | ).
    ELSE.
      out->write( | Note: Package "{ package_name }" already exists. | ).
    ENDIF.

    TRY.
        "create package
        create_package( transport ).
        create_extension_package( transport_extensions ).
      CATCH cx_xco_gen_put_exception INTO DATA(put_exception).
        out->write( 'error creating packages' ).
        DATA(lt_findings) = put_exception->findings->get( ).
        LOOP AT lt_findings INTO DATA(finding).
          out->write( finding->message->get_text(  ) ).
        ENDLOOP.
        EXIT.
      CATCH cx_root INTO DATA(package_exception).
        IF debug_modus = abap_true.
          out->write( | Error during create_package( ). | ).
        ENDIF.
        EXIT.
    ENDTRY.

    data_generator_class_name     = |zraplg_cl_vh_product_{ unique_suffix }|.


    TRY.

        generate_vh_custom_entity( transport ).
*        generate_behavior_impl_class( transport ).
      CATCH cx_xco_gen_put_exception INTO DATA(put_vh_exception).
        out->write( 'error creating custom entity' ).
        lt_findings = put_vh_exception->findings->get( ).
        LOOP AT lt_findings INTO finding.
          out->write( finding->message->get_text(  ) ).
        ENDLOOP.
        EXIT.
    ENDTRY.

    mo_environment                 = get_environment( transport ).
    mo_put_operation               = get_put_operation( mo_environment )."->create_put_operation( ).

    TRY.
        create_rap_bo(
          EXPORTING
            out          = out
          IMPORTING
            eo_root_node = DATA(root_node)
        ).
      CATCH cx_xco_gen_put_exception INTO put_exception.
        out->write( 'error creating rap bo' ).
        lt_findings = put_exception->findings->get( ).
        LOOP AT lt_findings INTO finding.
          out->write( | { finding->message->get_type( )->value }: { finding->message->get_text(  ) } | ).
        ENDLOOP.
        EXIT.
    ENDTRY.
    out->write( | The following packages got created for you and will include everything you need: | ).
    out->write( | - "{ package_name }"     and | ).
    out->write( | - "{ extension_package_name }" | ).
    out->write( | In the "Project Explorer" right click on "Favorite Packages" and click on "Add Package...". | ).
    out->write( | Select both (!) packages "{ package_name }" and { extension_package_name } and click OK. | ).
    out->write( | The generation process has been started asynchronously in the backend | ).
    out->write( | and it will take some minutes to complete. | ).
  ENDMETHOD.
ENDCLASS.
