--
-- PostgreSQL database dump
--

\restrict vDMXUpsO76VQwGCbM9c3YX9L6ja2ycr4zxIzQBrYspCpnrd9XRHQhiL6AmxMWqc

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.work_session DROP CONSTRAINT IF EXISTS work_session_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session DROP CONSTRAINT IF EXISTS work_session_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session_break DROP CONSTRAINT IF EXISTS work_session_break_work_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session_break DROP CONSTRAINT IF EXISTS work_session_break_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session_adjustment DROP CONSTRAINT IF EXISTS work_session_adjustment_work_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session_adjustment DROP CONSTRAINT IF EXISTS work_session_adjustment_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.work_session_adjustment DROP CONSTRAINT IF EXISTS work_session_adjustment_actor_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.warehouse DROP CONSTRAINT IF EXISTS warehouse_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.warehouse_stock DROP CONSTRAINT IF EXISTS warehouse_stock_warehouse_id_fkey;
ALTER TABLE IF EXISTS ONLY public.warehouse_stock DROP CONSTRAINT IF EXISTS warehouse_stock_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.warehouse_stock DROP CONSTRAINT IF EXISTS warehouse_stock_inventory_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.waiting_list_entry DROP CONSTRAINT IF EXISTS waiting_list_entry_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT IF EXISTS user_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT IF EXISTS user_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tse_transaction DROP CONSTRAINT IF EXISTS tse_transaction_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tse_transaction DROP CONSTRAINT IF EXISTS tse_transaction_storno_of_tse_transaction_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tse_transaction DROP CONSTRAINT IF EXISTS tse_transaction_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_tax_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_provider_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenant DROP CONSTRAINT IF EXISTS tenant_default_tax_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenant DROP CONSTRAINT IF EXISTS tenant_default_kitchen_station_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tenant DROP CONSTRAINT IF EXISTS tenant_default_bar_station_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tax DROP CONSTRAINT IF EXISTS tax_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS table_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS table_table_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_group DROP CONSTRAINT IF EXISTS table_group_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS table_floor_id_fkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS table_assigned_waiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.supplier DROP CONSTRAINT IF EXISTS supplier_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract DROP CONSTRAINT IF EXISTS staff_contract_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract_template DROP CONSTRAINT IF EXISTS staff_contract_template_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract DROP CONSTRAINT IF EXISTS staff_contract_subject_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract DROP CONSTRAINT IF EXISTS staff_contract_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_post DROP CONSTRAINT IF EXISTS social_post_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_post_target DROP CONSTRAINT IF EXISTS social_post_target_social_post_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_post DROP CONSTRAINT IF EXISTS social_post_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_oauth_state DROP CONSTRAINT IF EXISTS social_oauth_state_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_oauth_state DROP CONSTRAINT IF EXISTS social_oauth_state_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.social_connection DROP CONSTRAINT IF EXISTS social_connection_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shift DROP CONSTRAINT IF EXISTS shift_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shift DROP CONSTRAINT IF EXISTS shift_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_group_member DROP CONSTRAINT IF EXISTS restaurant_group_member_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_group_member DROP CONSTRAINT IF EXISTS restaurant_group_member_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_group DROP CONSTRAINT IF EXISTS restaurant_group_hub_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reservation DROP CONSTRAINT IF EXISTS reservation_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reservation DROP CONSTRAINT IF EXISTS reservation_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reservation DROP CONSTRAINT IF EXISTS reservation_preferred_floor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order DROP CONSTRAINT IF EXISTS purchase_order_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order DROP CONSTRAINT IF EXISTS purchase_order_supplier_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order_item DROP CONSTRAINT IF EXISTS purchase_order_item_purchase_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order_item DROP CONSTRAINT IF EXISTS purchase_order_item_inventory_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order DROP CONSTRAINT IF EXISTS purchase_order_created_by_id_fkey;
ALTER TABLE IF EXISTS ONLY public.providerproduct DROP CONSTRAINT IF EXISTS providerproduct_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY public.providerproduct DROP CONSTRAINT IF EXISTS providerproduct_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY public.provider DROP CONSTRAINT IF EXISTS provider_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product DROP CONSTRAINT IF EXISTS product_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product DROP CONSTRAINT IF EXISTS product_tax_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_recipe DROP CONSTRAINT IF EXISTS product_recipe_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_recipe DROP CONSTRAINT IF EXISTS product_recipe_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_recipe DROP CONSTRAINT IF EXISTS product_recipe_inventory_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_question DROP CONSTRAINT IF EXISTS product_question_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_question DROP CONSTRAINT IF EXISTS product_question_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product DROP CONSTRAINT IF EXISTS product_kitchen_station_id_fkey;
ALTER TABLE IF EXISTS ONLY public.print_job DROP CONSTRAINT IF EXISTS print_job_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.print_job DROP CONSTRAINT IF EXISTS print_job_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.print_job DROP CONSTRAINT IF EXISTS print_job_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.print_job DROP CONSTRAINT IF EXISTS print_job_claimed_by_agent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.print_agent DROP CONSTRAINT IF EXISTS print_agent_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.price_promotion DROP CONSTRAINT IF EXISTS price_promotion_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_token DROP CONSTRAINT IF EXISTS password_reset_token_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orderitem DROP CONSTRAINT IF EXISTS orderitem_tax_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orderitem DROP CONSTRAINT IF EXISTS orderitem_promo_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orderitem DROP CONSTRAINT IF EXISTS orderitem_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_tip_attributed_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment DROP CONSTRAINT IF EXISTS order_payment_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment DROP CONSTRAINT IF EXISTS order_payment_paid_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment DROP CONSTRAINT IF EXISTS order_payment_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment_item DROP CONSTRAINT IF EXISTS order_payment_item_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment_item DROP CONSTRAINT IF EXISTS order_payment_item_order_payment_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payment_item DROP CONSTRAINT IF EXISTS order_payment_item_order_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_loyalty_membership_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_delivery_integration_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_deleted_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_courier_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_billing_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.opening_hours_date_override DROP CONSTRAINT IF EXISTS opening_hours_date_override_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.opening_hours_baseline_schedule DROP CONSTRAINT IF EXISTS opening_hours_baseline_schedule_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.offline_order_idempotency DROP CONSTRAINT IF EXISTS offline_order_idempotency_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.offline_order_idempotency DROP CONSTRAINT IF EXISTS offline_order_idempotency_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_program DROP CONSTRAINT IF EXISTS loyalty_program_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_membership DROP CONSTRAINT IF EXISTS loyalty_membership_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_membership DROP CONSTRAINT IF EXISTS loyalty_membership_referred_by_membership_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_membership DROP CONSTRAINT IF EXISTS loyalty_membership_program_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_membership DROP CONSTRAINT IF EXISTS loyalty_membership_billing_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_ledger_entry DROP CONSTRAINT IF EXISTS loyalty_ledger_entry_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_ledger_entry DROP CONSTRAINT IF EXISTS loyalty_ledger_entry_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_ledger_entry DROP CONSTRAINT IF EXISTS loyalty_ledger_entry_membership_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_ledger_entry DROP CONSTRAINT IF EXISTS loyalty_ledger_entry_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_apple_device DROP CONSTRAINT IF EXISTS loyalty_apple_device_membership_id_fkey;
ALTER TABLE IF EXISTS ONLY public.login_event DROP CONSTRAINT IF EXISTS login_event_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.login_event DROP CONSTRAINT IF EXISTS login_event_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.login_event DROP CONSTRAINT IF EXISTS login_event_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kitchen_station DROP CONSTRAINT IF EXISTS kitchen_station_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_warehouse_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_purchase_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_inventory_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_created_by_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_batch_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS inventory_item_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS inventory_item_default_supplier_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_batch DROP CONSTRAINT IF EXISTS inventory_batch_warehouse_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_batch DROP CONSTRAINT IF EXISTS inventory_batch_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_batch DROP CONSTRAINT IF EXISTS inventory_batch_purchase_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inventory_batch DROP CONSTRAINT IF EXISTS inventory_batch_inventory_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.i18ntext DROP CONSTRAINT IF EXISTS i18ntext_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.i18n_text DROP CONSTRAINT IF EXISTS i18n_text_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.guest_feedback DROP CONSTRAINT IF EXISTS guest_feedback_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.guest_feedback DROP CONSTRAINT IF EXISTS guest_feedback_reservation_id_fkey;
ALTER TABLE IF EXISTS ONLY public.floor DROP CONSTRAINT IF EXISTS floor_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.floor DROP CONSTRAINT IF EXISTS floor_default_waiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS fk_table_active_order;
ALTER TABLE IF EXISTS ONLY public.fiscal_invoice DROP CONSTRAINT IF EXISTS fiscal_invoice_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.fiscal_invoice DROP CONSTRAINT IF EXISTS fiscal_invoice_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.fiscal_invoice DROP CONSTRAINT IF EXISTS fiscal_invoice_cancels_fiscal_invoice_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_marketplace_integration DROP CONSTRAINT IF EXISTS delivery_marketplace_integration_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_integration_event_log DROP CONSTRAINT IF EXISTS delivery_integration_event_log_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_integration_event_log DROP CONSTRAINT IF EXISTS delivery_integration_event_log_integration_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_catalog_mapping DROP CONSTRAINT IF EXISTS delivery_catalog_mapping_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_catalog_mapping DROP CONSTRAINT IF EXISTS delivery_catalog_mapping_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_catalog_mapping DROP CONSTRAINT IF EXISTS delivery_catalog_mapping_integration_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_prepared_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_hub_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_branch_tenant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.billing_customer DROP CONSTRAINT IF EXISTS billing_customer_tenant_id_fkey;
DROP INDEX IF EXISTS public.uq_work_session_user_open;
DROP INDEX IF EXISTS public.uq_tse_transaction_tenant_order_sale;
DROP INDEX IF EXISTS public.uq_staff_contract_group_version;
DROP INDEX IF EXISTS public.uq_order_payment_item_active_line;
DROP INDEX IF EXISTS public.uq_order_delivery_external;
DROP INDEX IF EXISTS public.uq_loyalty_membership_referral_code;
DROP INDEX IF EXISTS public.uq_loyalty_membership_apple_pass_serial;
DROP INDEX IF EXISTS public.uq_loyalty_ledger_referral_reward_note;
DROP INDEX IF EXISTS public.uq_loyalty_ledger_earn_order;
DROP INDEX IF EXISTS public.uq_fiscal_invoice_tenant_order_alta;
DROP INDEX IF EXISTS public.uq_customer_email;
DROP INDEX IF EXISTS public.ix_work_session_user_id;
DROP INDEX IF EXISTS public.ix_work_session_break_work_session_id;
DROP INDEX IF EXISTS public.ix_work_session_adjustment_work_session_id;
DROP INDEX IF EXISTS public.ix_work_session_adjustment_actor_user_id;
DROP INDEX IF EXISTS public.ix_warehouse_tenant_id;
DROP INDEX IF EXISTS public.ix_warehouse_tenant_active;
DROP INDEX IF EXISTS public.ix_warehouse_stock_warehouse_id;
DROP INDEX IF EXISTS public.ix_warehouse_stock_warehouse;
DROP INDEX IF EXISTS public.ix_warehouse_stock_tenant_id;
DROP INDEX IF EXISTS public.ix_warehouse_stock_item;
DROP INDEX IF EXISTS public.ix_warehouse_stock_inventory_item_id;
DROP INDEX IF EXISTS public.ix_warehouse_name;
DROP INDEX IF EXISTS public.ix_warehouse_is_deleted;
DROP INDEX IF EXISTS public.ix_warehouse_is_default;
DROP INDEX IF EXISTS public.ix_warehouse_is_active;
DROP INDEX IF EXISTS public.ix_warehouse_code;
DROP INDEX IF EXISTS public.ix_waiting_list_entry_tenant_status_created;
DROP INDEX IF EXISTS public.ix_waiting_list_entry_status;
DROP INDEX IF EXISTS public.ix_user_provider_id;
DROP INDEX IF EXISTS public.ix_user_email;
DROP INDEX IF EXISTS public.ix_tse_transaction_tenant_time;
DROP INDEX IF EXISTS public.ix_tse_transaction_tenant_id;
DROP INDEX IF EXISTS public.ix_tse_transaction_order_id;
DROP INDEX IF EXISTS public.ix_tenantproduct_tenant_id;
DROP INDEX IF EXISTS public.ix_tenantproduct_tax_id;
DROP INDEX IF EXISTS public.ix_tenantproduct_provider_product_id;
DROP INDEX IF EXISTS public.ix_tenantproduct_product_id;
DROP INDEX IF EXISTS public.ix_tenantproduct_is_active;
DROP INDEX IF EXISTS public.ix_tenantproduct_catalog_id;
DROP INDEX IF EXISTS public.ix_tenant_name;
DROP INDEX IF EXISTS public.ix_tenant_default_tax_id;
DROP INDEX IF EXISTS public.ix_tenant_default_kitchen_station_id;
DROP INDEX IF EXISTS public.ix_tenant_default_bar_station_id;
DROP INDEX IF EXISTS public.ix_tax_tenant_id;
DROP INDEX IF EXISTS public.ix_table_token;
DROP INDEX IF EXISTS public.ix_table_table_group_id;
DROP INDEX IF EXISTS public.ix_table_is_active;
DROP INDEX IF EXISTS public.ix_supplier_name;
DROP INDEX IF EXISTS public.ix_supplier_is_deleted;
DROP INDEX IF EXISTS public.ix_supplier_is_active;
DROP INDEX IF EXISTS public.ix_supplier_code;
DROP INDEX IF EXISTS public.ix_staff_contract_tenant_id;
DROP INDEX IF EXISTS public.ix_staff_contract_tenant_group;
DROP INDEX IF EXISTS public.ix_staff_contract_template_tenant_id;
DROP INDEX IF EXISTS public.ix_staff_contract_template_preset_region;
DROP INDEX IF EXISTS public.ix_staff_contract_template_preset_locale;
DROP INDEX IF EXISTS public.ix_staff_contract_subject_user_id;
DROP INDEX IF EXISTS public.ix_staff_contract_contract_group_id;
DROP INDEX IF EXISTS public.ix_social_post_tenant_schedule;
DROP INDEX IF EXISTS public.ix_social_post_tenant_id;
DROP INDEX IF EXISTS public.ix_social_post_target_social_post_id;
DROP INDEX IF EXISTS public.ix_social_post_target_post;
DROP INDEX IF EXISTS public.ix_social_post_status_schedule;
DROP INDEX IF EXISTS public.ix_social_oauth_state_user_id;
DROP INDEX IF EXISTS public.ix_social_oauth_state_tenant_id;
DROP INDEX IF EXISTS public.ix_social_oauth_state_created;
DROP INDEX IF EXISTS public.ix_social_connection_tenant_id;
DROP INDEX IF EXISTS public.ix_social_connection_tenant;
DROP INDEX IF EXISTS public.ix_social_connection_provider_key;
DROP INDEX IF EXISTS public.ix_restaurant_group_member_tenant_id;
DROP INDEX IF EXISTS public.ix_restaurant_group_member_group_id;
DROP INDEX IF EXISTS public.ix_restaurant_group_join_code;
DROP INDEX IF EXISTS public.ix_restaurant_group_hub_tenant_id;
DROP INDEX IF EXISTS public.ix_reservation_token;
DROP INDEX IF EXISTS public.ix_reservation_status;
DROP INDEX IF EXISTS public.ix_reservation_preferred_floor_id;
DROP INDEX IF EXISTS public.ix_reservation_customer_email;
DROP INDEX IF EXISTS public.ix_purchase_order_supplier_id;
DROP INDEX IF EXISTS public.ix_purchase_order_status;
DROP INDEX IF EXISTS public.ix_purchase_order_order_number;
DROP INDEX IF EXISTS public.ix_purchase_order_item_purchase_order_id;
DROP INDEX IF EXISTS public.ix_purchase_order_item_inventory_item_id;
DROP INDEX IF EXISTS public.ix_providerproduct_provider_id;
DROP INDEX IF EXISTS public.ix_providerproduct_external_id;
DROP INDEX IF EXISTS public.ix_providerproduct_catalog_id;
DROP INDEX IF EXISTS public.ix_providerproduct_availability;
DROP INDEX IF EXISTS public.ix_provider_token;
DROP INDEX IF EXISTS public.ix_provider_tenant_id;
DROP INDEX IF EXISTS public.ix_provider_name;
DROP INDEX IF EXISTS public.ix_provider_is_active;
DROP INDEX IF EXISTS public.ix_productcatalog_subcategory;
DROP INDEX IF EXISTS public.ix_productcatalog_normalized_name;
DROP INDEX IF EXISTS public.ix_productcatalog_name;
DROP INDEX IF EXISTS public.ix_productcatalog_category;
DROP INDEX IF EXISTS public.ix_productcatalog_barcode;
DROP INDEX IF EXISTS public.ix_product_tax_id;
DROP INDEX IF EXISTS public.ix_product_subcategory;
DROP INDEX IF EXISTS public.ix_product_recipe_product_id;
DROP INDEX IF EXISTS public.ix_product_recipe_inventory_item_id;
DROP INDEX IF EXISTS public.ix_product_question_type;
DROP INDEX IF EXISTS public.ix_product_question_product_id;
DROP INDEX IF EXISTS public.ix_product_kitchen_station_id;
DROP INDEX IF EXISTS public.ix_product_category;
DROP INDEX IF EXISTS public.ix_print_job_tenant_status;
DROP INDEX IF EXISTS public.ix_print_job_tenant_created;
DROP INDEX IF EXISTS public.ix_print_job_pending;
DROP INDEX IF EXISTS public.ix_print_job_order_id;
DROP INDEX IF EXISTS public.ix_print_agent_token_hash;
DROP INDEX IF EXISTS public.ix_print_agent_tenant_last_seen;
DROP INDEX IF EXISTS public.ix_print_agent_tenant;
DROP INDEX IF EXISTS public.ix_price_promotion_tenant_enabled;
DROP INDEX IF EXISTS public.ix_price_promotion_tenant;
DROP INDEX IF EXISTS public.ix_password_reset_token_user_id;
DROP INDEX IF EXISTS public.ix_password_reset_token_token_hash;
DROP INDEX IF EXISTS public.ix_orderitem_tax_id;
DROP INDEX IF EXISTS public.ix_orderitem_status;
DROP INDEX IF EXISTS public.ix_orderitem_removed_by_customer;
DROP INDEX IF EXISTS public.ix_orderitem_promo_id;
DROP INDEX IF EXISTS public.ix_orderitem_promo;
DROP INDEX IF EXISTS public.ix_order_tip_attributed_user_id;
DROP INDEX IF EXISTS public.ix_order_staff_urgent;
DROP INDEX IF EXISTS public.ix_order_session_id;
DROP INDEX IF EXISTS public.ix_order_payment_tenant_paid;
DROP INDEX IF EXISTS public.ix_order_payment_order_id;
DROP INDEX IF EXISTS public.ix_order_payment_order_active;
DROP INDEX IF EXISTS public.ix_order_payment_order;
DROP INDEX IF EXISTS public.ix_order_payment_item_payment;
DROP INDEX IF EXISTS public.ix_order_payment_item_order_payment_id;
DROP INDEX IF EXISTS public.ix_order_payment_item_order_item_id;
DROP INDEX IF EXISTS public.ix_order_payment_item_order_item;
DROP INDEX IF EXISTS public.ix_order_order_channel;
DROP INDEX IF EXISTS public.ix_order_loyalty_membership_id;
DROP INDEX IF EXISTS public.ix_order_loyalty_membership;
DROP INDEX IF EXISTS public.ix_order_external_order_ref;
DROP INDEX IF EXISTS public.ix_order_delivery_integration_id;
DROP INDEX IF EXISTS public.ix_order_delivery_integration;
DROP INDEX IF EXISTS public.ix_order_deleted_at;
DROP INDEX IF EXISTS public.ix_order_customer_name;
DROP INDEX IF EXISTS public.ix_order_customer_id;
DROP INDEX IF EXISTS public.ix_order_courier_user_id;
DROP INDEX IF EXISTS public.ix_order_courier_user;
DROP INDEX IF EXISTS public.ix_order_channel;
DROP INDEX IF EXISTS public.ix_order_billing_customer_id;
DROP INDEX IF EXISTS public.ix_opening_hours_date_override_tenant_id;
DROP INDEX IF EXISTS public.ix_opening_hours_baseline_schedule_tenant_id;
DROP INDEX IF EXISTS public.ix_ohdo_tenant_range;
DROP INDEX IF EXISTS public.ix_ohbs_tenant_eff;
DROP INDEX IF EXISTS public.ix_offline_order_idempotency_tenant_id;
DROP INDEX IF EXISTS public.ix_offline_order_idempotency_order_id;
DROP INDEX IF EXISTS public.ix_offline_order_idempotency_idempotency_key;
DROP INDEX IF EXISTS public.ix_loyalty_program_tenant;
DROP INDEX IF EXISTS public.ix_loyalty_membership_tenant;
DROP INDEX IF EXISTS public.ix_loyalty_membership_referred_by_membership_id;
DROP INDEX IF EXISTS public.ix_loyalty_membership_referred_by;
DROP INDEX IF EXISTS public.ix_loyalty_membership_referral_code;
DROP INDEX IF EXISTS public.ix_loyalty_membership_program_id;
DROP INDEX IF EXISTS public.ix_loyalty_membership_program;
DROP INDEX IF EXISTS public.ix_loyalty_membership_phone;
DROP INDEX IF EXISTS public.ix_loyalty_membership_member_token;
DROP INDEX IF EXISTS public.ix_loyalty_membership_email;
DROP INDEX IF EXISTS public.ix_loyalty_membership_billing_customer_id;
DROP INDEX IF EXISTS public.ix_loyalty_membership_billing;
DROP INDEX IF EXISTS public.ix_loyalty_membership_apple_pass_serial;
DROP INDEX IF EXISTS public.ix_loyalty_ledger_tenant_created;
DROP INDEX IF EXISTS public.ix_loyalty_ledger_order;
DROP INDEX IF EXISTS public.ix_loyalty_ledger_membership_created;
DROP INDEX IF EXISTS public.ix_loyalty_ledger_entry_order_id;
DROP INDEX IF EXISTS public.ix_loyalty_ledger_entry_membership_id;
DROP INDEX IF EXISTS public.ix_loyalty_apple_device_membership_id;
DROP INDEX IF EXISTS public.ix_loyalty_apple_device_membership;
DROP INDEX IF EXISTS public.ix_loyalty_apple_device_library;
DROP INDEX IF EXISTS public.ix_loyalty_apple_device_device_library_identifier;
DROP INDEX IF EXISTS public.ix_login_event_user_id;
DROP INDEX IF EXISTS public.ix_login_event_tenant_id;
DROP INDEX IF EXISTS public.ix_kitchen_station_tenant_route;
DROP INDEX IF EXISTS public.ix_kitchen_station_tenant_id;
DROP INDEX IF EXISTS public.ix_inventory_transaction_warehouse_id;
DROP INDEX IF EXISTS public.ix_inventory_transaction_transaction_type;
DROP INDEX IF EXISTS public.ix_inventory_transaction_purchase_order_id;
DROP INDEX IF EXISTS public.ix_inventory_transaction_order_id;
DROP INDEX IF EXISTS public.ix_inventory_transaction_inventory_item_id;
DROP INDEX IF EXISTS public.ix_inventory_transaction_batch_id;
DROP INDEX IF EXISTS public.ix_inventory_item_sku;
DROP INDEX IF EXISTS public.ix_inventory_item_name;
DROP INDEX IF EXISTS public.ix_inventory_item_is_deleted;
DROP INDEX IF EXISTS public.ix_inventory_item_is_active;
DROP INDEX IF EXISTS public.ix_inventory_item_default_supplier_id;
DROP INDEX IF EXISTS public.ix_inventory_item_category;
DROP INDEX IF EXISTS public.ix_inventory_batch_warehouse_id;
DROP INDEX IF EXISTS public.ix_inventory_batch_purchase_order_id;
DROP INDEX IF EXISTS public.ix_inventory_batch_inventory_item_id;
DROP INDEX IF EXISTS public.ix_i18ntext_tenant_id;
DROP INDEX IF EXISTS public.ix_i18ntext_lang;
DROP INDEX IF EXISTS public.ix_i18ntext_field;
DROP INDEX IF EXISTS public.ix_i18ntext_entity_type;
DROP INDEX IF EXISTS public.ix_i18ntext_entity_id;
DROP INDEX IF EXISTS public.ix_guest_feedback_tenant_created;
DROP INDEX IF EXISTS public.ix_floor_is_active;
DROP INDEX IF EXISTS public.ix_fiscal_invoice_tenant_issued_at;
DROP INDEX IF EXISTS public.ix_fiscal_invoice_tenant_id;
DROP INDEX IF EXISTS public.ix_fiscal_invoice_order_id;
DROP INDEX IF EXISTS public.ix_delivery_marketplace_integration_webhook_ingest_token;
DROP INDEX IF EXISTS public.ix_delivery_marketplace_integration_tenant_id;
DROP INDEX IF EXISTS public.ix_delivery_marketplace_integration_provider_key;
DROP INDEX IF EXISTS public.ix_delivery_integration_tenant;
DROP INDEX IF EXISTS public.ix_delivery_integration_event_log_tenant_id;
DROP INDEX IF EXISTS public.ix_delivery_integration_event_log_integration_id;
DROP INDEX IF EXISTS public.ix_delivery_event_log_tenant_created;
DROP INDEX IF EXISTS public.ix_delivery_catalog_mapping_tenant_id;
DROP INDEX IF EXISTS public.ix_delivery_catalog_mapping_tenant;
DROP INDEX IF EXISTS public.ix_delivery_catalog_mapping_integration_id;
DROP INDEX IF EXISTS public.ix_customer_email_verification_token_hash;
DROP INDEX IF EXISTS public.ix_customer_email;
DROP INDEX IF EXISTS public.ix_branch_hub_fulfillment_status;
DROP INDEX IF EXISTS public.ix_branch_hub_fulfillment_order_id;
DROP INDEX IF EXISTS public.ix_branch_hub_fulfillment_hub_tenant_id;
DROP INDEX IF EXISTS public.ix_branch_hub_fulfillment_group_id;
DROP INDEX IF EXISTS public.ix_branch_hub_fulfillment_branch_tenant_id;
DROP INDEX IF EXISTS public.ix_billing_customer_tenant_id;
DROP INDEX IF EXISTS public.ix_billing_customer_tax_id;
DROP INDEX IF EXISTS public.ix_billing_customer_name;
DROP INDEX IF EXISTS public.ix_billing_customer_email;
DROP INDEX IF EXISTS public.ix_billing_customer_company_name;
DROP INDEX IF EXISTS public.idx_work_session_user_started;
DROP INDEX IF EXISTS public.idx_work_session_tenant_started;
DROP INDEX IF EXISTS public.idx_work_session_break_tenant;
DROP INDEX IF EXISTS public.idx_work_session_break_session;
DROP INDEX IF EXISTS public.idx_work_session_adj_tenant;
DROP INDEX IF EXISTS public.idx_user_tenant_role;
DROP INDEX IF EXISTS public.idx_user_role;
DROP INDEX IF EXISTS public.idx_user_provider_id;
DROP INDEX IF EXISTS public.idx_tenantproduct_tenant_id;
DROP INDEX IF EXISTS public.idx_tenantproduct_tenant_active;
DROP INDEX IF EXISTS public.idx_tenantproduct_tax_id;
DROP INDEX IF EXISTS public.idx_tenantproduct_provider_product_id;
DROP INDEX IF EXISTS public.idx_tenantproduct_product_id;
DROP INDEX IF EXISTS public.idx_tenantproduct_is_active;
DROP INDEX IF EXISTS public.idx_tenantproduct_catalog_id;
DROP INDEX IF EXISTS public.idx_tenant_saas_subscription_status;
DROP INDEX IF EXISTS public.idx_tenant_default_tax;
DROP INDEX IF EXISTS public.idx_tax_valid;
DROP INDEX IF EXISTS public.idx_tax_tenant_id;
DROP INDEX IF EXISTS public.idx_table_table_group;
DROP INDEX IF EXISTS public.idx_table_is_active;
DROP INDEX IF EXISTS public.idx_table_group_tenant;
DROP INDEX IF EXISTS public.idx_table_floor;
DROP INDEX IF EXISTS public.idx_table_assigned_waiter;
DROP INDEX IF EXISTS public.idx_shift_user_date;
DROP INDEX IF EXISTS public.idx_shift_tenant_date;
DROP INDEX IF EXISTS public.idx_restaurant_group_member_group;
DROP INDEX IF EXISTS public.idx_reservation_token;
DROP INDEX IF EXISTS public.idx_reservation_tenant_status;
DROP INDEX IF EXISTS public.idx_reservation_tenant_date;
DROP INDEX IF EXISTS public.idx_reservation_tenant;
DROP INDEX IF EXISTS public.idx_reservation_table;
DROP INDEX IF EXISTS public.idx_reservation_customer_email;
DROP INDEX IF EXISTS public.idx_providerproduct_winery;
DROP INDEX IF EXISTS public.idx_providerproduct_wine_category_id;
DROP INDEX IF EXISTS public.idx_providerproduct_vintage;
DROP INDEX IF EXISTS public.idx_providerproduct_provider_id;
DROP INDEX IF EXISTS public.idx_providerproduct_price;
DROP INDEX IF EXISTS public.idx_providerproduct_image_filename;
DROP INDEX IF EXISTS public.idx_providerproduct_external_id;
DROP INDEX IF EXISTS public.idx_providerproduct_catalog_provider;
DROP INDEX IF EXISTS public.idx_providerproduct_catalog_id;
DROP INDEX IF EXISTS public.idx_providerproduct_availability;
DROP INDEX IF EXISTS public.idx_provider_token;
DROP INDEX IF EXISTS public.idx_provider_tenant_name;
DROP INDEX IF EXISTS public.idx_provider_tenant_id;
DROP INDEX IF EXISTS public.idx_provider_name;
DROP INDEX IF EXISTS public.idx_provider_is_active;
DROP INDEX IF EXISTS public.idx_productcatalog_subcategory;
DROP INDEX IF EXISTS public.idx_productcatalog_normalized_name;
DROP INDEX IF EXISTS public.idx_productcatalog_name;
DROP INDEX IF EXISTS public.idx_productcatalog_category;
DROP INDEX IF EXISTS public.idx_productcatalog_barcode;
DROP INDEX IF EXISTS public.idx_product_tax_id;
DROP INDEX IF EXISTS public.idx_product_subcategory;
DROP INDEX IF EXISTS public.idx_product_question_tenant_product;
DROP INDEX IF EXISTS public.idx_product_category;
DROP INDEX IF EXISTS public.idx_orderitem_tax_id;
DROP INDEX IF EXISTS public.idx_orderitem_status;
DROP INDEX IF EXISTS public.idx_orderitem_removed;
DROP INDEX IF EXISTS public.idx_orderitem_modified;
DROP INDEX IF EXISTS public.idx_orderitem_active;
DROP INDEX IF EXISTS public.idx_order_tenant_staff_urgent;
DROP INDEX IF EXISTS public.idx_order_session;
DROP INDEX IF EXISTS public.idx_order_paid;
DROP INDEX IF EXISTS public.idx_order_customer_name;
DROP INDEX IF EXISTS public.idx_order_customer;
DROP INDEX IF EXISTS public.idx_order_billing_customer;
DROP INDEX IF EXISTS public.idx_login_event_tenant_id;
DROP INDEX IF EXISTS public.idx_login_event_logged_in_at;
DROP INDEX IF EXISTS public.idx_floor_tenant;
DROP INDEX IF EXISTS public.idx_floor_default_waiter;
DROP INDEX IF EXISTS public.idx_customer_email_verification_token_hash;
DROP INDEX IF EXISTS public.idx_branch_hub_fulfillment_hub;
DROP INDEX IF EXISTS public.idx_branch_hub_fulfillment_group;
DROP INDEX IF EXISTS public.idx_branch_hub_fulfillment_branch;
DROP INDEX IF EXISTS public.idx_billing_customer_tenant;
DROP INDEX IF EXISTS public.idx_billing_customer_tax_id;
DROP INDEX IF EXISTS public.idx_billing_customer_name;
DROP INDEX IF EXISTS public.idx_billing_customer_email;
DROP INDEX IF EXISTS public.idx_billing_customer_company_name;
DROP INDEX IF EXISTS public.i18n_text_unique_tenant;
DROP INDEX IF EXISTS public.i18n_text_unique_global;
DROP INDEX IF EXISTS public.i18n_text_lookup_tenant;
DROP INDEX IF EXISTS public.i18n_text_lookup_global;
ALTER TABLE IF EXISTS ONLY public.work_session DROP CONSTRAINT IF EXISTS work_session_pkey;
ALTER TABLE IF EXISTS ONLY public.work_session_break DROP CONSTRAINT IF EXISTS work_session_break_pkey;
ALTER TABLE IF EXISTS ONLY public.work_session_adjustment DROP CONSTRAINT IF EXISTS work_session_adjustment_pkey;
ALTER TABLE IF EXISTS ONLY public.warehouse_stock DROP CONSTRAINT IF EXISTS warehouse_stock_pkey;
ALTER TABLE IF EXISTS ONLY public.warehouse DROP CONSTRAINT IF EXISTS warehouse_pkey;
ALTER TABLE IF EXISTS ONLY public.waiting_list_entry DROP CONSTRAINT IF EXISTS waiting_list_entry_pkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract_template DROP CONSTRAINT IF EXISTS uq_staff_contract_template_tenant_key;
ALTER TABLE IF EXISTS ONLY public.staff_contract_template_preset DROP CONSTRAINT IF EXISTS uq_staff_contract_template_preset_region_locale_key;
ALTER TABLE IF EXISTS ONLY public.print_agent DROP CONSTRAINT IF EXISTS uq_print_agent_token_hash;
ALTER TABLE IF EXISTS ONLY public.print_agent DROP CONSTRAINT IF EXISTS uq_print_agent_tenant_device;
ALTER TABLE IF EXISTS ONLY public.offline_order_idempotency DROP CONSTRAINT IF EXISTS uq_offline_order_idempotency_tenant_key;
ALTER TABLE IF EXISTS ONLY public.loyalty_program DROP CONSTRAINT IF EXISTS uq_loyalty_program_tenant;
ALTER TABLE IF EXISTS ONLY public.loyalty_apple_device DROP CONSTRAINT IF EXISTS uq_loyalty_apple_device_membership_device;
ALTER TABLE IF EXISTS ONLY public.tse_transaction DROP CONSTRAINT IF EXISTS tse_transaction_pkey;
ALTER TABLE IF EXISTS ONLY public.tenantproduct DROP CONSTRAINT IF EXISTS tenantproduct_pkey;
ALTER TABLE IF EXISTS ONLY public.tenant DROP CONSTRAINT IF EXISTS tenant_pkey;
ALTER TABLE IF EXISTS ONLY public.tax DROP CONSTRAINT IF EXISTS tax_pkey;
ALTER TABLE IF EXISTS ONLY public."table" DROP CONSTRAINT IF EXISTS table_pkey;
ALTER TABLE IF EXISTS ONLY public.table_group DROP CONSTRAINT IF EXISTS table_group_pkey;
ALTER TABLE IF EXISTS ONLY public.supplier DROP CONSTRAINT IF EXISTS supplier_pkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract_template_preset DROP CONSTRAINT IF EXISTS staff_contract_template_preset_pkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract_template DROP CONSTRAINT IF EXISTS staff_contract_template_pkey;
ALTER TABLE IF EXISTS ONLY public.staff_contract DROP CONSTRAINT IF EXISTS staff_contract_pkey;
ALTER TABLE IF EXISTS ONLY public.social_post_target DROP CONSTRAINT IF EXISTS social_post_target_pkey;
ALTER TABLE IF EXISTS ONLY public.social_post DROP CONSTRAINT IF EXISTS social_post_pkey;
ALTER TABLE IF EXISTS ONLY public.social_oauth_state DROP CONSTRAINT IF EXISTS social_oauth_state_pkey;
ALTER TABLE IF EXISTS ONLY public.social_connection DROP CONSTRAINT IF EXISTS social_connection_pkey;
ALTER TABLE IF EXISTS ONLY public.shift DROP CONSTRAINT IF EXISTS shift_pkey;
ALTER TABLE IF EXISTS ONLY public.schema_version DROP CONSTRAINT IF EXISTS schema_version_pkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_group DROP CONSTRAINT IF EXISTS restaurant_group_pkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_group_member DROP CONSTRAINT IF EXISTS restaurant_group_member_pkey;
ALTER TABLE IF EXISTS ONLY public.reservation DROP CONSTRAINT IF EXISTS reservation_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order DROP CONSTRAINT IF EXISTS purchase_order_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order_item DROP CONSTRAINT IF EXISTS purchase_order_item_pkey;
ALTER TABLE IF EXISTS ONLY public.providerproduct DROP CONSTRAINT IF EXISTS providerproduct_pkey;
ALTER TABLE IF EXISTS ONLY public.provider DROP CONSTRAINT IF EXISTS provider_pkey;
ALTER TABLE IF EXISTS ONLY public.productcatalog DROP CONSTRAINT IF EXISTS productcatalog_pkey;
ALTER TABLE IF EXISTS ONLY public.product_recipe DROP CONSTRAINT IF EXISTS product_recipe_pkey;
ALTER TABLE IF EXISTS ONLY public.product_question DROP CONSTRAINT IF EXISTS product_question_pkey;
ALTER TABLE IF EXISTS ONLY public.product DROP CONSTRAINT IF EXISTS product_pkey;
ALTER TABLE IF EXISTS ONLY public.print_job DROP CONSTRAINT IF EXISTS print_job_pkey;
ALTER TABLE IF EXISTS ONLY public.print_agent DROP CONSTRAINT IF EXISTS print_agent_pkey;
ALTER TABLE IF EXISTS ONLY public.price_promotion DROP CONSTRAINT IF EXISTS price_promotion_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_token DROP CONSTRAINT IF EXISTS password_reset_token_pkey;
ALTER TABLE IF EXISTS ONLY public.orderitem DROP CONSTRAINT IF EXISTS orderitem_pkey;
ALTER TABLE IF EXISTS ONLY public."order" DROP CONSTRAINT IF EXISTS order_pkey;
ALTER TABLE IF EXISTS ONLY public.order_payment DROP CONSTRAINT IF EXISTS order_payment_pkey;
ALTER TABLE IF EXISTS ONLY public.order_payment_item DROP CONSTRAINT IF EXISTS order_payment_item_pkey;
ALTER TABLE IF EXISTS ONLY public.opening_hours_date_override DROP CONSTRAINT IF EXISTS opening_hours_date_override_pkey;
ALTER TABLE IF EXISTS ONLY public.opening_hours_baseline_schedule DROP CONSTRAINT IF EXISTS opening_hours_baseline_schedule_pkey;
ALTER TABLE IF EXISTS ONLY public.offline_order_idempotency DROP CONSTRAINT IF EXISTS offline_order_idempotency_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_program DROP CONSTRAINT IF EXISTS loyalty_program_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_membership DROP CONSTRAINT IF EXISTS loyalty_membership_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_ledger_entry DROP CONSTRAINT IF EXISTS loyalty_ledger_entry_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_apple_device DROP CONSTRAINT IF EXISTS loyalty_apple_device_pkey;
ALTER TABLE IF EXISTS ONLY public.login_event DROP CONSTRAINT IF EXISTS login_event_pkey;
ALTER TABLE IF EXISTS ONLY public.kitchen_station DROP CONSTRAINT IF EXISTS kitchen_station_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_transaction DROP CONSTRAINT IF EXISTS inventory_transaction_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_item DROP CONSTRAINT IF EXISTS inventory_item_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_batch DROP CONSTRAINT IF EXISTS inventory_batch_pkey;
ALTER TABLE IF EXISTS ONLY public.i18ntext DROP CONSTRAINT IF EXISTS i18ntext_pkey;
ALTER TABLE IF EXISTS ONLY public.i18n_text DROP CONSTRAINT IF EXISTS i18n_text_pkey;
ALTER TABLE IF EXISTS ONLY public.guest_feedback DROP CONSTRAINT IF EXISTS guest_feedback_pkey;
ALTER TABLE IF EXISTS ONLY public.floor DROP CONSTRAINT IF EXISTS floor_pkey;
ALTER TABLE IF EXISTS ONLY public.fiscal_invoice DROP CONSTRAINT IF EXISTS fiscal_invoice_pkey;
ALTER TABLE IF EXISTS ONLY public.delivery_marketplace_integration DROP CONSTRAINT IF EXISTS delivery_marketplace_integration_pkey;
ALTER TABLE IF EXISTS ONLY public.delivery_integration_event_log DROP CONSTRAINT IF EXISTS delivery_integration_event_log_pkey;
ALTER TABLE IF EXISTS ONLY public.delivery_catalog_mapping DROP CONSTRAINT IF EXISTS delivery_catalog_mapping_pkey;
ALTER TABLE IF EXISTS ONLY public.customer DROP CONSTRAINT IF EXISTS customer_pkey;
ALTER TABLE IF EXISTS ONLY public.branch_hub_fulfillment DROP CONSTRAINT IF EXISTS branch_hub_fulfillment_pkey;
ALTER TABLE IF EXISTS ONLY public.billing_customer DROP CONSTRAINT IF EXISTS billing_customer_pkey;
ALTER TABLE IF EXISTS public.work_session_break ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.work_session_adjustment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.work_session ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.warehouse_stock ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.warehouse ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.waiting_list_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."user" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tse_transaction ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tenantproduct ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tenant ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tax ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.table_group ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."table" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.supplier ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.staff_contract_template_preset ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.staff_contract_template ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.staff_contract ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.social_post_target ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.social_post ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.social_connection ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.shift ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.restaurant_group_member ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.restaurant_group ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reservation ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_order_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_order ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.providerproduct ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.provider ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.productcatalog ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product_recipe ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product_question ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.print_job ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.print_agent ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.price_promotion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.password_reset_token ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.orderitem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.order_payment_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.order_payment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."order" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.opening_hours_date_override ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.opening_hours_baseline_schedule ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.offline_order_idempotency ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.loyalty_program ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.loyalty_membership ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.loyalty_ledger_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.loyalty_apple_device ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.login_event ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.kitchen_station ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_transaction ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventory_batch ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.i18ntext ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.i18n_text ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.guest_feedback ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.floor ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.fiscal_invoice ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.delivery_marketplace_integration ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.delivery_integration_event_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.delivery_catalog_mapping ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.customer ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.branch_hub_fulfillment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.billing_customer ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.work_session_id_seq;
DROP SEQUENCE IF EXISTS public.work_session_break_id_seq;
DROP TABLE IF EXISTS public.work_session_break;
DROP SEQUENCE IF EXISTS public.work_session_adjustment_id_seq;
DROP TABLE IF EXISTS public.work_session_adjustment;
DROP TABLE IF EXISTS public.work_session;
DROP SEQUENCE IF EXISTS public.warehouse_stock_id_seq;
DROP TABLE IF EXISTS public.warehouse_stock;
DROP SEQUENCE IF EXISTS public.warehouse_id_seq;
DROP TABLE IF EXISTS public.warehouse;
DROP SEQUENCE IF EXISTS public.waiting_list_entry_id_seq;
DROP TABLE IF EXISTS public.waiting_list_entry;
DROP SEQUENCE IF EXISTS public.user_id_seq;
DROP TABLE IF EXISTS public."user";
DROP SEQUENCE IF EXISTS public.tse_transaction_id_seq;
DROP TABLE IF EXISTS public.tse_transaction;
DROP SEQUENCE IF EXISTS public.tenantproduct_id_seq;
DROP TABLE IF EXISTS public.tenantproduct;
DROP SEQUENCE IF EXISTS public.tenant_id_seq;
DROP TABLE IF EXISTS public.tenant;
DROP SEQUENCE IF EXISTS public.tax_id_seq;
DROP TABLE IF EXISTS public.tax;
DROP SEQUENCE IF EXISTS public.table_id_seq;
DROP SEQUENCE IF EXISTS public.table_group_id_seq;
DROP TABLE IF EXISTS public.table_group;
DROP TABLE IF EXISTS public."table";
DROP SEQUENCE IF EXISTS public.supplier_id_seq;
DROP TABLE IF EXISTS public.supplier;
DROP SEQUENCE IF EXISTS public.staff_contract_template_preset_id_seq;
DROP TABLE IF EXISTS public.staff_contract_template_preset;
DROP SEQUENCE IF EXISTS public.staff_contract_template_id_seq;
DROP TABLE IF EXISTS public.staff_contract_template;
DROP SEQUENCE IF EXISTS public.staff_contract_id_seq;
DROP TABLE IF EXISTS public.staff_contract;
DROP SEQUENCE IF EXISTS public.social_post_target_id_seq;
DROP TABLE IF EXISTS public.social_post_target;
DROP SEQUENCE IF EXISTS public.social_post_id_seq;
DROP TABLE IF EXISTS public.social_post;
DROP TABLE IF EXISTS public.social_oauth_state;
DROP SEQUENCE IF EXISTS public.social_connection_id_seq;
DROP TABLE IF EXISTS public.social_connection;
DROP SEQUENCE IF EXISTS public.shift_id_seq;
DROP TABLE IF EXISTS public.shift;
DROP TABLE IF EXISTS public.schema_version;
DROP SEQUENCE IF EXISTS public.restaurant_group_member_id_seq;
DROP TABLE IF EXISTS public.restaurant_group_member;
DROP SEQUENCE IF EXISTS public.restaurant_group_id_seq;
DROP TABLE IF EXISTS public.restaurant_group;
DROP SEQUENCE IF EXISTS public.reservation_id_seq;
DROP TABLE IF EXISTS public.reservation;
DROP SEQUENCE IF EXISTS public.purchase_order_item_id_seq;
DROP TABLE IF EXISTS public.purchase_order_item;
DROP SEQUENCE IF EXISTS public.purchase_order_id_seq;
DROP TABLE IF EXISTS public.purchase_order;
DROP SEQUENCE IF EXISTS public.providerproduct_id_seq;
DROP TABLE IF EXISTS public.providerproduct;
DROP SEQUENCE IF EXISTS public.provider_id_seq;
DROP TABLE IF EXISTS public.provider;
DROP SEQUENCE IF EXISTS public.productcatalog_id_seq;
DROP TABLE IF EXISTS public.productcatalog;
DROP SEQUENCE IF EXISTS public.product_recipe_id_seq;
DROP TABLE IF EXISTS public.product_recipe;
DROP SEQUENCE IF EXISTS public.product_question_id_seq;
DROP TABLE IF EXISTS public.product_question;
DROP SEQUENCE IF EXISTS public.product_id_seq;
DROP TABLE IF EXISTS public.product;
DROP SEQUENCE IF EXISTS public.print_job_id_seq;
DROP TABLE IF EXISTS public.print_job;
DROP SEQUENCE IF EXISTS public.print_agent_id_seq;
DROP TABLE IF EXISTS public.print_agent;
DROP SEQUENCE IF EXISTS public.price_promotion_id_seq;
DROP TABLE IF EXISTS public.price_promotion;
DROP SEQUENCE IF EXISTS public.password_reset_token_id_seq;
DROP TABLE IF EXISTS public.password_reset_token;
DROP SEQUENCE IF EXISTS public.orderitem_id_seq;
DROP TABLE IF EXISTS public.orderitem;
DROP SEQUENCE IF EXISTS public.order_payment_item_id_seq;
DROP TABLE IF EXISTS public.order_payment_item;
DROP SEQUENCE IF EXISTS public.order_payment_id_seq;
DROP TABLE IF EXISTS public.order_payment;
DROP SEQUENCE IF EXISTS public.order_id_seq;
DROP TABLE IF EXISTS public."order";
DROP SEQUENCE IF EXISTS public.opening_hours_date_override_id_seq;
DROP TABLE IF EXISTS public.opening_hours_date_override;
DROP SEQUENCE IF EXISTS public.opening_hours_baseline_schedule_id_seq;
DROP TABLE IF EXISTS public.opening_hours_baseline_schedule;
DROP SEQUENCE IF EXISTS public.offline_order_idempotency_id_seq;
DROP TABLE IF EXISTS public.offline_order_idempotency;
DROP SEQUENCE IF EXISTS public.loyalty_program_id_seq;
DROP TABLE IF EXISTS public.loyalty_program;
DROP SEQUENCE IF EXISTS public.loyalty_membership_id_seq;
DROP TABLE IF EXISTS public.loyalty_membership;
DROP SEQUENCE IF EXISTS public.loyalty_ledger_entry_id_seq;
DROP TABLE IF EXISTS public.loyalty_ledger_entry;
DROP SEQUENCE IF EXISTS public.loyalty_apple_device_id_seq;
DROP TABLE IF EXISTS public.loyalty_apple_device;
DROP SEQUENCE IF EXISTS public.login_event_id_seq;
DROP TABLE IF EXISTS public.login_event;
DROP SEQUENCE IF EXISTS public.kitchen_station_id_seq;
DROP TABLE IF EXISTS public.kitchen_station;
DROP SEQUENCE IF EXISTS public.inventory_transaction_id_seq;
DROP TABLE IF EXISTS public.inventory_transaction;
DROP SEQUENCE IF EXISTS public.inventory_item_id_seq;
DROP TABLE IF EXISTS public.inventory_item;
DROP SEQUENCE IF EXISTS public.inventory_batch_id_seq;
DROP TABLE IF EXISTS public.inventory_batch;
DROP SEQUENCE IF EXISTS public.i18ntext_id_seq;
DROP TABLE IF EXISTS public.i18ntext;
DROP SEQUENCE IF EXISTS public.i18n_text_id_seq;
DROP TABLE IF EXISTS public.i18n_text;
DROP SEQUENCE IF EXISTS public.guest_feedback_id_seq;
DROP TABLE IF EXISTS public.guest_feedback;
DROP SEQUENCE IF EXISTS public.floor_id_seq;
DROP TABLE IF EXISTS public.floor;
DROP SEQUENCE IF EXISTS public.fiscal_invoice_id_seq;
DROP TABLE IF EXISTS public.fiscal_invoice;
DROP SEQUENCE IF EXISTS public.delivery_marketplace_integration_id_seq;
DROP TABLE IF EXISTS public.delivery_marketplace_integration;
DROP SEQUENCE IF EXISTS public.delivery_integration_event_log_id_seq;
DROP TABLE IF EXISTS public.delivery_integration_event_log;
DROP SEQUENCE IF EXISTS public.delivery_catalog_mapping_id_seq;
DROP TABLE IF EXISTS public.delivery_catalog_mapping;
DROP SEQUENCE IF EXISTS public.customer_id_seq;
DROP TABLE IF EXISTS public.customer;
DROP SEQUENCE IF EXISTS public.branch_hub_fulfillment_id_seq;
DROP TABLE IF EXISTS public.branch_hub_fulfillment;
DROP SEQUENCE IF EXISTS public.billing_customer_id_seq;
DROP TABLE IF EXISTS public.billing_customer;
DROP TYPE IF EXISTS public.waitingliststatus;
DROP TYPE IF EXISTS public.user_role;
DROP TYPE IF EXISTS public.unitofmeasure;
DROP TYPE IF EXISTS public.transactiontype;
DROP TYPE IF EXISTS public.staff_contract_status;
DROP TYPE IF EXISTS public.staff_contract_payment_structure;
DROP TYPE IF EXISTS public.staff_contract_kind;
DROP TYPE IF EXISTS public.reservationstatus;
DROP TYPE IF EXISTS public.purchaseorderstatus;
DROP TYPE IF EXISTS public.productquestiontype;
DROP TYPE IF EXISTS public.orderstatus;
DROP TYPE IF EXISTS public.orderitemstatus;
DROP TYPE IF EXISTS public.orderchannel;
DROP TYPE IF EXISTS public.inventorycategory;
DROP TYPE IF EXISTS public.hubfulfillmentstatus;
DROP TYPE IF EXISTS public.businesstype;
--
-- Name: businesstype; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.businesstype AS ENUM (
    'restaurant',
    'bar',
    'cafe',
    'retail',
    'service',
    'other'
);


ALTER TYPE public.businesstype OWNER TO pos;

--
-- Name: hubfulfillmentstatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.hubfulfillmentstatus AS ENUM (
    'requested',
    'preparing',
    'prepared_at_hq',
    'cancelled'
);


ALTER TYPE public.hubfulfillmentstatus OWNER TO pos;

--
-- Name: inventorycategory; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.inventorycategory AS ENUM (
    'ingredients',
    'beverages',
    'packaging',
    'cleaning',
    'equipment',
    'other'
);


ALTER TYPE public.inventorycategory OWNER TO pos;

--
-- Name: orderchannel; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.orderchannel AS ENUM (
    'table',
    'satisfecho_delivery',
    'marketplace'
);


ALTER TYPE public.orderchannel OWNER TO pos;

--
-- Name: orderitemstatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.orderitemstatus AS ENUM (
    'pending',
    'preparing',
    'ready',
    'delivered',
    'cancelled'
);


ALTER TYPE public.orderitemstatus OWNER TO pos;

--
-- Name: orderstatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.orderstatus AS ENUM (
    'pending',
    'preparing',
    'ready',
    'out_for_delivery',
    'partially_delivered',
    'paid',
    'completed',
    'cancelled'
);


ALTER TYPE public.orderstatus OWNER TO pos;

--
-- Name: productquestiontype; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.productquestiontype AS ENUM (
    'choice',
    'scale',
    'text'
);


ALTER TYPE public.productquestiontype OWNER TO pos;

--
-- Name: purchaseorderstatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.purchaseorderstatus AS ENUM (
    'draft',
    'submitted',
    'approved',
    'partially_received',
    'received',
    'cancelled'
);


ALTER TYPE public.purchaseorderstatus OWNER TO pos;

--
-- Name: reservationstatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.reservationstatus AS ENUM (
    'booked',
    'seated',
    'finished',
    'cancelled',
    'no_show'
);


ALTER TYPE public.reservationstatus OWNER TO pos;

--
-- Name: staff_contract_kind; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.staff_contract_kind AS ENUM (
    'employee',
    'freelancer'
);


ALTER TYPE public.staff_contract_kind OWNER TO pos;

--
-- Name: staff_contract_payment_structure; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.staff_contract_payment_structure AS ENUM (
    'payroll',
    'invoice'
);


ALTER TYPE public.staff_contract_payment_structure OWNER TO pos;

--
-- Name: staff_contract_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.staff_contract_status AS ENUM (
    'draft',
    'pending_signature',
    'active',
    'expired',
    'superseded'
);


ALTER TYPE public.staff_contract_status OWNER TO pos;

--
-- Name: transactiontype; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.transactiontype AS ENUM (
    'purchase',
    'sale',
    'adjustment_add',
    'adjustment_subtract',
    'waste',
    'transfer_in',
    'transfer_out'
);


ALTER TYPE public.transactiontype OWNER TO pos;

--
-- Name: unitofmeasure; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.unitofmeasure AS ENUM (
    'piece',
    'gram',
    'kilogram',
    'ounce',
    'pound',
    'milliliter',
    'centiliter',
    'liter',
    'fluid_ounce',
    'cup',
    'gallon'
);


ALTER TYPE public.unitofmeasure OWNER TO pos;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.user_role AS ENUM (
    'owner',
    'admin',
    'kitchen',
    'bartender',
    'waiter',
    'receptionist',
    'courier',
    'provider',
    'platform_operator'
);


ALTER TYPE public.user_role OWNER TO pos;

--
-- Name: waitingliststatus; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.waitingliststatus AS ENUM (
    'waiting',
    'notified',
    'seated',
    'cancelled',
    'no_show'
);


ALTER TYPE public.waitingliststatus OWNER TO pos;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: billing_customer; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.billing_customer (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    name character varying NOT NULL,
    company_name character varying,
    tax_id character varying,
    address character varying,
    email character varying,
    phone character varying,
    birth_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.billing_customer OWNER TO pos;

--
-- Name: billing_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.billing_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.billing_customer_id_seq OWNER TO pos;

--
-- Name: billing_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.billing_customer_id_seq OWNED BY public.billing_customer.id;


--
-- Name: branch_hub_fulfillment; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.branch_hub_fulfillment (
    id integer NOT NULL,
    group_id integer NOT NULL,
    order_id integer NOT NULL,
    branch_tenant_id integer NOT NULL,
    hub_tenant_id integer NOT NULL,
    status public.hubfulfillmentstatus NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prepared_at timestamp without time zone,
    created_by_user_id integer,
    prepared_by_user_id integer
);


ALTER TABLE public.branch_hub_fulfillment OWNER TO pos;

--
-- Name: branch_hub_fulfillment_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.branch_hub_fulfillment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branch_hub_fulfillment_id_seq OWNER TO pos;

--
-- Name: branch_hub_fulfillment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.branch_hub_fulfillment_id_seq OWNED BY public.branch_hub_fulfillment.id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying NOT NULL,
    full_name character varying(255),
    phone character varying(64),
    business_name character varying(255),
    tax_id character varying(64),
    address text,
    email_verified boolean NOT NULL,
    email_verification_token_hash character varying(64),
    email_verification_sent_at timestamp with time zone,
    token_version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.customer OWNER TO pos;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_id_seq OWNER TO pos;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;


--
-- Name: delivery_catalog_mapping; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.delivery_catalog_mapping (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    integration_id integer NOT NULL,
    external_item_id character varying(256) NOT NULL,
    product_id integer,
    notes character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.delivery_catalog_mapping OWNER TO pos;

--
-- Name: delivery_catalog_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.delivery_catalog_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.delivery_catalog_mapping_id_seq OWNER TO pos;

--
-- Name: delivery_catalog_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.delivery_catalog_mapping_id_seq OWNED BY public.delivery_catalog_mapping.id;


--
-- Name: delivery_integration_event_log; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.delivery_integration_event_log (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    integration_id integer,
    provider_key character varying(64) NOT NULL,
    event_type character varying(64) NOT NULL,
    summary text,
    detail jsonb,
    success boolean NOT NULL,
    error_message text,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.delivery_integration_event_log OWNER TO pos;

--
-- Name: delivery_integration_event_log_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.delivery_integration_event_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.delivery_integration_event_log_id_seq OWNER TO pos;

--
-- Name: delivery_integration_event_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.delivery_integration_event_log_id_seq OWNED BY public.delivery_integration_event_log.id;


--
-- Name: delivery_marketplace_integration; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.delivery_marketplace_integration (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    provider_key character varying(64) NOT NULL,
    connection_status character varying(32) NOT NULL,
    credentials_encrypted text,
    external_store_id character varying(256),
    enabled boolean NOT NULL,
    webhook_ingest_token character varying(64) NOT NULL,
    last_test_at timestamp without time zone,
    last_test_ok boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.delivery_marketplace_integration OWNER TO pos;

--
-- Name: delivery_marketplace_integration_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.delivery_marketplace_integration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.delivery_marketplace_integration_id_seq OWNER TO pos;

--
-- Name: delivery_marketplace_integration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.delivery_marketplace_integration_id_seq OWNED BY public.delivery_marketplace_integration.id;


--
-- Name: fiscal_invoice; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.fiscal_invoice (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    order_id integer NOT NULL,
    series character varying(32) NOT NULL,
    doc_number integer NOT NULL,
    full_number character varying(64) NOT NULL,
    mode character varying(16) NOT NULL,
    status character varying(32) NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    request_payload jsonb,
    response_payload jsonb,
    verification_qr_content text NOT NULL,
    verification_text text NOT NULL,
    record_type character varying(16) NOT NULL,
    previous_hash character varying(64) NOT NULL,
    record_hash character varying(64) NOT NULL,
    cancels_fiscal_invoice_id integer,
    amount_cents integer NOT NULL,
    submission_status character varying(32) NOT NULL,
    sandbox_submitted_at timestamp without time zone,
    CONSTRAINT fiscal_invoice_record_type_check CHECK (((record_type)::text = ANY ((ARRAY['alta'::character varying, 'anulacion'::character varying])::text[])))
);


ALTER TABLE public.fiscal_invoice OWNER TO pos;

--
-- Name: fiscal_invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.fiscal_invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fiscal_invoice_id_seq OWNER TO pos;

--
-- Name: fiscal_invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.fiscal_invoice_id_seq OWNED BY public.fiscal_invoice.id;


--
-- Name: floor; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.floor (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying NOT NULL,
    sort_order integer NOT NULL,
    is_active boolean NOT NULL,
    seating_zone character varying(16) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    default_waiter_id integer
);


ALTER TABLE public.floor OWNER TO pos;

--
-- Name: COLUMN floor.is_active; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.floor.is_active IS 'When false, floor is hidden from public booking zone list (e.g. closed terrace).';


--
-- Name: COLUMN floor.seating_zone; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.floor.seating_zone IS 'Reservation zone type: indoor, outdoor, or any (matches both indoor and terrace preferences).';


--
-- Name: floor_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.floor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.floor_id_seq OWNER TO pos;

--
-- Name: floor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.floor_id_seq OWNED BY public.floor.id;


--
-- Name: guest_feedback; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.guest_feedback (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    rating integer NOT NULL,
    comment character varying,
    contact_name character varying(200),
    contact_email character varying(320),
    contact_phone character varying(40),
    reservation_id integer,
    client_ip character varying(45),
    client_user_agent character varying(512)
);


ALTER TABLE public.guest_feedback OWNER TO pos;

--
-- Name: guest_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.guest_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.guest_feedback_id_seq OWNER TO pos;

--
-- Name: guest_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.guest_feedback_id_seq OWNED BY public.guest_feedback.id;


--
-- Name: i18n_text; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.i18n_text (
    id bigint NOT NULL,
    tenant_id integer,
    entity_type text NOT NULL,
    entity_id bigint NOT NULL,
    field text NOT NULL,
    lang text NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.i18n_text OWNER TO pos;

--
-- Name: i18n_text_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.i18n_text_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.i18n_text_id_seq OWNER TO pos;

--
-- Name: i18n_text_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.i18n_text_id_seq OWNED BY public.i18n_text.id;


--
-- Name: i18ntext; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.i18ntext (
    id integer NOT NULL,
    tenant_id integer,
    entity_type character varying NOT NULL,
    entity_id integer NOT NULL,
    field character varying NOT NULL,
    lang character varying NOT NULL,
    text character varying NOT NULL
);


ALTER TABLE public.i18ntext OWNER TO pos;

--
-- Name: i18ntext_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.i18ntext_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.i18ntext_id_seq OWNER TO pos;

--
-- Name: i18ntext_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.i18ntext_id_seq OWNED BY public.i18ntext.id;


--
-- Name: inventory_batch; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.inventory_batch (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    purchase_order_id integer,
    warehouse_id integer,
    batch_number character varying,
    received_at timestamp without time zone NOT NULL,
    quantity_received numeric(12,4) NOT NULL,
    quantity_remaining numeric(12,4) NOT NULL,
    cost_per_unit_cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.inventory_batch OWNER TO pos;

--
-- Name: inventory_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.inventory_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_batch_id_seq OWNER TO pos;

--
-- Name: inventory_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.inventory_batch_id_seq OWNED BY public.inventory_batch.id;


--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.inventory_item (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    sku character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    unit public.unitofmeasure NOT NULL,
    reorder_level numeric(12,4) NOT NULL,
    reorder_quantity numeric(12,4) NOT NULL,
    current_quantity numeric(12,4) NOT NULL,
    average_cost_cents integer NOT NULL,
    category public.inventorycategory NOT NULL,
    default_supplier_id integer,
    is_active boolean NOT NULL,
    is_deleted boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.inventory_item OWNER TO pos;

--
-- Name: inventory_item_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.inventory_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_item_id_seq OWNER TO pos;

--
-- Name: inventory_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.inventory_item_id_seq OWNED BY public.inventory_item.id;


--
-- Name: inventory_transaction; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.inventory_transaction (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    batch_id integer,
    transaction_type public.transactiontype NOT NULL,
    quantity numeric(12,4) NOT NULL,
    unit public.unitofmeasure NOT NULL,
    unit_cost_cents integer,
    total_cost_cents integer,
    balance_after numeric(12,4) NOT NULL,
    order_id integer,
    purchase_order_id integer,
    warehouse_id integer,
    notes character varying,
    created_by_id integer,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.inventory_transaction OWNER TO pos;

--
-- Name: inventory_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.inventory_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_transaction_id_seq OWNER TO pos;

--
-- Name: inventory_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.inventory_transaction_id_seq OWNED BY public.inventory_transaction.id;


--
-- Name: kitchen_station; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.kitchen_station (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    name character varying(128) NOT NULL,
    sort_order integer NOT NULL,
    display_route character varying(16) NOT NULL
);


ALTER TABLE public.kitchen_station OWNER TO pos;

--
-- Name: TABLE kitchen_station; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.kitchen_station IS 'Prep station for KDS filtering and product routing (kitchen vs bar display)';


--
-- Name: COLUMN kitchen_station.display_route; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.kitchen_station.display_route IS 'kitchen = /kitchen KDS, bar = /bar KDS';


--
-- Name: kitchen_station_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.kitchen_station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kitchen_station_id_seq OWNER TO pos;

--
-- Name: kitchen_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.kitchen_station_id_seq OWNED BY public.kitchen_station.id;


--
-- Name: login_event; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.login_event (
    id integer NOT NULL,
    user_id integer,
    role public.user_role,
    tenant_id integer,
    provider_id integer,
    login_scope character varying(32),
    logged_in_at timestamp with time zone NOT NULL
);


ALTER TABLE public.login_event OWNER TO pos;

--
-- Name: login_event_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.login_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_event_id_seq OWNER TO pos;

--
-- Name: login_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.login_event_id_seq OWNED BY public.login_event.id;


--
-- Name: loyalty_apple_device; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.loyalty_apple_device (
    id integer NOT NULL,
    membership_id integer NOT NULL,
    device_library_identifier character varying(128) NOT NULL,
    push_token character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.loyalty_apple_device OWNER TO pos;

--
-- Name: loyalty_apple_device_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.loyalty_apple_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyalty_apple_device_id_seq OWNER TO pos;

--
-- Name: loyalty_apple_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.loyalty_apple_device_id_seq OWNED BY public.loyalty_apple_device.id;


--
-- Name: loyalty_ledger_entry; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.loyalty_ledger_entry (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    membership_id integer NOT NULL,
    entry_type character varying(16) NOT NULL,
    units integer NOT NULL,
    balance_after integer NOT NULL,
    order_id integer,
    note character varying(500),
    created_by_user_id integer,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.loyalty_ledger_entry OWNER TO pos;

--
-- Name: loyalty_ledger_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.loyalty_ledger_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyalty_ledger_entry_id_seq OWNER TO pos;

--
-- Name: loyalty_ledger_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.loyalty_ledger_entry_id_seq OWNED BY public.loyalty_ledger_entry.id;


--
-- Name: loyalty_membership; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.loyalty_membership (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    program_id integer NOT NULL,
    billing_customer_id integer,
    display_name character varying(200) NOT NULL,
    email character varying(320),
    phone character varying(40),
    member_token character varying(64) NOT NULL,
    balance integer NOT NULL,
    lifetime_earn_units integer NOT NULL,
    referral_code character varying(32) NOT NULL,
    referred_by_membership_id integer,
    referral_reward_granted boolean NOT NULL,
    birthday_month integer,
    birthday_day integer,
    birthday_bonus_year integer,
    apple_pass_serial character varying(64),
    apple_auth_token character varying(64),
    apple_pass_updated_tag character varying(64),
    google_loyalty_object_id character varying(200),
    joined_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_loyalty_membership_birthday_day CHECK (((birthday_day IS NULL) OR ((birthday_day >= 1) AND (birthday_day <= 31)))),
    CONSTRAINT ck_loyalty_membership_birthday_month CHECK (((birthday_month IS NULL) OR ((birthday_month >= 1) AND (birthday_month <= 12)))),
    CONSTRAINT ck_loyalty_membership_lifetime_earn CHECK ((lifetime_earn_units >= 0))
);


ALTER TABLE public.loyalty_membership OWNER TO pos;

--
-- Name: loyalty_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.loyalty_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyalty_membership_id_seq OWNER TO pos;

--
-- Name: loyalty_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.loyalty_membership_id_seq OWNED BY public.loyalty_membership.id;


--
-- Name: loyalty_program; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.loyalty_program (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    enabled boolean NOT NULL,
    program_name character varying(120) NOT NULL,
    mode character varying(16) NOT NULL,
    earn_units_per_order integer NOT NULL,
    redemption_threshold integer NOT NULL,
    reward_discount_cents integer NOT NULL,
    birthday_bonus_units integer NOT NULL,
    vip_silver_min_lifetime_units integer NOT NULL,
    vip_gold_min_lifetime_units integer NOT NULL,
    referral_bonus_units integer NOT NULL,
    referral_invitee_bonus_units integer NOT NULL,
    wallet_passes_enabled boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_loyalty_program_birthday_bonus CHECK ((birthday_bonus_units >= 0)),
    CONSTRAINT ck_loyalty_program_referral_bonus CHECK ((referral_bonus_units >= 0)),
    CONSTRAINT ck_loyalty_program_referral_invitee CHECK ((referral_invitee_bonus_units >= 0)),
    CONSTRAINT ck_loyalty_program_vip_gold CHECK ((vip_gold_min_lifetime_units >= 0)),
    CONSTRAINT ck_loyalty_program_vip_silver CHECK ((vip_silver_min_lifetime_units >= 0))
);


ALTER TABLE public.loyalty_program OWNER TO pos;

--
-- Name: loyalty_program_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.loyalty_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyalty_program_id_seq OWNER TO pos;

--
-- Name: loyalty_program_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.loyalty_program_id_seq OWNED BY public.loyalty_program.id;


--
-- Name: offline_order_idempotency; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.offline_order_idempotency (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    idempotency_key character varying(64) NOT NULL,
    order_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.offline_order_idempotency OWNER TO pos;

--
-- Name: offline_order_idempotency_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.offline_order_idempotency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.offline_order_idempotency_id_seq OWNER TO pos;

--
-- Name: offline_order_idempotency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.offline_order_idempotency_id_seq OWNED BY public.offline_order_idempotency.id;


--
-- Name: opening_hours_baseline_schedule; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.opening_hours_baseline_schedule (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    effective_from date NOT NULL,
    opening_hours text NOT NULL,
    note character varying(512),
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.opening_hours_baseline_schedule OWNER TO pos;

--
-- Name: opening_hours_baseline_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.opening_hours_baseline_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.opening_hours_baseline_schedule_id_seq OWNER TO pos;

--
-- Name: opening_hours_baseline_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.opening_hours_baseline_schedule_id_seq OWNED BY public.opening_hours_baseline_schedule.id;


--
-- Name: opening_hours_date_override; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.opening_hours_date_override (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    closed boolean NOT NULL,
    opening_hours text,
    note character varying(512),
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.opening_hours_date_override OWNER TO pos;

--
-- Name: opening_hours_date_override_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.opening_hours_date_override_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.opening_hours_date_override_id_seq OWNER TO pos;

--
-- Name: opening_hours_date_override_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.opening_hours_date_override_id_seq OWNED BY public.opening_hours_date_override.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public."order" (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    table_id integer,
    status public.orderstatus NOT NULL,
    notes character varying,
    session_id character varying,
    customer_name character varying,
    billing_customer_id integer,
    customer_id integer,
    created_at timestamp without time zone NOT NULL,
    cancelled_at timestamp without time zone,
    cancelled_by character varying,
    bill_requested_at timestamp without time zone,
    paid_at timestamp without time zone,
    paid_by_user_id integer,
    payment_method character varying,
    revolut_order_id character varying,
    tip_percent_applied integer,
    tip_amount_cents integer,
    tip_attributed_user_id integer,
    location_verified boolean,
    flagged_for_review boolean NOT NULL,
    flag_reason character varying,
    deleted_at timestamp without time zone,
    deleted_by_user_id integer,
    staff_urgent boolean NOT NULL,
    delivery_integration_id integer,
    external_order_ref character varying(256),
    order_channel public.orderchannel NOT NULL,
    delivery_address text,
    customer_phone character varying(40),
    courier_user_id integer,
    delivery_fee_cents integer NOT NULL,
    loyalty_membership_id integer,
    loyalty_discount_cents integer NOT NULL,
    loyalty_units_redeemed integer NOT NULL
);


ALTER TABLE public."order" OWNER TO pos;

--
-- Name: COLUMN "order".delivery_fee_cents; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public."order".delivery_fee_cents IS 'Delivery fee snapshot at create time (Satisfecho Delivery)';


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_id_seq OWNER TO pos;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: order_payment; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_payment (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    order_id integer NOT NULL,
    amount_cents integer NOT NULL,
    payment_method character varying(32) NOT NULL,
    payer_label character varying(120),
    tip_amount_cents integer,
    stripe_payment_intent_id character varying(128),
    paid_by_user_id integer,
    paid_at timestamp without time zone NOT NULL,
    voided_at timestamp without time zone,
    note character varying(500)
);


ALTER TABLE public.order_payment OWNER TO pos;

--
-- Name: order_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.order_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_payment_id_seq OWNER TO pos;

--
-- Name: order_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.order_payment_id_seq OWNED BY public.order_payment.id;


--
-- Name: order_payment_item; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_payment_item (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    order_payment_id integer NOT NULL,
    order_item_id integer NOT NULL,
    amount_cents integer NOT NULL
);


ALTER TABLE public.order_payment_item OWNER TO pos;

--
-- Name: order_payment_item_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.order_payment_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_payment_item_id_seq OWNER TO pos;

--
-- Name: order_payment_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.order_payment_item_id_seq OWNED BY public.order_payment_item.id;


--
-- Name: orderitem; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.orderitem (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    product_name character varying NOT NULL,
    quantity integer NOT NULL,
    price_cents integer NOT NULL,
    cost_cents integer,
    notes character varying,
    customization_answers jsonb,
    customization_summary character varying(1024),
    line_modifiers jsonb,
    line_modifiers_summary character varying(1024),
    list_price_cents integer,
    discount_cents integer NOT NULL,
    promo_id integer,
    promo_snapshot jsonb,
    tax_id integer,
    tax_rate_percent integer,
    tax_amount_cents integer,
    status public.orderitemstatus NOT NULL,
    status_updated_at timestamp without time zone,
    prepared_by_user_id integer,
    delivered_by_user_id integer,
    removed_by_customer boolean NOT NULL,
    removed_at timestamp without time zone,
    removed_reason character varying,
    removed_by_user_id integer,
    modified_by_user_id integer,
    modified_at timestamp without time zone,
    cancelled_reason character varying,
    added_by_session character varying,
    location_flagged boolean NOT NULL
);


ALTER TABLE public.orderitem OWNER TO pos;

--
-- Name: COLUMN orderitem.line_modifiers; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.orderitem.line_modifiers IS 'Structured modifiers: remove[], add[], substitute[{from,to}]';


--
-- Name: COLUMN orderitem.line_modifiers_summary; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.orderitem.line_modifiers_summary IS 'Human-readable snapshot at order time';


--
-- Name: orderitem_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.orderitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderitem_id_seq OWNER TO pos;

--
-- Name: orderitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.orderitem_id_seq OWNED BY public.orderitem.id;


--
-- Name: password_reset_token; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.password_reset_token (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token_hash character varying(64) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.password_reset_token OWNER TO pos;

--
-- Name: password_reset_token_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.password_reset_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_reset_token_id_seq OWNER TO pos;

--
-- Name: password_reset_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.password_reset_token_id_seq OWNED BY public.password_reset_token.id;


--
-- Name: price_promotion; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.price_promotion (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    promo_type character varying(32) NOT NULL,
    percent_off integer NOT NULL,
    category character varying(120) NOT NULL,
    channels jsonb,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    days_of_week jsonb,
    start_time_local character varying(5),
    end_time_local character varying(5),
    stackable boolean NOT NULL,
    enabled boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.price_promotion OWNER TO pos;

--
-- Name: price_promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.price_promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_promotion_id_seq OWNER TO pos;

--
-- Name: price_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.price_promotion_id_seq OWNED BY public.price_promotion.id;


--
-- Name: print_agent; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.print_agent (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    device_id character varying(64) NOT NULL,
    display_name character varying(120) NOT NULL,
    token_hash character varying(64) NOT NULL,
    last_seen_at timestamp with time zone,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.print_agent OWNER TO pos;

--
-- Name: print_agent_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.print_agent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.print_agent_id_seq OWNER TO pos;

--
-- Name: print_agent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.print_agent_id_seq OWNED BY public.print_agent.id;


--
-- Name: print_job; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.print_job (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    job_type character varying(16) NOT NULL,
    printer_role character varying(32) NOT NULL,
    status character varying(16) NOT NULL,
    order_id integer,
    payload jsonb NOT NULL,
    created_by_user_id integer,
    claimed_by_agent_id integer,
    claimed_at timestamp with time zone,
    completed_at timestamp with time zone,
    error_message character varying(500),
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.print_job OWNER TO pos;

--
-- Name: print_job_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.print_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.print_job_id_seq OWNER TO pos;

--
-- Name: print_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.print_job_id_seq OWNED BY public.print_job.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.product (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying NOT NULL,
    price_cents integer NOT NULL,
    cost_cents integer,
    description character varying,
    image_filename character varying,
    ingredients character varying,
    category character varying,
    subcategory character varying,
    tax_id integer,
    available_from date,
    available_until date,
    kitchen_station_id integer
);


ALTER TABLE public.product OWNER TO pos;

--
-- Name: COLUMN product.kitchen_station_id; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.product.kitchen_station_id IS 'Explicit prep station; null uses tenant default by category/route';


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_id_seq OWNER TO pos;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: product_question; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.product_question (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    product_id integer NOT NULL,
    type public.productquestiontype NOT NULL,
    label character varying(256) NOT NULL,
    options jsonb,
    sort_order integer NOT NULL,
    required boolean NOT NULL
);


ALTER TABLE public.product_question OWNER TO pos;

--
-- Name: product_question_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.product_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_question_id_seq OWNER TO pos;

--
-- Name: product_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.product_question_id_seq OWNED BY public.product_question.id;


--
-- Name: product_recipe; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.product_recipe (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    product_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity_required numeric(12,4) NOT NULL,
    unit public.unitofmeasure NOT NULL,
    waste_percentage numeric(5,2) NOT NULL,
    notes character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.product_recipe OWNER TO pos;

--
-- Name: product_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.product_recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_recipe_id_seq OWNER TO pos;

--
-- Name: product_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.product_recipe_id_seq OWNED BY public.product_recipe.id;


--
-- Name: productcatalog; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.productcatalog (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    category character varying,
    subcategory character varying,
    barcode character varying,
    brand character varying,
    normalized_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.productcatalog OWNER TO pos;

--
-- Name: productcatalog_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.productcatalog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productcatalog_id_seq OWNER TO pos;

--
-- Name: productcatalog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.productcatalog_id_seq OWNED BY public.productcatalog.id;


--
-- Name: provider; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.provider (
    id integer NOT NULL,
    tenant_id integer,
    name character varying NOT NULL,
    token character varying NOT NULL,
    url character varying,
    api_endpoint character varying,
    is_active boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    full_company_name character varying,
    address character varying,
    tax_number character varying,
    phone character varying,
    email character varying,
    bank_iban character varying,
    bank_bic character varying,
    bank_name character varying,
    bank_account_holder character varying
);


ALTER TABLE public.provider OWNER TO pos;

--
-- Name: provider_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.provider_id_seq OWNER TO pos;

--
-- Name: provider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.provider_id_seq OWNED BY public.provider.id;


--
-- Name: providerproduct; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.providerproduct (
    id integer NOT NULL,
    catalog_id integer NOT NULL,
    provider_id integer NOT NULL,
    external_id character varying NOT NULL,
    name character varying NOT NULL,
    price_cents integer,
    image_url character varying,
    image_filename character varying,
    availability boolean NOT NULL,
    country character varying,
    region character varying,
    grape_variety character varying,
    volume_ml integer,
    unit character varying,
    wine_category_id character varying,
    detailed_description character varying,
    wine_style character varying,
    vintage integer,
    winery character varying,
    aromas character varying,
    elaboration character varying,
    last_synced_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.providerproduct OWNER TO pos;

--
-- Name: providerproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.providerproduct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.providerproduct_id_seq OWNER TO pos;

--
-- Name: providerproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.providerproduct_id_seq OWNED BY public.providerproduct.id;


--
-- Name: purchase_order; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.purchase_order (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    order_number character varying NOT NULL,
    supplier_id integer NOT NULL,
    status public.purchaseorderstatus NOT NULL,
    order_date timestamp without time zone NOT NULL,
    expected_date date,
    received_date timestamp without time zone,
    subtotal_cents integer NOT NULL,
    tax_cents integer NOT NULL,
    total_cents integer NOT NULL,
    notes character varying,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.purchase_order OWNER TO pos;

--
-- Name: purchase_order_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.purchase_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_order_id_seq OWNER TO pos;

--
-- Name: purchase_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.purchase_order_id_seq OWNED BY public.purchase_order.id;


--
-- Name: purchase_order_item; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.purchase_order_item (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity_ordered numeric(12,4) NOT NULL,
    quantity_received numeric(12,4) NOT NULL,
    unit public.unitofmeasure NOT NULL,
    unit_cost_cents integer NOT NULL,
    line_total_cents integer NOT NULL
);


ALTER TABLE public.purchase_order_item OWNER TO pos;

--
-- Name: purchase_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.purchase_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_order_item_id_seq OWNER TO pos;

--
-- Name: purchase_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.purchase_order_item_id_seq OWNED BY public.purchase_order_item.id;


--
-- Name: reservation; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.reservation (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    customer_name character varying NOT NULL,
    customer_phone character varying NOT NULL,
    customer_email character varying,
    reservation_date date NOT NULL,
    reservation_time time without time zone NOT NULL,
    party_size integer NOT NULL,
    status public.reservationstatus NOT NULL,
    table_id integer,
    seated_at timestamp without time zone,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    client_notes character varying,
    customer_notes character varying,
    owner_notes character varying,
    delay_notice character varying,
    client_ip character varying(45),
    client_user_agent character varying(512),
    client_fingerprint character varying(256),
    client_screen_width integer,
    client_screen_height integer,
    reminder_24h_sent_at timestamp without time zone,
    reminder_2h_sent_at timestamp without time zone,
    service_type character varying(16),
    seating_preference character varying(32),
    allergies_has boolean NOT NULL,
    allergies_detail character varying,
    preferred_floor_id integer,
    locale character varying(16),
    guest_birthday_month integer,
    guest_birthday_day integer,
    guest_birthday_marketing_consent boolean NOT NULL,
    CONSTRAINT ck_reservation_guest_birthday_day CHECK (((guest_birthday_day IS NULL) OR ((guest_birthday_day >= 1) AND (guest_birthday_day <= 31)))),
    CONSTRAINT ck_reservation_guest_birthday_month CHECK (((guest_birthday_month IS NULL) OR ((guest_birthday_month >= 1) AND (guest_birthday_month <= 12)))),
    CONSTRAINT ck_reservation_guest_birthday_pair CHECK ((((guest_birthday_month IS NULL) AND (guest_birthday_day IS NULL)) OR ((guest_birthday_month IS NOT NULL) AND (guest_birthday_day IS NOT NULL))))
);


ALTER TABLE public.reservation OWNER TO pos;

--
-- Name: COLUMN reservation.preferred_floor_id; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.reservation.preferred_floor_id IS 'Public/staff: seating zone for capacity and display; null = venue-wide / legacy.';


--
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservation_id_seq OWNER TO pos;

--
-- Name: reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.reservation_id_seq OWNED BY public.reservation.id;


--
-- Name: restaurant_group; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.restaurant_group (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    join_code character varying(32) NOT NULL,
    share_products boolean NOT NULL,
    share_customers boolean NOT NULL,
    hub_tenant_id integer,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.restaurant_group OWNER TO pos;

--
-- Name: restaurant_group_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.restaurant_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurant_group_id_seq OWNER TO pos;

--
-- Name: restaurant_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.restaurant_group_id_seq OWNED BY public.restaurant_group.id;


--
-- Name: restaurant_group_member; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.restaurant_group_member (
    id integer NOT NULL,
    group_id integer NOT NULL,
    tenant_id integer NOT NULL,
    joined_at timestamp without time zone NOT NULL
);


ALTER TABLE public.restaurant_group_member OWNER TO pos;

--
-- Name: restaurant_group_member_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.restaurant_group_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurant_group_member_id_seq OWNER TO pos;

--
-- Name: restaurant_group_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.restaurant_group_member_id_seq OWNED BY public.restaurant_group_member.id;


--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.schema_version (
    version bigint NOT NULL,
    description text,
    applied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.schema_version OWNER TO pos;

--
-- Name: shift; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.shift (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    user_id integer NOT NULL,
    shift_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    label character varying(64),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.shift OWNER TO pos;

--
-- Name: shift_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shift_id_seq OWNER TO pos;

--
-- Name: shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;


--
-- Name: social_connection; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.social_connection (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    provider_key character varying(32) NOT NULL,
    connection_status character varying(32) NOT NULL,
    oauth_payload_encrypted text,
    meta_page_id character varying(64),
    meta_page_name character varying(512),
    instagram_account_id character varying(64),
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.social_connection OWNER TO pos;

--
-- Name: social_connection_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.social_connection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.social_connection_id_seq OWNER TO pos;

--
-- Name: social_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.social_connection_id_seq OWNED BY public.social_connection.id;


--
-- Name: social_oauth_state; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.social_oauth_state (
    state character varying(64) NOT NULL,
    tenant_id integer NOT NULL,
    user_id integer NOT NULL,
    provider_key character varying(32) NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.social_oauth_state OWNER TO pos;

--
-- Name: social_post; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.social_post (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    caption text NOT NULL,
    image_filename character varying(256) NOT NULL,
    schedule_at timestamp with time zone NOT NULL,
    status character varying(32) NOT NULL,
    error_message text,
    created_by_user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.social_post OWNER TO pos;

--
-- Name: social_post_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.social_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.social_post_id_seq OWNER TO pos;

--
-- Name: social_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.social_post_id_seq OWNED BY public.social_post.id;


--
-- Name: social_post_target; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.social_post_target (
    id integer NOT NULL,
    social_post_id integer NOT NULL,
    channel_key character varying(64) NOT NULL,
    status character varying(32) NOT NULL,
    external_id character varying(256),
    error_message text
);


ALTER TABLE public.social_post_target OWNER TO pos;

--
-- Name: social_post_target_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.social_post_target_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.social_post_target_id_seq OWNER TO pos;

--
-- Name: social_post_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.social_post_target_id_seq OWNED BY public.social_post_target.id;


--
-- Name: staff_contract; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.staff_contract (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    contract_group_id uuid NOT NULL,
    version integer NOT NULL,
    subject_user_id integer NOT NULL,
    kind public.staff_contract_kind NOT NULL,
    status public.staff_contract_status NOT NULL,
    role_title character varying(256) NOT NULL,
    start_date date,
    end_date date,
    compensation_summary text,
    tax_identifier_subject character varying(128),
    payment_structure public.staff_contract_payment_structure NOT NULL,
    payment_terms text,
    jurisdiction_note text,
    template_key character varying(64),
    notes_internal text,
    document_filename character varying(512),
    document_uploaded_at timestamp with time zone,
    created_by_user_id integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.staff_contract OWNER TO pos;

--
-- Name: staff_contract_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.staff_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_contract_id_seq OWNER TO pos;

--
-- Name: staff_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.staff_contract_id_seq OWNED BY public.staff_contract.id;


--
-- Name: staff_contract_template; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.staff_contract_template (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    template_key character varying(64) NOT NULL,
    name character varying(256) NOT NULL,
    body text NOT NULL,
    locale character varying(16),
    kind public.staff_contract_kind,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.staff_contract_template OWNER TO pos;

--
-- Name: staff_contract_template_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.staff_contract_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_contract_template_id_seq OWNER TO pos;

--
-- Name: staff_contract_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.staff_contract_template_id_seq OWNED BY public.staff_contract_template.id;


--
-- Name: staff_contract_template_preset; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.staff_contract_template_preset (
    id integer NOT NULL,
    region_code character varying(8) NOT NULL,
    locale character varying(16) NOT NULL,
    template_key character varying(64) NOT NULL,
    name character varying(256) NOT NULL,
    body text NOT NULL,
    kind public.staff_contract_kind,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.staff_contract_template_preset OWNER TO pos;

--
-- Name: staff_contract_template_preset_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.staff_contract_template_preset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_contract_template_preset_id_seq OWNER TO pos;

--
-- Name: staff_contract_template_preset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.staff_contract_template_preset_id_seq OWNED BY public.staff_contract_template_preset.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.supplier (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    contact_name character varying,
    phone character varying,
    email character varying,
    address character varying,
    payment_terms character varying,
    lead_time_days integer,
    minimum_order_cents integer,
    notes character varying,
    is_active boolean NOT NULL,
    is_deleted boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.supplier OWNER TO pos;

--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_id_seq OWNER TO pos;

--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.supplier_id_seq OWNED BY public.supplier.id;


--
-- Name: table; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public."table" (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying NOT NULL,
    token character varying NOT NULL,
    floor_id integer,
    x_position double precision NOT NULL,
    y_position double precision NOT NULL,
    rotation double precision NOT NULL,
    shape character varying NOT NULL,
    width double precision NOT NULL,
    height double precision NOT NULL,
    seat_count integer NOT NULL,
    table_group_id integer,
    assigned_waiter_id integer,
    order_pin character varying,
    is_active boolean NOT NULL,
    active_order_id integer,
    activated_at timestamp without time zone
);


ALTER TABLE public."table" OWNER TO pos;

--
-- Name: table_group; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_group (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.table_group OWNER TO pos;

--
-- Name: table_group_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.table_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_group_id_seq OWNER TO pos;

--
-- Name: table_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.table_group_id_seq OWNED BY public.table_group.id;


--
-- Name: table_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_id_seq OWNER TO pos;

--
-- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;


--
-- Name: tax; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.tax (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    name character varying(128) NOT NULL,
    rate_percent integer NOT NULL,
    valid_from date NOT NULL,
    valid_to date,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.tax OWNER TO pos;

--
-- Name: tax_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.tax_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_id_seq OWNER TO pos;

--
-- Name: tax_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.tax_id_seq OWNED BY public.tax.id;


--
-- Name: tenant; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.tenant (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    business_type public.businesstype,
    description character varying,
    phone character varying,
    whatsapp character varying,
    email character varying,
    address character varying,
    website character varying,
    tax_id character varying,
    cif character varying,
    ccc character varying,
    logo_filename character varying,
    header_background_filename character varying,
    public_background_color character varying,
    opening_hours character varying,
    immediate_payment_required boolean NOT NULL,
    currency_code character varying,
    currency character varying,
    default_language character varying,
    timezone character varying,
    country_code character varying(2),
    stripe_secret_key character varying,
    stripe_publishable_key character varying,
    revolut_merchant_secret character varying,
    latitude double precision,
    longitude double precision,
    location_radius_meters integer NOT NULL,
    location_check_enabled boolean NOT NULL,
    smtp_host character varying,
    smtp_port integer,
    smtp_use_tls boolean,
    smtp_user character varying,
    smtp_password character varying,
    email_from character varying,
    email_from_name character varying,
    reservation_confirmation_email_subject character varying,
    reservation_confirmation_email_body character varying,
    working_plan_updated_at timestamp without time zone,
    working_plan_owner_seen_at timestamp without time zone,
    reservation_prepayment_cents integer,
    reservation_prepayment_text character varying,
    reservation_cancellation_policy character varying,
    reservation_arrival_tolerance_minutes integer,
    reservation_average_table_turn_minutes integer,
    reservation_slot_minutes integer,
    reservation_max_guests_per_slot integer,
    reservation_walk_in_tables_reserved integer NOT NULL,
    reservation_dress_code character varying,
    reservation_reminder_24h_enabled boolean NOT NULL,
    reservation_reminder_2h_enabled boolean NOT NULL,
    guest_birthday_capture_enabled boolean NOT NULL,
    guest_birthday_marketing_enabled boolean NOT NULL,
    guest_birthday_consent_text character varying,
    delivery_fee_cents integer NOT NULL,
    delivery_radius_meters integer,
    delivery_postal_codes character varying,
    public_google_review_url character varying(2048),
    public_google_maps_url character varying(2048),
    public_openstreetmap_url character varying(2048),
    public_terms_of_service_url character varying(2048),
    public_privacy_policy_url character varying(2048),
    kitchen_display_timer_yellow_minutes integer,
    kitchen_display_timer_orange_minutes integer,
    kitchen_display_timer_red_minutes integer,
    tip_preset_percents jsonb,
    tip_tax_rate_percent integer,
    tip_entry_mode character varying(32) NOT NULL,
    default_tax_id integer,
    default_kitchen_station_id integer,
    default_bar_station_id integer,
    ui_modules jsonb,
    custom_subcategories jsonb,
    clock_qr_token_hash character varying(128),
    clock_qr_token_encrypted text,
    clock_qr_location_verify boolean NOT NULL,
    fiscal_mode character varying(16) NOT NULL,
    fiscal_invoice_series character varying(32) NOT NULL,
    fiscal_invoice_next_number integer NOT NULL,
    fiscal_aeat_api_secret character varying(512),
    fiscal_country character varying(2),
    tse_mode character varying(16) NOT NULL,
    tse_client_id character varying(128),
    tse_api_secret character varying(512),
    tse_serial_number character varying(128),
    tse_signature_counter integer NOT NULL,
    saas_subscription_status character varying(32) NOT NULL,
    saas_trial_ends_at timestamp without time zone,
    saas_subscription_ends_at timestamp without time zone,
    saas_stripe_customer_id character varying(255),
    saas_stripe_subscription_id character varying(255),
    CONSTRAINT tenant_fiscal_mode_check CHECK (((fiscal_mode)::text = ANY ((ARRAY['off'::character varying, 'test'::character varying, 'live'::character varying])::text[]))),
    CONSTRAINT tenant_tse_mode_check CHECK (((tse_mode)::text = ANY ((ARRAY['off'::character varying, 'test'::character varying, 'live'::character varying])::text[])))
);


ALTER TABLE public.tenant OWNER TO pos;

--
-- Name: COLUMN tenant.reservation_max_guests_per_slot; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.reservation_max_guests_per_slot IS 'When set (>0), caps total guests per slot to min(physical pool, this value).';


--
-- Name: COLUMN tenant.delivery_fee_cents; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.delivery_fee_cents IS 'Flat Satisfecho Delivery fee in cents (0 = free)';


--
-- Name: COLUMN tenant.delivery_radius_meters; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.delivery_radius_meters IS 'Optional max delivery distance from tenant lat/lng; null = no radius check';


--
-- Name: COLUMN tenant.delivery_postal_codes; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.delivery_postal_codes IS 'Optional JSON array of allowed postal codes; null/empty = no postal check';


--
-- Name: COLUMN tenant.kitchen_display_timer_yellow_minutes; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.kitchen_display_timer_yellow_minutes IS 'Minutes since order: card turns yellow after this';


--
-- Name: COLUMN tenant.kitchen_display_timer_orange_minutes; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.kitchen_display_timer_orange_minutes IS 'Minutes since order: card turns orange after this';


--
-- Name: COLUMN tenant.kitchen_display_timer_red_minutes; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.kitchen_display_timer_red_minutes IS 'Minutes since order: card turns red after this';


--
-- Name: COLUMN tenant.custom_subcategories; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.tenant.custom_subcategories IS 'Tenant-scoped subcategory names by category, e.g. {"Starters":["House Special"]}';


--
-- Name: tenant_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.tenant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tenant_id_seq OWNER TO pos;

--
-- Name: tenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.tenant_id_seq OWNED BY public.tenant.id;


--
-- Name: tenantproduct; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.tenantproduct (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    catalog_id integer NOT NULL,
    provider_product_id integer,
    product_id integer,
    name character varying NOT NULL,
    price_cents integer NOT NULL,
    cost_cents integer,
    image_filename character varying,
    ingredients character varying,
    is_active boolean NOT NULL,
    tax_id integer,
    available_from date,
    available_until date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.tenantproduct OWNER TO pos;

--
-- Name: tenantproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.tenantproduct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tenantproduct_id_seq OWNER TO pos;

--
-- Name: tenantproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.tenantproduct_id_seq OWNED BY public.tenantproduct.id;


--
-- Name: tse_transaction; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.tse_transaction (
    id integer NOT NULL,
    tenant_id integer NOT NULL,
    order_id integer NOT NULL,
    process_type character varying(16) NOT NULL,
    mode character varying(16) NOT NULL,
    tse_serial character varying(128) NOT NULL,
    signature_counter integer NOT NULL,
    signature_value text NOT NULL,
    qr_content text NOT NULL,
    process_data text NOT NULL,
    transaction_number integer NOT NULL,
    certificate_serial character varying(128) NOT NULL,
    time_start timestamp without time zone NOT NULL,
    time_end timestamp without time zone NOT NULL,
    amount_cents integer NOT NULL,
    request_payload jsonb,
    response_payload jsonb,
    submission_status character varying(32) NOT NULL,
    storno_of_tse_transaction_id integer,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT tse_transaction_process_type_check CHECK (((process_type)::text = ANY ((ARRAY['sale'::character varying, 'storno'::character varying, 'refund'::character varying])::text[])))
);


ALTER TABLE public.tse_transaction OWNER TO pos;

--
-- Name: tse_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.tse_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tse_transaction_id_seq OWNER TO pos;

--
-- Name: tse_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.tse_transaction_id_seq OWNED BY public.tse_transaction.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    full_name character varying,
    token_version integer NOT NULL,
    role public.user_role NOT NULL,
    tenant_id integer,
    provider_id integer,
    otp_secret character varying,
    otp_enabled boolean NOT NULL,
    employee_number character varying(64)
);


ALTER TABLE public."user" OWNER TO pos;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO pos;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: waiting_list_entry; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.waiting_list_entry (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    customer_name character varying(200) NOT NULL,
    customer_phone character varying(40) NOT NULL,
    party_size integer NOT NULL,
    status public.waitingliststatus NOT NULL,
    notified_at timestamp without time zone,
    client_ip character varying(45),
    client_user_agent character varying(512),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.waiting_list_entry OWNER TO pos;

--
-- Name: waiting_list_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.waiting_list_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.waiting_list_entry_id_seq OWNER TO pos;

--
-- Name: waiting_list_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.waiting_list_entry_id_seq OWNED BY public.waiting_list_entry.id;


--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.warehouse (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    is_default boolean NOT NULL,
    is_active boolean NOT NULL,
    is_deleted boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.warehouse OWNER TO pos;

--
-- Name: warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.warehouse_id_seq OWNER TO pos;

--
-- Name: warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.warehouse_id_seq OWNED BY public.warehouse.id;


--
-- Name: warehouse_stock; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.warehouse_stock (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity numeric(12,4) NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.warehouse_stock OWNER TO pos;

--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.warehouse_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.warehouse_stock_id_seq OWNER TO pos;

--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.warehouse_stock_id_seq OWNED BY public.warehouse_stock.id;


--
-- Name: work_session; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.work_session (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    user_id integer NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone,
    start_ip character varying(45),
    end_ip character varying(45),
    break_started_at timestamp with time zone
);


ALTER TABLE public.work_session OWNER TO pos;

--
-- Name: work_session_adjustment; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.work_session_adjustment (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    work_session_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    actor_user_id integer,
    note character varying NOT NULL,
    previous_started_at timestamp with time zone,
    previous_ended_at timestamp with time zone,
    new_started_at timestamp with time zone,
    new_ended_at timestamp with time zone
);


ALTER TABLE public.work_session_adjustment OWNER TO pos;

--
-- Name: work_session_adjustment_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.work_session_adjustment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_session_adjustment_id_seq OWNER TO pos;

--
-- Name: work_session_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.work_session_adjustment_id_seq OWNED BY public.work_session_adjustment.id;


--
-- Name: work_session_break; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.work_session_break (
    tenant_id integer NOT NULL,
    id integer NOT NULL,
    work_session_id integer NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone
);


ALTER TABLE public.work_session_break OWNER TO pos;

--
-- Name: work_session_break_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.work_session_break_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_session_break_id_seq OWNER TO pos;

--
-- Name: work_session_break_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.work_session_break_id_seq OWNED BY public.work_session_break.id;


--
-- Name: work_session_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.work_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_session_id_seq OWNER TO pos;

--
-- Name: work_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.work_session_id_seq OWNED BY public.work_session.id;


--
-- Name: billing_customer id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.billing_customer ALTER COLUMN id SET DEFAULT nextval('public.billing_customer_id_seq'::regclass);


--
-- Name: branch_hub_fulfillment id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment ALTER COLUMN id SET DEFAULT nextval('public.branch_hub_fulfillment_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: delivery_catalog_mapping id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_catalog_mapping ALTER COLUMN id SET DEFAULT nextval('public.delivery_catalog_mapping_id_seq'::regclass);


--
-- Name: delivery_integration_event_log id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_integration_event_log ALTER COLUMN id SET DEFAULT nextval('public.delivery_integration_event_log_id_seq'::regclass);


--
-- Name: delivery_marketplace_integration id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_marketplace_integration ALTER COLUMN id SET DEFAULT nextval('public.delivery_marketplace_integration_id_seq'::regclass);


--
-- Name: fiscal_invoice id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.fiscal_invoice ALTER COLUMN id SET DEFAULT nextval('public.fiscal_invoice_id_seq'::regclass);


--
-- Name: floor id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.floor ALTER COLUMN id SET DEFAULT nextval('public.floor_id_seq'::regclass);


--
-- Name: guest_feedback id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.guest_feedback ALTER COLUMN id SET DEFAULT nextval('public.guest_feedback_id_seq'::regclass);


--
-- Name: i18n_text id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18n_text ALTER COLUMN id SET DEFAULT nextval('public.i18n_text_id_seq'::regclass);


--
-- Name: i18ntext id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18ntext ALTER COLUMN id SET DEFAULT nextval('public.i18ntext_id_seq'::regclass);


--
-- Name: inventory_batch id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch ALTER COLUMN id SET DEFAULT nextval('public.inventory_batch_id_seq'::regclass);


--
-- Name: inventory_item id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_id_seq'::regclass);


--
-- Name: inventory_transaction id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction ALTER COLUMN id SET DEFAULT nextval('public.inventory_transaction_id_seq'::regclass);


--
-- Name: kitchen_station id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kitchen_station ALTER COLUMN id SET DEFAULT nextval('public.kitchen_station_id_seq'::regclass);


--
-- Name: login_event id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.login_event ALTER COLUMN id SET DEFAULT nextval('public.login_event_id_seq'::regclass);


--
-- Name: loyalty_apple_device id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_apple_device ALTER COLUMN id SET DEFAULT nextval('public.loyalty_apple_device_id_seq'::regclass);


--
-- Name: loyalty_ledger_entry id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry ALTER COLUMN id SET DEFAULT nextval('public.loyalty_ledger_entry_id_seq'::regclass);


--
-- Name: loyalty_membership id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership ALTER COLUMN id SET DEFAULT nextval('public.loyalty_membership_id_seq'::regclass);


--
-- Name: loyalty_program id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_program ALTER COLUMN id SET DEFAULT nextval('public.loyalty_program_id_seq'::regclass);


--
-- Name: offline_order_idempotency id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.offline_order_idempotency ALTER COLUMN id SET DEFAULT nextval('public.offline_order_idempotency_id_seq'::regclass);


--
-- Name: opening_hours_baseline_schedule id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_baseline_schedule ALTER COLUMN id SET DEFAULT nextval('public.opening_hours_baseline_schedule_id_seq'::regclass);


--
-- Name: opening_hours_date_override id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_date_override ALTER COLUMN id SET DEFAULT nextval('public.opening_hours_date_override_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Name: order_payment id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment ALTER COLUMN id SET DEFAULT nextval('public.order_payment_id_seq'::regclass);


--
-- Name: order_payment_item id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment_item ALTER COLUMN id SET DEFAULT nextval('public.order_payment_item_id_seq'::regclass);


--
-- Name: orderitem id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orderitem ALTER COLUMN id SET DEFAULT nextval('public.orderitem_id_seq'::regclass);


--
-- Name: password_reset_token id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.password_reset_token ALTER COLUMN id SET DEFAULT nextval('public.password_reset_token_id_seq'::regclass);


--
-- Name: price_promotion id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.price_promotion ALTER COLUMN id SET DEFAULT nextval('public.price_promotion_id_seq'::regclass);


--
-- Name: print_agent id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_agent ALTER COLUMN id SET DEFAULT nextval('public.print_agent_id_seq'::regclass);


--
-- Name: print_job id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job ALTER COLUMN id SET DEFAULT nextval('public.print_job_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: product_question id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_question ALTER COLUMN id SET DEFAULT nextval('public.product_question_id_seq'::regclass);


--
-- Name: product_recipe id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_recipe ALTER COLUMN id SET DEFAULT nextval('public.product_recipe_id_seq'::regclass);


--
-- Name: productcatalog id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.productcatalog ALTER COLUMN id SET DEFAULT nextval('public.productcatalog_id_seq'::regclass);


--
-- Name: provider id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.provider ALTER COLUMN id SET DEFAULT nextval('public.provider_id_seq'::regclass);


--
-- Name: providerproduct id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.providerproduct ALTER COLUMN id SET DEFAULT nextval('public.providerproduct_id_seq'::regclass);


--
-- Name: purchase_order id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_id_seq'::regclass);


--
-- Name: purchase_order_item id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_item ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_item_id_seq'::regclass);


--
-- Name: reservation id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id SET DEFAULT nextval('public.reservation_id_seq'::regclass);


--
-- Name: restaurant_group id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group ALTER COLUMN id SET DEFAULT nextval('public.restaurant_group_id_seq'::regclass);


--
-- Name: restaurant_group_member id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group_member ALTER COLUMN id SET DEFAULT nextval('public.restaurant_group_member_id_seq'::regclass);


--
-- Name: shift id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);


--
-- Name: social_connection id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_connection ALTER COLUMN id SET DEFAULT nextval('public.social_connection_id_seq'::regclass);


--
-- Name: social_post id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post ALTER COLUMN id SET DEFAULT nextval('public.social_post_id_seq'::regclass);


--
-- Name: social_post_target id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post_target ALTER COLUMN id SET DEFAULT nextval('public.social_post_target_id_seq'::regclass);


--
-- Name: staff_contract id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract ALTER COLUMN id SET DEFAULT nextval('public.staff_contract_id_seq'::regclass);


--
-- Name: staff_contract_template id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template ALTER COLUMN id SET DEFAULT nextval('public.staff_contract_template_id_seq'::regclass);


--
-- Name: staff_contract_template_preset id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template_preset ALTER COLUMN id SET DEFAULT nextval('public.staff_contract_template_preset_id_seq'::regclass);


--
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.supplier_id_seq'::regclass);


--
-- Name: table id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- Name: table_group id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_group ALTER COLUMN id SET DEFAULT nextval('public.table_group_id_seq'::regclass);


--
-- Name: tax id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax ALTER COLUMN id SET DEFAULT nextval('public.tax_id_seq'::regclass);


--
-- Name: tenant id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenant ALTER COLUMN id SET DEFAULT nextval('public.tenant_id_seq'::regclass);


--
-- Name: tenantproduct id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct ALTER COLUMN id SET DEFAULT nextval('public.tenantproduct_id_seq'::regclass);


--
-- Name: tse_transaction id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tse_transaction ALTER COLUMN id SET DEFAULT nextval('public.tse_transaction_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: waiting_list_entry id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.waiting_list_entry ALTER COLUMN id SET DEFAULT nextval('public.waiting_list_entry_id_seq'::regclass);


--
-- Name: warehouse id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse ALTER COLUMN id SET DEFAULT nextval('public.warehouse_id_seq'::regclass);


--
-- Name: warehouse_stock id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse_stock ALTER COLUMN id SET DEFAULT nextval('public.warehouse_stock_id_seq'::regclass);


--
-- Name: work_session id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session ALTER COLUMN id SET DEFAULT nextval('public.work_session_id_seq'::regclass);


--
-- Name: work_session_adjustment id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_adjustment ALTER COLUMN id SET DEFAULT nextval('public.work_session_adjustment_id_seq'::regclass);


--
-- Name: work_session_break id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_break ALTER COLUMN id SET DEFAULT nextval('public.work_session_break_id_seq'::regclass);


--
-- Data for Name: billing_customer; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.billing_customer (id, tenant_id, name, company_name, tax_id, address, email, phone, birth_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: branch_hub_fulfillment; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.branch_hub_fulfillment (id, group_id, order_id, branch_tenant_id, hub_tenant_id, status, notes, created_at, updated_at, prepared_at, created_by_user_id, prepared_by_user_id) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.customer (id, email, hashed_password, full_name, phone, business_name, tax_id, address, email_verified, email_verification_token_hash, email_verification_sent_at, token_version, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: delivery_catalog_mapping; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.delivery_catalog_mapping (id, tenant_id, integration_id, external_item_id, product_id, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: delivery_integration_event_log; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.delivery_integration_event_log (id, tenant_id, integration_id, provider_key, event_type, summary, detail, success, error_message, created_at) FROM stdin;
\.


--
-- Data for Name: delivery_marketplace_integration; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.delivery_marketplace_integration (id, tenant_id, provider_key, connection_status, credentials_encrypted, external_store_id, enabled, webhook_ingest_token, last_test_at, last_test_ok, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: fiscal_invoice; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.fiscal_invoice (id, tenant_id, order_id, series, doc_number, full_number, mode, status, issued_at, request_payload, response_payload, verification_qr_content, verification_text, record_type, previous_hash, record_hash, cancels_fiscal_invoice_id, amount_cents, submission_status, sandbox_submitted_at) FROM stdin;
\.


--
-- Data for Name: floor; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.floor (tenant_id, id, name, sort_order, is_active, seating_zone, created_at, default_waiter_id) FROM stdin;
1	1	Planta 1	1	t	any	2026-08-01 20:28:47.558448	\N
\.


--
-- Data for Name: guest_feedback; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.guest_feedback (tenant_id, id, created_at, rating, comment, contact_name, contact_email, contact_phone, reservation_id, client_ip, client_user_agent) FROM stdin;
\.


--
-- Data for Name: i18n_text; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.i18n_text (id, tenant_id, entity_type, entity_id, field, lang, text) FROM stdin;
\.


--
-- Data for Name: i18ntext; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.i18ntext (id, tenant_id, entity_type, entity_id, field, lang, text) FROM stdin;
\.


--
-- Data for Name: inventory_batch; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.inventory_batch (tenant_id, id, inventory_item_id, purchase_order_id, warehouse_id, batch_number, received_at, quantity_received, quantity_remaining, cost_per_unit_cents, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.inventory_item (tenant_id, id, sku, name, description, unit, reorder_level, reorder_quantity, current_quantity, average_cost_cents, category, default_supplier_id, is_active, is_deleted, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_transaction; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.inventory_transaction (tenant_id, id, inventory_item_id, batch_id, transaction_type, quantity, unit, unit_cost_cents, total_cost_cents, balance_after, order_id, purchase_order_id, warehouse_id, notes, created_by_id, created_at) FROM stdin;
\.


--
-- Data for Name: kitchen_station; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.kitchen_station (id, tenant_id, name, sort_order, display_route) FROM stdin;
1	1	Cocina	0	kitchen
\.


--
-- Data for Name: login_event; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.login_event (id, user_id, role, tenant_id, provider_id, login_scope, logged_in_at) FROM stdin;
1	1	owner	1	\N	tenant	2026-08-01 19:47:31.155184+00
2	1	owner	1	\N	tenant	2026-08-01 19:49:01.528653+00
3	1	owner	1	\N	tenant	2026-08-01 20:27:06.950359+00
4	1	owner	1	\N	tenant	2026-08-01 20:27:37.91949+00
\.


--
-- Data for Name: loyalty_apple_device; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.loyalty_apple_device (id, membership_id, device_library_identifier, push_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: loyalty_ledger_entry; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.loyalty_ledger_entry (tenant_id, id, membership_id, entry_type, units, balance_after, order_id, note, created_by_user_id, created_at) FROM stdin;
\.


--
-- Data for Name: loyalty_membership; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.loyalty_membership (tenant_id, id, program_id, billing_customer_id, display_name, email, phone, member_token, balance, lifetime_earn_units, referral_code, referred_by_membership_id, referral_reward_granted, birthday_month, birthday_day, birthday_bonus_year, apple_pass_serial, apple_auth_token, apple_pass_updated_tag, google_loyalty_object_id, joined_at, updated_at) FROM stdin;
\.


--
-- Data for Name: loyalty_program; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.loyalty_program (tenant_id, id, enabled, program_name, mode, earn_units_per_order, redemption_threshold, reward_discount_cents, birthday_bonus_units, vip_silver_min_lifetime_units, vip_gold_min_lifetime_units, referral_bonus_units, referral_invitee_bonus_units, wallet_passes_enabled, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: offline_order_idempotency; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.offline_order_idempotency (tenant_id, id, idempotency_key, order_id, created_at) FROM stdin;
\.


--
-- Data for Name: opening_hours_baseline_schedule; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.opening_hours_baseline_schedule (id, tenant_id, effective_from, opening_hours, note, created_at) FROM stdin;
\.


--
-- Data for Name: opening_hours_date_override; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.opening_hours_date_override (id, tenant_id, date_from, date_to, closed, opening_hours, note, created_at) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public."order" (tenant_id, id, table_id, status, notes, session_id, customer_name, billing_customer_id, customer_id, created_at, cancelled_at, cancelled_by, bill_requested_at, paid_at, paid_by_user_id, payment_method, revolut_order_id, tip_percent_applied, tip_amount_cents, tip_attributed_user_id, location_verified, flagged_for_review, flag_reason, deleted_at, deleted_by_user_id, staff_urgent, delivery_integration_id, external_order_ref, order_channel, delivery_address, customer_phone, courier_user_id, delivery_fee_cents, loyalty_membership_id, loyalty_discount_cents, loyalty_units_redeemed) FROM stdin;
1	1	1	paid	\N	\N	\N	\N	\N	2026-08-01 20:34:37.131589	\N	\N	2026-08-01 20:35:03.119679	2026-08-01 20:37:33.40382	1	cash	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	\N	table	\N	\N	\N	0	\N	0	0
1	2	\N	preparing	\N	\N	\N	\N	\N	2026-08-01 20:39:03.139303	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	2026-08-01 20:40:35.90049	1	t	\N	\N	satisfecho_delivery	Portgoviejo	\N	\N	0	\N	0	0
1	3	1	paid	\N	\N	\N	\N	\N	2026-08-01 20:47:23.7998	\N	\N	\N	2026-08-01 20:58:01.235404	1	cash	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	\N	table	\N	\N	\N	0	\N	0	0
1	4	\N	pending	\N	\N	\N	\N	\N	2026-08-01 20:58:40.012658	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	\N	satisfecho_delivery	Portoviejo	\N	\N	0	\N	0	0
\.


--
-- Data for Name: order_payment; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_payment (tenant_id, id, order_id, amount_cents, payment_method, payer_label, tip_amount_cents, stripe_payment_intent_id, paid_by_user_id, paid_at, voided_at, note) FROM stdin;
1	1	1	450	cash	\N	\N	\N	1	2026-08-01 20:37:33.40382	\N	\N
1	2	3	1750	cash	\N	\N	\N	1	2026-08-01 20:58:01.235404	\N	Full settlement (mark-paid)
\.


--
-- Data for Name: order_payment_item; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_payment_item (tenant_id, id, order_payment_id, order_item_id, amount_cents) FROM stdin;
1	1	1	1	450
\.


--
-- Data for Name: orderitem; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.orderitem (id, order_id, product_id, product_name, quantity, price_cents, cost_cents, notes, customization_answers, customization_summary, line_modifiers, line_modifiers_summary, list_price_cents, discount_cents, promo_id, promo_snapshot, tax_id, tax_rate_percent, tax_amount_cents, status, status_updated_at, prepared_by_user_id, delivered_by_user_id, removed_by_customer, removed_at, removed_reason, removed_by_user_id, modified_by_user_id, modified_at, cancelled_reason, added_by_session, location_flagged) FROM stdin;
2	2	3	Tenders 3 pzas (Single)	1	450	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	41	preparing	2026-08-01 20:39:26.752428	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
3	2	5	Tenders 5 pzas (Single)	1	650	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	59	preparing	2026-08-01 20:39:32.450556	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
4	2	7	Red Chicken Sandwich (Single)	1	590	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	54	preparing	2026-08-01 20:39:33.875529	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
5	2	6	Tenders 5 pzas (Combo)	1	850	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	77	preparing	2026-08-01 20:39:35.482197	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
6	3	3	Tenders 3 pzas (Single)	1	450	\N	\N	{"1": "Spark — suave"}	Nivel de picante: Spark — suave	null	\N	\N	0	\N	null	1	10	41	delivered	2026-08-01 20:50:39.505144	1	1	f	\N	\N	\N	\N	\N	\N	f36b6cea-fdc1-483a-bfd9-a9f07c0d0d8d	f
8	3	5	Tenders 5 pzas (Single)	1	650	\N	\N	{"3": "Blaze — intenso"}	Nivel de picante: Blaze — intenso	null	\N	\N	0	\N	null	1	10	59	delivered	2026-08-01 20:50:41.461027	1	1	f	\N	\N	\N	\N	\N	\N	f36b6cea-fdc1-483a-bfd9-a9f07c0d0d8d	f
7	3	4	Tenders 3 pzas (Combo)	1	650	\N	\N	{"2": "Cool — sin picante"}	Nivel de picante: Cool — sin picante	null	\N	\N	0	\N	null	1	10	59	delivered	2026-08-01 20:50:43.259613	1	1	f	\N	\N	\N	\N	\N	\N	f36b6cea-fdc1-483a-bfd9-a9f07c0d0d8d	f
9	4	3	Tenders 3 pzas (Single)	1	450	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	41	pending	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
10	4	6	Tenders 5 pzas (Combo)	1	850	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	77	pending	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
11	4	7	Red Chicken Sandwich (Single)	1	590	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	54	pending	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
12	4	8	Red Chicken Sandwich (Combo)	1	790	\N	\N	null	\N	null	\N	\N	0	\N	null	1	10	72	pending	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f
1	1	3	Tenders 3 pzas (Single)	1	450	\N	Extra salsa	{"1": "Cool — sin picante"}	Nivel de picante: Cool — sin picante	null	\N	\N	0	\N	null	1	10	41	delivered	2026-08-01 21:47:19.866007	1	1	f	\N	\N	\N	\N	\N	\N	ea54be72-408d-4341-b974-d624455a0ba8	f
\.


--
-- Data for Name: password_reset_token; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.password_reset_token (id, user_id, token_hash, expires_at, used_at, created_at) FROM stdin;
\.


--
-- Data for Name: price_promotion; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.price_promotion (tenant_id, id, name, promo_type, percent_off, category, channels, starts_at, ends_at, days_of_week, start_time_local, end_time_local, stackable, enabled, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: print_agent; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.print_agent (tenant_id, id, device_id, display_name, token_hash, last_seen_at, revoked_at, created_at) FROM stdin;
\.


--
-- Data for Name: print_job; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.print_job (tenant_id, id, job_type, printer_role, status, order_id, payload, created_by_user_id, claimed_by_agent_id, claimed_at, completed_at, error_message, created_at) FROM stdin;
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.product (tenant_id, id, name, price_cents, cost_cents, description, image_filename, ingredients, category, subcategory, tax_id, available_from, available_until, kitchen_station_id) FROM stdin;
1	3	Tenders 3 pzas (Single)	450	\N	100% pechuga de pollo, ultra crujientes con salsa Comeback	\N	\N	Chicken Tenders	\N	\N	\N	\N	\N
1	4	Tenders 3 pzas (Combo)	650	\N	3 piezas + acompanamiento	\N	\N	Chicken Tenders	\N	\N	\N	\N	\N
1	5	Tenders 5 pzas (Single)	650	\N	100% pechuga de pollo, ultra crujientes con salsa Comeback	\N	\N	Chicken Tenders	\N	\N	\N	\N	\N
1	6	Tenders 5 pzas (Combo)	850	\N	5 piezas + acompanamiento	\N	\N	Chicken Tenders	\N	\N	\N	\N	\N
1	7	Red Chicken Sandwich (Single)	590	\N	Pollo crispy, pepinillos, salsa Comeback, cheddar en pan brioche	\N	\N	Chicken Sandwiches	\N	\N	\N	\N	\N
1	8	Red Chicken Sandwich (Combo)	790	\N	Sandwich + acompanamiento	\N	\N	Chicken Sandwiches	\N	\N	\N	\N	\N
1	9	Fire Chicken Sandwich (Single)	690	\N	Pollo crispy, jalapenos rojos, doble cheddar, bacon, salsa Comeback, pan Pretzel	\N	\N	Chicken Sandwiches	\N	\N	\N	\N	\N
1	10	Fire Chicken Sandwich (Combo)	890	\N	Sandwich + acompanamiento	\N	\N	Chicken Sandwiches	\N	\N	\N	\N	\N
1	11	Red Bucket Cheese Bacon	650	\N	Papas cargadas con cheddar derretido y tocino crispy	\N	\N	Red Buckets	\N	\N	\N	\N	\N
1	12	Red Bucket Chicken	700	\N	Papas con trozos de pollo crispy y salsa Comeback	\N	\N	Red Buckets	\N	\N	\N	\N	\N
1	13	Super Red Bucket Chicken	850	\N	Papas con pollo crispy, tocino crispy y cheddar derretido	\N	\N	Red Buckets	\N	\N	\N	\N	\N
1	14	Side de papas fritas	150	\N	\N	\N	\N	Extras	\N	\N	\N	\N	\N
1	15	Soda	100	\N	\N	\N	\N	Extras	\N	\N	\N	\N	\N
\.


--
-- Data for Name: product_question; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.product_question (tenant_id, id, product_id, type, label, options, sort_order, required) FROM stdin;
1	1	3	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	2	4	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	3	5	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	4	6	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	5	7	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	6	8	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	7	9	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	8	10	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	9	11	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	10	12	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
1	11	13	choice	Nivel de picante	["Cool — sin picante", "Spark — suave", "Bonfire — medio", "Blaze — intenso", "Inferno — extremo"]	0	t
\.


--
-- Data for Name: product_recipe; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.product_recipe (tenant_id, id, product_id, inventory_item_id, quantity_required, unit, waste_percentage, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: productcatalog; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.productcatalog (id, name, description, category, subcategory, barcode, brand, normalized_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: provider; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.provider (id, tenant_id, name, token, url, api_endpoint, is_active, created_at, full_company_name, address, tax_number, phone, email, bank_iban, bank_bic, bank_name, bank_account_holder) FROM stdin;
\.


--
-- Data for Name: providerproduct; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.providerproduct (id, catalog_id, provider_id, external_id, name, price_cents, image_url, image_filename, availability, country, region, grape_variety, volume_ml, unit, wine_category_id, detailed_description, wine_style, vintage, winery, aromas, elaboration, last_synced_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_order; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.purchase_order (tenant_id, id, order_number, supplier_id, status, order_date, expected_date, received_date, subtotal_cents, tax_cents, total_cents, notes, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_order_item; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.purchase_order_item (id, purchase_order_id, inventory_item_id, quantity_ordered, quantity_received, unit, unit_cost_cents, line_total_cents) FROM stdin;
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.reservation (tenant_id, id, customer_name, customer_phone, customer_email, reservation_date, reservation_time, party_size, status, table_id, seated_at, token, created_at, updated_at, client_notes, customer_notes, owner_notes, delay_notice, client_ip, client_user_agent, client_fingerprint, client_screen_width, client_screen_height, reminder_24h_sent_at, reminder_2h_sent_at, service_type, seating_preference, allergies_has, allergies_detail, preferred_floor_id, locale, guest_birthday_month, guest_birthday_day, guest_birthday_marketing_consent) FROM stdin;
\.


--
-- Data for Name: restaurant_group; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.restaurant_group (id, name, join_code, share_products, share_customers, hub_tenant_id, created_at) FROM stdin;
\.


--
-- Data for Name: restaurant_group_member; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.restaurant_group_member (id, group_id, tenant_id, joined_at) FROM stdin;
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.schema_version (version, description, applied_at) FROM stdin;
1	add tenant fields	2026-08-01 19:31:14.156396
20260111131942	add immediate payment required	2026-08-01 19:31:14.162249
20260111132500	add currency field	2026-08-01 19:31:14.163273
20260111143538	add stripe keys	2026-08-01 19:31:14.16407
20260111175608	add wine category id	2026-08-01 19:31:14.164963
20260112000000	add provider catalog system	2026-08-01 19:31:14.167365
20260112000001	add provider product image filename	2026-08-01 19:31:14.175818
20260112000002	add provider token	2026-08-01 19:31:14.177151
20260112000003	add wine detail fields	2026-08-01 19:31:14.178656
20260112180000	add wine category id	2026-08-01 19:31:14.180795
20260112190000	add product category subcategory	2026-08-01 19:31:14.181794
20260112200000	add floor and table canvas	2026-08-01 19:31:14.183488
20260112200001	drop orderitem product fk	2026-08-01 19:31:14.185916
20260113000000	add order session id and customer name	2026-08-01 19:31:14.187928
20260113000001	add order item status and soft delete	2026-08-01 19:31:14.19007
20260113000002	add order audit fields	2026-08-01 19:31:14.19363
20260113000003	add missing order status enum values	2026-08-01 19:31:14.196004
20260115104644	add language and currency code and i18n text	2026-08-01 19:31:14.198376
20260118000000	add user token version	2026-08-01 19:31:14.203978
20260203233000	add description to product	2026-08-01 19:31:14.204901
20260204000000	add table pin and location	2026-08-01 19:31:14.206122
20260204100000	add user roles	2026-08-01 19:31:14.210429
20260206000000	add waiter assignment	2026-08-01 19:31:14.212788
20260313000000	add reservation table	2026-08-01 19:31:14.214924
20260313140000	fix reservation date time types	2026-08-01 19:31:14.218036
20260313150000	add tenant timezone	2026-08-01 19:31:14.219731
20260314000000	add user provider id	2026-08-01 19:31:14.220488
20260315100000	add provider company fields	2026-08-01 19:31:14.22179
20260315120000	remove empty orders	2026-08-01 19:31:14.223236
20260315130000	add bartender role	2026-08-01 19:31:14.225006
20260316120000	add tenant tax id cif	2026-08-01 19:31:14.225743
20260316140000	add billing customer	2026-08-01 19:31:14.226777
20260316150000	add tenant smtp email	2026-08-01 19:31:14.229616
20260316160000	add reservation customer email	2026-08-01 19:31:14.230947
20260317120000	add shift working plan	2026-08-01 19:31:14.232025
20260317140000	add tenant working plan notification	2026-08-01 19:31:14.233636
20260318100000	add tax system	2026-08-01 19:31:14.234552
20260318110000	add product availability dates	2026-08-01 19:31:14.238379
20260318120000	add provider tenant id	2026-08-01 19:31:14.240042
20260318130000	ensure provider tenant id	2026-08-01 19:31:14.241757
20260318140000	add reservation notes and client tech	2026-08-01 19:31:14.242785
20260318150000	add product cost cents	2026-08-01 19:31:14.244127
20260319100000	add tenant public background color	2026-08-01 19:31:14.245087
20260319110000	add tenant header background	2026-08-01 19:31:14.245968
20260319120000	add tenant revolut merchant secret	2026-08-01 19:31:14.246739
20260319120100	add order revolut order id	2026-08-01 19:31:14.247419
20260319140000	add tenant reservation settings	2026-08-01 19:31:14.248242
20260319140100	add reservation customer notes and delay	2026-08-01 19:31:14.24949
20260319150000	add user otp	2026-08-01 19:31:14.250304
20260319160000	add product questions and order item customization	2026-08-01 19:31:14.251108
20260319170000	add tenant kitchen display timer	2026-08-01 19:31:14.252564
20260320100000	add order deleted at	2026-08-01 19:31:14.253841
20260320110000	add reservation reminder sent at	2026-08-01 19:31:14.255038
20260321130000	add reservation confirmation email template	2026-08-01 19:31:14.255861
20260322120000	reservation turn walk in seated at	2026-08-01 19:31:14.256702
20260322190000	guest feedback and google review url	2026-08-01 19:31:14.258599
20260323103000	public google maps url	2026-08-01 19:31:14.260094
20260323120500	billing customer birth date	2026-08-01 19:31:14.260866
20260323121000	orderitem customization summary	2026-08-01 19:31:14.26176
20260323130000	order staff urgent	2026-08-01 19:31:14.262592
20260323140000	tenant tip presets and order tip	2026-08-01 19:31:14.264012
20260323150000	work session	2026-08-01 19:31:14.265646
20260323160000	billing customer birth date repair	2026-08-01 19:31:14.267672
20260323170000	order item line modifiers	2026-08-01 19:31:14.268454
20260323171000	kitchen stations	2026-08-01 19:31:14.269466
20260324220000	tenant ui modules	2026-08-01 19:31:14.271303
20260325120000	add tenant reservation slot minutes	2026-08-01 19:31:14.271993
20260325140000	password reset token	2026-08-01 19:31:14.272761
20260325180000	staff contract	2026-08-01 19:31:14.274092
20260326103000	staff contract template	2026-08-01 19:31:14.277447
20260326104500	tenant public openstreetmap url	2026-08-01 19:31:14.278403
20260326133000	contract template locale presets	2026-08-01 19:31:14.279978
20260327100000	public terms privacy urls	2026-08-01 19:31:14.284122
20260331120000	reservation booking dynamic filters	2026-08-01 19:31:14.285062
20260331131400	floor is active reservation preferred floor	2026-08-01 19:31:14.286436
20260331180000	work session clock qr breaks	2026-08-01 19:31:14.288032
20260331190000	tenant tip entry mode order tip attribution	2026-08-01 19:31:14.29103
20260401103000	floor seating zone	2026-08-01 19:31:14.292911
20260401140000	table group	2026-08-01 19:31:14.294685
20260403150000	reservation locale	2026-08-01 19:31:14.296471
20260406131500	add user employee number	2026-08-01 19:31:14.297273
20260406140000	tenant clock qr token encrypted	2026-08-01 19:31:14.297982
20260407120000	tenant ccc	2026-08-01 19:31:14.298743
20260413150000	order table id nullable soft delete unlink	2026-08-01 19:31:14.299483
20260414103000	order bill requested at	2026-08-01 19:31:14.300598
20260421160000	opening hours schedule	2026-08-01 19:31:14.301485
20260427120000	delivery marketplace integration	2026-08-01 19:31:14.30364
20260427143000	social posts	2026-08-01 19:31:14.307192
20260501120000	fiscal invoice verifactu	2026-08-01 19:31:14.31033
20260528140000	add centiliter unitofmeasure	2026-08-01 19:31:14.312037
20260601170000	tenant custom subcategories	2026-08-01 19:31:14.31283
20260619120000	add courier role	2026-08-01 19:31:14.313751
20260621120000	align user role column enum	2026-08-01 19:31:14.31552
20260712120000	waiting list entry	2026-08-01 19:31:14.318711
20260712140000	restaurant group	2026-08-01 19:31:14.320331
20260712180000	platform operator login events	2026-08-01 19:31:14.321549
20260717200000	tenant saas subscription	2026-08-01 19:31:14.323341
20260720220000	order satisfecho delivery	2026-08-01 19:31:14.324856
20260721220000	order status out for delivery	2026-08-01 19:31:14.32732
20260723220000	delivery zones fees	2026-08-01 19:31:14.328308
20260726132730	inventory warehouse	2026-08-01 19:31:14.330076
20260726142100	fiscal invoice hash chain	2026-08-01 19:31:14.335673
20260726153500	offline order idempotency	2026-08-01 19:31:14.338285
20260726162500	club loyalty	2026-08-01 19:31:14.339993
20260726170000	guest birthday	2026-08-01 19:31:14.344762
20260726171000	price promotions	2026-08-01 19:31:14.347553
20260726172000	branch hub fulfillment	2026-08-01 19:31:14.350161
20260726174000	print jobs	2026-08-01 19:31:14.352497
20260726180000	order payment split	2026-08-01 19:31:14.355388
20260726190000	tse fiscal	2026-08-01 19:31:14.35747
20260726223000	split by line and loyalty birthday	2026-08-01 19:31:14.360745
20260727073523	loyalty vip referral	2026-08-01 19:31:14.364278
20260731114840	add end user customer	2026-08-01 19:31:14.369396
20260801131339	loyalty wallet passes	2026-08-01 19:31:14.371686
\.


--
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.shift (tenant_id, id, user_id, shift_date, start_time, end_time, label, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: social_connection; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.social_connection (id, tenant_id, provider_key, connection_status, oauth_payload_encrypted, meta_page_id, meta_page_name, instagram_account_id, updated_at) FROM stdin;
\.


--
-- Data for Name: social_oauth_state; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.social_oauth_state (state, tenant_id, user_id, provider_key, redirect_uri, created_at) FROM stdin;
\.


--
-- Data for Name: social_post; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.social_post (id, tenant_id, caption, image_filename, schedule_at, status, error_message, created_by_user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: social_post_target; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.social_post_target (id, social_post_id, channel_key, status, external_id, error_message) FROM stdin;
\.


--
-- Data for Name: staff_contract; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.staff_contract (id, tenant_id, contract_group_id, version, subject_user_id, kind, status, role_title, start_date, end_date, compensation_summary, tax_identifier_subject, payment_structure, payment_terms, jurisdiction_note, template_key, notes_internal, document_filename, document_uploaded_at, created_by_user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: staff_contract_template; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.staff_contract_template (id, tenant_id, template_key, name, body, locale, kind, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: staff_contract_template_preset; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.staff_contract_template_preset (id, region_code, locale, template_key, name, body, kind, created_at, updated_at) FROM stdin;
1	ES	es	es_empleado_temporal	Contrato temporal — España (modelo orientativo)	\n<h1>Contrato de trabajo temporal (modelo orientativo)</h1>\n<p><em>Documento de ejemplo con {{placeholders}}; no sustituye asesoramiento legal.</em></p>\n<p>Entre <strong>{{employer_name}}</strong>, con domicilio en {{employer_address}} e identificación fiscal {{employer_tax_id}}, en adelante la empresa, y <strong>{{worker_name}}</strong> ({{worker_email}}), en adelante el trabajador, se acuerda lo siguiente:</p>\n<h2>1. Objeto y categoría profesional</h2>\n<p>El trabajador prestará sus servicios como <strong>{{role_title}}</strong> (contrato de naturaleza {{kind}}).</p>\n<h2>2. Duración</h2>\n<p>Fecha de inicio: {{start_date}}. Fecha de finalización (si procede): {{end_date}}.</p>\n<h2>3. Retribución</h2>\n<p>{{compensation_summary}}</p>\n<h2>4. Pagos y condiciones</h2>\n<p>{{payment_terms}}. Estructura de pago: {{payment_structure}}.</p>\n<h2>5. Legislación y notas</h2>\n<p>{{jurisdiction_note}}</p>\n<p>Versión del expediente: {{contract_version}} · Estado: {{contract_status}}.</p>\n	employee	2026-08-01 19:31:14.279978+00	2026-08-01 19:31:14.279978+00
2	IN	en	in_employee_basic	Employment agreement — India (sample outline)	\n<h1>Employment agreement (sample outline)</h1>\n<p><em>Example template with {{placeholders}}; seek local legal review before use.</em></p>\n<p>This agreement is between <strong>{{employer_name}}</strong> (address: {{employer_address}}, tax ID: {{employer_tax_id}}) and <strong>{{worker_name}}</strong> ({{worker_email}}).</p>\n<h2>1. Role</h2>\n<p>The worker will serve as <strong>{{role_title}}</strong> ({{kind}}).</p>\n<h2>2. Term</h2>\n<p>Start date: {{start_date}}. End date (if fixed-term): {{end_date}}.</p>\n<h2>3. Compensation</h2>\n<p>{{compensation_summary}}</p>\n<h2>4. Payment terms</h2>\n<p>{{payment_terms}}. Payment structure: {{payment_structure}}.</p>\n<h2>5. Jurisdiction / notes</h2>\n<p>{{jurisdiction_note}}</p>\n<p>Record version: {{contract_version}} · Status: {{contract_status}}.</p>\n	employee	2026-08-01 19:31:14.279978+00	2026-08-01 19:31:14.279978+00
3	*	en	en_employee_basic	Basic employment template (English)	\n<h1>Employment contract (basic template)</h1>\n<p><em>Sample only — adapt to your jurisdiction and obtain legal advice.</em></p>\n<p>Between <strong>{{employer_name}}</strong> ({{employer_address}}, tax ID {{employer_tax_id}}) and <strong>{{worker_name}}</strong> ({{worker_email}}).</p>\n<h2>1. Position</h2>\n<p>Title: <strong>{{role_title}}</strong>. Type: {{kind}}.</p>\n<h2>2. Dates</h2>\n<p>Start: {{start_date}}. End (if any): {{end_date}}.</p>\n<h2>3. Compensation</h2>\n<p>{{compensation_summary}}</p>\n<h2>4. Payment</h2>\n<p>{{payment_terms}} (structure: {{payment_structure}}).</p>\n<h2>5. Other</h2>\n<p>{{jurisdiction_note}}</p>\n<p>Version {{contract_version}} · {{contract_status}}</p>\n	employee	2026-08-01 19:31:14.279978+00	2026-08-01 19:31:14.279978+00
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.supplier (tenant_id, id, name, code, contact_name, phone, email, address, payment_terms, lead_time_days, minimum_order_cents, notes, is_active, is_deleted, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: table; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public."table" (tenant_id, id, name, token, floor_id, x_position, y_position, rotation, shape, width, height, seat_count, table_group_id, assigned_waiter_id, order_pin, is_active, active_order_id, activated_at) FROM stdin;
1	3	Para llevar	6731026c-c616-4d5e-a442-bd98480d0024	1	174	50	0	rectangle	100	60	4	\N	\N	5949	t	\N	2026-08-01 20:38:17.251357
1	1	Mesa 1	a5d454d2-775d-4cb6-adc5-fb9d397ba1ca	1	55.316226959228516	82.06938934326172	0	circle	80	80	4	\N	\N	6644	t	3	2026-08-01 20:31:21.444315
\.


--
-- Data for Name: table_group; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_group (tenant_id, id, created_at) FROM stdin;
\.


--
-- Data for Name: tax; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.tax (id, tenant_id, name, rate_percent, valid_from, valid_to, created_at) FROM stdin;
3	1	IVA 0% (exento)	0	2026-08-01	\N	2026-08-01 19:49:35.106963
1	1	IVA 15%	15	2026-08-01	\N	2026-08-01 19:49:35.106796
\.


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.tenant (id, name, created_at, business_type, description, phone, whatsapp, email, address, website, tax_id, cif, ccc, logo_filename, header_background_filename, public_background_color, opening_hours, immediate_payment_required, currency_code, currency, default_language, timezone, country_code, stripe_secret_key, stripe_publishable_key, revolut_merchant_secret, latitude, longitude, location_radius_meters, location_check_enabled, smtp_host, smtp_port, smtp_use_tls, smtp_user, smtp_password, email_from, email_from_name, reservation_confirmation_email_subject, reservation_confirmation_email_body, working_plan_updated_at, working_plan_owner_seen_at, reservation_prepayment_cents, reservation_prepayment_text, reservation_cancellation_policy, reservation_arrival_tolerance_minutes, reservation_average_table_turn_minutes, reservation_slot_minutes, reservation_max_guests_per_slot, reservation_walk_in_tables_reserved, reservation_dress_code, reservation_reminder_24h_enabled, reservation_reminder_2h_enabled, guest_birthday_capture_enabled, guest_birthday_marketing_enabled, guest_birthday_consent_text, delivery_fee_cents, delivery_radius_meters, delivery_postal_codes, public_google_review_url, public_google_maps_url, public_openstreetmap_url, public_terms_of_service_url, public_privacy_policy_url, kitchen_display_timer_yellow_minutes, kitchen_display_timer_orange_minutes, kitchen_display_timer_red_minutes, tip_preset_percents, tip_tax_rate_percent, tip_entry_mode, default_tax_id, default_kitchen_station_id, default_bar_station_id, ui_modules, custom_subcategories, clock_qr_token_hash, clock_qr_token_encrypted, clock_qr_location_verify, fiscal_mode, fiscal_invoice_series, fiscal_invoice_next_number, fiscal_aeat_api_secret, fiscal_country, tse_mode, tse_client_id, tse_api_secret, tse_serial_number, tse_signature_counter, saas_subscription_status, saas_trial_ends_at, saas_subscription_ends_at, saas_stripe_customer_id, saas_stripe_subscription_id) FROM stdin;
1	Red Chicken	2026-08-01 19:47:30.779144	restaurant	\N	+593999241230	\N	\N	Portoviejo	\N	\N	\N	\N	\N	\N	\N	{"monday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"tuesday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"wednesday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"thursday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"friday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"saturday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0},"sunday":{"closed":false,"open":"09:00","close":"22:00","bar":0,"waiter":0,"kitchen":0,"receptionist":0}}	f	USD	$	\N	\N	\N	\N	\N	\N	\N	\N	100	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	f	f	t	f	\N	0	\N	\N	\N	\N	\N	\N	\N	5	10	15	[5, 10, 15, 20]	0	preset	1	\N	\N	{"contracts": false, "inventory": false, "providers": false, "working_plan": false}	null	\N	\N	f	off	VF	1	\N	\N	off	\N	\N	\N	1	grandfathered	\N	\N	\N	\N
\.


--
-- Data for Name: tenantproduct; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.tenantproduct (id, tenant_id, catalog_id, provider_product_id, product_id, name, price_cents, cost_cents, image_filename, ingredients, is_active, tax_id, available_from, available_until, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tse_transaction; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.tse_transaction (id, tenant_id, order_id, process_type, mode, tse_serial, signature_counter, signature_value, qr_content, process_data, transaction_number, certificate_serial, time_start, time_end, amount_cents, request_payload, response_payload, submission_status, storno_of_tse_transaction_id, created_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public."user" (id, email, hashed_password, full_name, token_version, role, tenant_id, provider_id, otp_secret, otp_enabled, employee_number) FROM stdin;
1	lopezysocios@gmail.com	$2b$12$6jXYuOQsPd7J1zykQ7mYuuWrHYg9f2NigbdizVmdJtIcz.YrMrxj2	Washington Franco	0	owner	1	\N	\N	f	\N
\.


--
-- Data for Name: waiting_list_entry; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.waiting_list_entry (tenant_id, id, customer_name, customer_phone, party_size, status, notified_at, client_ip, client_user_agent, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.warehouse (tenant_id, id, name, code, is_default, is_active, is_deleted, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: warehouse_stock; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.warehouse_stock (tenant_id, id, warehouse_id, inventory_item_id, quantity, updated_at) FROM stdin;
\.


--
-- Data for Name: work_session; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.work_session (tenant_id, id, user_id, started_at, ended_at, start_ip, end_ip, break_started_at) FROM stdin;
1	1	1	2026-08-01 20:05:06.04733+00	2026-08-01 20:05:07.420468+00	192.168.65.1	192.168.65.1	\N
\.


--
-- Data for Name: work_session_adjustment; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.work_session_adjustment (tenant_id, id, work_session_id, created_at, actor_user_id, note, previous_started_at, previous_ended_at, new_started_at, new_ended_at) FROM stdin;
\.


--
-- Data for Name: work_session_break; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.work_session_break (tenant_id, id, work_session_id, started_at, ended_at) FROM stdin;
\.


--
-- Name: billing_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.billing_customer_id_seq', 1, false);


--
-- Name: branch_hub_fulfillment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.branch_hub_fulfillment_id_seq', 1, false);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.customer_id_seq', 1, false);


--
-- Name: delivery_catalog_mapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.delivery_catalog_mapping_id_seq', 1, false);


--
-- Name: delivery_integration_event_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.delivery_integration_event_log_id_seq', 1, false);


--
-- Name: delivery_marketplace_integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.delivery_marketplace_integration_id_seq', 1, false);


--
-- Name: fiscal_invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.fiscal_invoice_id_seq', 1, false);


--
-- Name: floor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.floor_id_seq', 1, true);


--
-- Name: guest_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.guest_feedback_id_seq', 1, false);


--
-- Name: i18n_text_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.i18n_text_id_seq', 1, false);


--
-- Name: i18ntext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.i18ntext_id_seq', 1, false);


--
-- Name: inventory_batch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.inventory_batch_id_seq', 1, false);


--
-- Name: inventory_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.inventory_item_id_seq', 1, false);


--
-- Name: inventory_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.inventory_transaction_id_seq', 1, false);


--
-- Name: kitchen_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.kitchen_station_id_seq', 1, true);


--
-- Name: login_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.login_event_id_seq', 4, true);


--
-- Name: loyalty_apple_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.loyalty_apple_device_id_seq', 1, false);


--
-- Name: loyalty_ledger_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.loyalty_ledger_entry_id_seq', 1, false);


--
-- Name: loyalty_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.loyalty_membership_id_seq', 1, false);


--
-- Name: loyalty_program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.loyalty_program_id_seq', 1, false);


--
-- Name: offline_order_idempotency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.offline_order_idempotency_id_seq', 1, false);


--
-- Name: opening_hours_baseline_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.opening_hours_baseline_schedule_id_seq', 1, false);


--
-- Name: opening_hours_date_override_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.opening_hours_date_override_id_seq', 1, false);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.order_id_seq', 4, true);


--
-- Name: order_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.order_payment_id_seq', 2, true);


--
-- Name: order_payment_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.order_payment_item_id_seq', 1, true);


--
-- Name: orderitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.orderitem_id_seq', 12, true);


--
-- Name: password_reset_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.password_reset_token_id_seq', 1, false);


--
-- Name: price_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.price_promotion_id_seq', 1, false);


--
-- Name: print_agent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.print_agent_id_seq', 1, false);


--
-- Name: print_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.print_job_id_seq', 1, false);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.product_id_seq', 15, true);


--
-- Name: product_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.product_question_id_seq', 11, true);


--
-- Name: product_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.product_recipe_id_seq', 1, false);


--
-- Name: productcatalog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.productcatalog_id_seq', 1, false);


--
-- Name: provider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.provider_id_seq', 1, false);


--
-- Name: providerproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.providerproduct_id_seq', 1, false);


--
-- Name: purchase_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.purchase_order_id_seq', 1, false);


--
-- Name: purchase_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.purchase_order_item_id_seq', 1, false);


--
-- Name: reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.reservation_id_seq', 1, false);


--
-- Name: restaurant_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.restaurant_group_id_seq', 1, false);


--
-- Name: restaurant_group_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.restaurant_group_member_id_seq', 1, false);


--
-- Name: shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.shift_id_seq', 1, false);


--
-- Name: social_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.social_connection_id_seq', 1, false);


--
-- Name: social_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.social_post_id_seq', 1, false);


--
-- Name: social_post_target_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.social_post_target_id_seq', 1, false);


--
-- Name: staff_contract_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.staff_contract_id_seq', 1, false);


--
-- Name: staff_contract_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.staff_contract_template_id_seq', 1, false);


--
-- Name: staff_contract_template_preset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.staff_contract_template_preset_id_seq', 3, true);


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.supplier_id_seq', 1, false);


--
-- Name: table_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.table_group_id_seq', 1, false);


--
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.table_id_seq', 3, true);


--
-- Name: tax_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.tax_id_seq', 4, true);


--
-- Name: tenant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.tenant_id_seq', 1, true);


--
-- Name: tenantproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.tenantproduct_id_seq', 1, false);


--
-- Name: tse_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.tse_transaction_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: waiting_list_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.waiting_list_entry_id_seq', 1, false);


--
-- Name: warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.warehouse_id_seq', 1, false);


--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.warehouse_stock_id_seq', 1, false);


--
-- Name: work_session_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.work_session_adjustment_id_seq', 1, false);


--
-- Name: work_session_break_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.work_session_break_id_seq', 1, false);


--
-- Name: work_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.work_session_id_seq', 1, true);


--
-- Name: billing_customer billing_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.billing_customer
    ADD CONSTRAINT billing_customer_pkey PRIMARY KEY (id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: delivery_catalog_mapping delivery_catalog_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_catalog_mapping
    ADD CONSTRAINT delivery_catalog_mapping_pkey PRIMARY KEY (id);


--
-- Name: delivery_integration_event_log delivery_integration_event_log_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_integration_event_log
    ADD CONSTRAINT delivery_integration_event_log_pkey PRIMARY KEY (id);


--
-- Name: delivery_marketplace_integration delivery_marketplace_integration_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_marketplace_integration
    ADD CONSTRAINT delivery_marketplace_integration_pkey PRIMARY KEY (id);


--
-- Name: fiscal_invoice fiscal_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.fiscal_invoice
    ADD CONSTRAINT fiscal_invoice_pkey PRIMARY KEY (id);


--
-- Name: floor floor_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.floor
    ADD CONSTRAINT floor_pkey PRIMARY KEY (id);


--
-- Name: guest_feedback guest_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.guest_feedback
    ADD CONSTRAINT guest_feedback_pkey PRIMARY KEY (id);


--
-- Name: i18n_text i18n_text_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18n_text
    ADD CONSTRAINT i18n_text_pkey PRIMARY KEY (id);


--
-- Name: i18ntext i18ntext_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18ntext
    ADD CONSTRAINT i18ntext_pkey PRIMARY KEY (id);


--
-- Name: inventory_batch inventory_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch
    ADD CONSTRAINT inventory_batch_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_transaction inventory_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_pkey PRIMARY KEY (id);


--
-- Name: kitchen_station kitchen_station_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kitchen_station
    ADD CONSTRAINT kitchen_station_pkey PRIMARY KEY (id);


--
-- Name: login_event login_event_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.login_event
    ADD CONSTRAINT login_event_pkey PRIMARY KEY (id);


--
-- Name: loyalty_apple_device loyalty_apple_device_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_apple_device
    ADD CONSTRAINT loyalty_apple_device_pkey PRIMARY KEY (id);


--
-- Name: loyalty_ledger_entry loyalty_ledger_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry
    ADD CONSTRAINT loyalty_ledger_entry_pkey PRIMARY KEY (id);


--
-- Name: loyalty_membership loyalty_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership
    ADD CONSTRAINT loyalty_membership_pkey PRIMARY KEY (id);


--
-- Name: loyalty_program loyalty_program_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT loyalty_program_pkey PRIMARY KEY (id);


--
-- Name: offline_order_idempotency offline_order_idempotency_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.offline_order_idempotency
    ADD CONSTRAINT offline_order_idempotency_pkey PRIMARY KEY (id);


--
-- Name: opening_hours_baseline_schedule opening_hours_baseline_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_baseline_schedule
    ADD CONSTRAINT opening_hours_baseline_schedule_pkey PRIMARY KEY (id);


--
-- Name: opening_hours_date_override opening_hours_date_override_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_date_override
    ADD CONSTRAINT opening_hours_date_override_pkey PRIMARY KEY (id);


--
-- Name: order_payment_item order_payment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment_item
    ADD CONSTRAINT order_payment_item_pkey PRIMARY KEY (id);


--
-- Name: order_payment order_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: orderitem orderitem_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_pkey PRIMARY KEY (id);


--
-- Name: password_reset_token password_reset_token_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.password_reset_token
    ADD CONSTRAINT password_reset_token_pkey PRIMARY KEY (id);


--
-- Name: price_promotion price_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.price_promotion
    ADD CONSTRAINT price_promotion_pkey PRIMARY KEY (id);


--
-- Name: print_agent print_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_agent
    ADD CONSTRAINT print_agent_pkey PRIMARY KEY (id);


--
-- Name: print_job print_job_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job
    ADD CONSTRAINT print_job_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_question product_question_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_question
    ADD CONSTRAINT product_question_pkey PRIMARY KEY (id);


--
-- Name: product_recipe product_recipe_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_recipe
    ADD CONSTRAINT product_recipe_pkey PRIMARY KEY (id);


--
-- Name: productcatalog productcatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.productcatalog
    ADD CONSTRAINT productcatalog_pkey PRIMARY KEY (id);


--
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (id);


--
-- Name: providerproduct providerproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.providerproduct
    ADD CONSTRAINT providerproduct_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_item purchase_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_item
    ADD CONSTRAINT purchase_order_item_pkey PRIMARY KEY (id);


--
-- Name: purchase_order purchase_order_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_pkey PRIMARY KEY (id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (id);


--
-- Name: restaurant_group_member restaurant_group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group_member
    ADD CONSTRAINT restaurant_group_member_pkey PRIMARY KEY (id);


--
-- Name: restaurant_group restaurant_group_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group
    ADD CONSTRAINT restaurant_group_pkey PRIMARY KEY (id);


--
-- Name: schema_version schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (version);


--
-- Name: shift shift_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pkey PRIMARY KEY (id);


--
-- Name: social_connection social_connection_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_connection
    ADD CONSTRAINT social_connection_pkey PRIMARY KEY (id);


--
-- Name: social_oauth_state social_oauth_state_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_oauth_state
    ADD CONSTRAINT social_oauth_state_pkey PRIMARY KEY (state);


--
-- Name: social_post social_post_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post
    ADD CONSTRAINT social_post_pkey PRIMARY KEY (id);


--
-- Name: social_post_target social_post_target_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post_target
    ADD CONSTRAINT social_post_target_pkey PRIMARY KEY (id);


--
-- Name: staff_contract staff_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract
    ADD CONSTRAINT staff_contract_pkey PRIMARY KEY (id);


--
-- Name: staff_contract_template staff_contract_template_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template
    ADD CONSTRAINT staff_contract_template_pkey PRIMARY KEY (id);


--
-- Name: staff_contract_template_preset staff_contract_template_preset_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template_preset
    ADD CONSTRAINT staff_contract_template_preset_pkey PRIMARY KEY (id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: table_group table_group_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_group
    ADD CONSTRAINT table_group_pkey PRIMARY KEY (id);


--
-- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_pkey PRIMARY KEY (id);


--
-- Name: tax tax_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax
    ADD CONSTRAINT tax_pkey PRIMARY KEY (id);


--
-- Name: tenant tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_pkey PRIMARY KEY (id);


--
-- Name: tenantproduct tenantproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_pkey PRIMARY KEY (id);


--
-- Name: tse_transaction tse_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tse_transaction
    ADD CONSTRAINT tse_transaction_pkey PRIMARY KEY (id);


--
-- Name: loyalty_apple_device uq_loyalty_apple_device_membership_device; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_apple_device
    ADD CONSTRAINT uq_loyalty_apple_device_membership_device UNIQUE (membership_id, device_library_identifier);


--
-- Name: loyalty_program uq_loyalty_program_tenant; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT uq_loyalty_program_tenant UNIQUE (tenant_id);


--
-- Name: offline_order_idempotency uq_offline_order_idempotency_tenant_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.offline_order_idempotency
    ADD CONSTRAINT uq_offline_order_idempotency_tenant_key UNIQUE (tenant_id, idempotency_key);


--
-- Name: print_agent uq_print_agent_tenant_device; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_agent
    ADD CONSTRAINT uq_print_agent_tenant_device UNIQUE (tenant_id, device_id);


--
-- Name: print_agent uq_print_agent_token_hash; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_agent
    ADD CONSTRAINT uq_print_agent_token_hash UNIQUE (token_hash);


--
-- Name: staff_contract_template_preset uq_staff_contract_template_preset_region_locale_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template_preset
    ADD CONSTRAINT uq_staff_contract_template_preset_region_locale_key UNIQUE (region_code, locale, template_key);


--
-- Name: staff_contract_template uq_staff_contract_template_tenant_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template
    ADD CONSTRAINT uq_staff_contract_template_tenant_key UNIQUE (tenant_id, template_key);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: waiting_list_entry waiting_list_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.waiting_list_entry
    ADD CONSTRAINT waiting_list_entry_pkey PRIMARY KEY (id);


--
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);


--
-- Name: warehouse_stock warehouse_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_pkey PRIMARY KEY (id);


--
-- Name: work_session_adjustment work_session_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_adjustment
    ADD CONSTRAINT work_session_adjustment_pkey PRIMARY KEY (id);


--
-- Name: work_session_break work_session_break_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_break
    ADD CONSTRAINT work_session_break_pkey PRIMARY KEY (id);


--
-- Name: work_session work_session_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session
    ADD CONSTRAINT work_session_pkey PRIMARY KEY (id);


--
-- Name: i18n_text_lookup_global; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX i18n_text_lookup_global ON public.i18n_text USING btree (entity_type, entity_id, lang) WHERE (tenant_id IS NULL);


--
-- Name: i18n_text_lookup_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX i18n_text_lookup_tenant ON public.i18n_text USING btree (tenant_id, entity_type, entity_id, lang);


--
-- Name: i18n_text_unique_global; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX i18n_text_unique_global ON public.i18n_text USING btree (entity_type, entity_id, field, lang) WHERE (tenant_id IS NULL);


--
-- Name: i18n_text_unique_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX i18n_text_unique_tenant ON public.i18n_text USING btree (tenant_id, entity_type, entity_id, field, lang) WHERE (tenant_id IS NOT NULL);


--
-- Name: idx_billing_customer_company_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_billing_customer_company_name ON public.billing_customer USING btree (company_name);


--
-- Name: idx_billing_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_billing_customer_email ON public.billing_customer USING btree (email);


--
-- Name: idx_billing_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_billing_customer_name ON public.billing_customer USING btree (name);


--
-- Name: idx_billing_customer_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_billing_customer_tax_id ON public.billing_customer USING btree (tax_id);


--
-- Name: idx_billing_customer_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_billing_customer_tenant ON public.billing_customer USING btree (tenant_id);


--
-- Name: idx_branch_hub_fulfillment_branch; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_branch_hub_fulfillment_branch ON public.branch_hub_fulfillment USING btree (branch_tenant_id);


--
-- Name: idx_branch_hub_fulfillment_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_branch_hub_fulfillment_group ON public.branch_hub_fulfillment USING btree (group_id);


--
-- Name: idx_branch_hub_fulfillment_hub; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_branch_hub_fulfillment_hub ON public.branch_hub_fulfillment USING btree (hub_tenant_id, status);


--
-- Name: idx_customer_email_verification_token_hash; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_customer_email_verification_token_hash ON public.customer USING btree (email_verification_token_hash) WHERE (email_verification_token_hash IS NOT NULL);


--
-- Name: idx_floor_default_waiter; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_floor_default_waiter ON public.floor USING btree (default_waiter_id);


--
-- Name: idx_floor_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_floor_tenant ON public.floor USING btree (tenant_id);


--
-- Name: idx_login_event_logged_in_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_login_event_logged_in_at ON public.login_event USING btree (logged_in_at DESC);


--
-- Name: idx_login_event_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_login_event_tenant_id ON public.login_event USING btree (tenant_id);


--
-- Name: idx_order_billing_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_billing_customer ON public."order" USING btree (billing_customer_id);


--
-- Name: idx_order_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_customer ON public."order" USING btree (customer_id);


--
-- Name: idx_order_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_customer_name ON public."order" USING btree (customer_name);


--
-- Name: idx_order_paid; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_paid ON public."order" USING btree (paid_at, payment_method);


--
-- Name: idx_order_session; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_session ON public."order" USING btree (table_id, session_id);


--
-- Name: idx_order_tenant_staff_urgent; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_tenant_staff_urgent ON public."order" USING btree (tenant_id, staff_urgent) WHERE (staff_urgent = true);


--
-- Name: idx_orderitem_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orderitem_active ON public.orderitem USING btree (order_id, removed_by_customer) WHERE (removed_by_customer = false);


--
-- Name: idx_orderitem_modified; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orderitem_modified ON public.orderitem USING btree (order_id, modified_at);


--
-- Name: idx_orderitem_removed; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orderitem_removed ON public.orderitem USING btree (order_id, removed_by_customer);


--
-- Name: idx_orderitem_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orderitem_status ON public.orderitem USING btree (order_id, status);


--
-- Name: idx_orderitem_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orderitem_tax_id ON public.orderitem USING btree (tax_id) WHERE (tax_id IS NOT NULL);


--
-- Name: idx_product_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_product_category ON public.product USING btree (category) WHERE (category IS NOT NULL);


--
-- Name: idx_product_question_tenant_product; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_product_question_tenant_product ON public.product_question USING btree (tenant_id, product_id);


--
-- Name: idx_product_subcategory; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_product_subcategory ON public.product USING btree (subcategory) WHERE (subcategory IS NOT NULL);


--
-- Name: idx_product_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_product_tax_id ON public.product USING btree (tax_id) WHERE (tax_id IS NOT NULL);


--
-- Name: idx_productcatalog_barcode; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_productcatalog_barcode ON public.productcatalog USING btree (barcode);


--
-- Name: idx_productcatalog_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_productcatalog_category ON public.productcatalog USING btree (category);


--
-- Name: idx_productcatalog_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_productcatalog_name ON public.productcatalog USING btree (name);


--
-- Name: idx_productcatalog_normalized_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_productcatalog_normalized_name ON public.productcatalog USING btree (normalized_name);


--
-- Name: idx_productcatalog_subcategory; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_productcatalog_subcategory ON public.productcatalog USING btree (subcategory);


--
-- Name: idx_provider_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_provider_is_active ON public.provider USING btree (is_active);


--
-- Name: idx_provider_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_provider_name ON public.provider USING btree (name);


--
-- Name: idx_provider_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_provider_tenant_id ON public.provider USING btree (tenant_id) WHERE (tenant_id IS NOT NULL);


--
-- Name: idx_provider_tenant_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX idx_provider_tenant_name ON public.provider USING btree (COALESCE(tenant_id, '-1'::integer), name);


--
-- Name: idx_provider_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX idx_provider_token ON public.provider USING btree (token) WHERE (token IS NOT NULL);


--
-- Name: idx_providerproduct_availability; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_availability ON public.providerproduct USING btree (availability);


--
-- Name: idx_providerproduct_catalog_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_catalog_id ON public.providerproduct USING btree (catalog_id);


--
-- Name: idx_providerproduct_catalog_provider; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_catalog_provider ON public.providerproduct USING btree (catalog_id, provider_id, availability, price_cents);


--
-- Name: idx_providerproduct_external_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_external_id ON public.providerproduct USING btree (external_id);


--
-- Name: idx_providerproduct_image_filename; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_image_filename ON public.providerproduct USING btree (image_filename) WHERE (image_filename IS NOT NULL);


--
-- Name: idx_providerproduct_price; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_price ON public.providerproduct USING btree (price_cents) WHERE (price_cents IS NOT NULL);


--
-- Name: idx_providerproduct_provider_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_provider_id ON public.providerproduct USING btree (provider_id);


--
-- Name: idx_providerproduct_vintage; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_vintage ON public.providerproduct USING btree (vintage) WHERE (vintage IS NOT NULL);


--
-- Name: idx_providerproduct_wine_category_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_wine_category_id ON public.providerproduct USING btree (wine_category_id) WHERE (wine_category_id IS NOT NULL);


--
-- Name: idx_providerproduct_winery; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_providerproduct_winery ON public.providerproduct USING btree (winery) WHERE (winery IS NOT NULL);


--
-- Name: idx_reservation_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_reservation_customer_email ON public.reservation USING btree (customer_email) WHERE (customer_email IS NOT NULL);


--
-- Name: idx_reservation_table; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_reservation_table ON public.reservation USING btree (table_id);


--
-- Name: idx_reservation_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_reservation_tenant ON public.reservation USING btree (tenant_id);


--
-- Name: idx_reservation_tenant_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_reservation_tenant_date ON public.reservation USING btree (tenant_id, reservation_date);


--
-- Name: idx_reservation_tenant_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_reservation_tenant_status ON public.reservation USING btree (tenant_id, status);


--
-- Name: idx_reservation_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX idx_reservation_token ON public.reservation USING btree (token) WHERE (token IS NOT NULL);


--
-- Name: idx_restaurant_group_member_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_restaurant_group_member_group ON public.restaurant_group_member USING btree (group_id);


--
-- Name: idx_shift_tenant_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_shift_tenant_date ON public.shift USING btree (tenant_id, shift_date);


--
-- Name: idx_shift_user_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_shift_user_date ON public.shift USING btree (user_id, shift_date);


--
-- Name: idx_table_assigned_waiter; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_assigned_waiter ON public."table" USING btree (assigned_waiter_id);


--
-- Name: idx_table_floor; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_floor ON public."table" USING btree (floor_id);


--
-- Name: idx_table_group_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_group_tenant ON public.table_group USING btree (tenant_id);


--
-- Name: idx_table_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_is_active ON public."table" USING btree (is_active);


--
-- Name: idx_table_table_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_table_group ON public."table" USING btree (table_group_id);


--
-- Name: idx_tax_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tax_tenant_id ON public.tax USING btree (tenant_id);


--
-- Name: idx_tax_valid; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tax_valid ON public.tax USING btree (tenant_id, valid_from, valid_to);


--
-- Name: idx_tenant_default_tax; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenant_default_tax ON public.tenant USING btree (default_tax_id);


--
-- Name: idx_tenant_saas_subscription_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenant_saas_subscription_status ON public.tenant USING btree (saas_subscription_status);


--
-- Name: idx_tenantproduct_catalog_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_catalog_id ON public.tenantproduct USING btree (catalog_id);


--
-- Name: idx_tenantproduct_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_is_active ON public.tenantproduct USING btree (is_active);


--
-- Name: idx_tenantproduct_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_product_id ON public.tenantproduct USING btree (product_id);


--
-- Name: idx_tenantproduct_provider_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_provider_product_id ON public.tenantproduct USING btree (provider_product_id);


--
-- Name: idx_tenantproduct_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_tax_id ON public.tenantproduct USING btree (tax_id) WHERE (tax_id IS NOT NULL);


--
-- Name: idx_tenantproduct_tenant_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_tenant_active ON public.tenantproduct USING btree (tenant_id, is_active);


--
-- Name: idx_tenantproduct_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_tenantproduct_tenant_id ON public.tenantproduct USING btree (tenant_id);


--
-- Name: idx_user_provider_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_user_provider_id ON public."user" USING btree (provider_id) WHERE (provider_id IS NOT NULL);


--
-- Name: idx_user_role; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_user_role ON public."user" USING btree (role);


--
-- Name: idx_user_tenant_role; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_user_tenant_role ON public."user" USING btree (tenant_id, role);


--
-- Name: idx_work_session_adj_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_work_session_adj_tenant ON public.work_session_adjustment USING btree (tenant_id, created_at);


--
-- Name: idx_work_session_break_session; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_work_session_break_session ON public.work_session_break USING btree (work_session_id);


--
-- Name: idx_work_session_break_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_work_session_break_tenant ON public.work_session_break USING btree (tenant_id, started_at);


--
-- Name: idx_work_session_tenant_started; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_work_session_tenant_started ON public.work_session USING btree (tenant_id, started_at);


--
-- Name: idx_work_session_user_started; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_work_session_user_started ON public.work_session USING btree (user_id, started_at);


--
-- Name: ix_billing_customer_company_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_billing_customer_company_name ON public.billing_customer USING btree (company_name);


--
-- Name: ix_billing_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_billing_customer_email ON public.billing_customer USING btree (email);


--
-- Name: ix_billing_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_billing_customer_name ON public.billing_customer USING btree (name);


--
-- Name: ix_billing_customer_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_billing_customer_tax_id ON public.billing_customer USING btree (tax_id);


--
-- Name: ix_billing_customer_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_billing_customer_tenant_id ON public.billing_customer USING btree (tenant_id);


--
-- Name: ix_branch_hub_fulfillment_branch_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_branch_hub_fulfillment_branch_tenant_id ON public.branch_hub_fulfillment USING btree (branch_tenant_id);


--
-- Name: ix_branch_hub_fulfillment_group_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_branch_hub_fulfillment_group_id ON public.branch_hub_fulfillment USING btree (group_id);


--
-- Name: ix_branch_hub_fulfillment_hub_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_branch_hub_fulfillment_hub_tenant_id ON public.branch_hub_fulfillment USING btree (hub_tenant_id);


--
-- Name: ix_branch_hub_fulfillment_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_branch_hub_fulfillment_order_id ON public.branch_hub_fulfillment USING btree (order_id);


--
-- Name: ix_branch_hub_fulfillment_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_branch_hub_fulfillment_status ON public.branch_hub_fulfillment USING btree (status);


--
-- Name: ix_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_customer_email ON public.customer USING btree (email);


--
-- Name: ix_customer_email_verification_token_hash; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_customer_email_verification_token_hash ON public.customer USING btree (email_verification_token_hash);


--
-- Name: ix_delivery_catalog_mapping_integration_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_catalog_mapping_integration_id ON public.delivery_catalog_mapping USING btree (integration_id);


--
-- Name: ix_delivery_catalog_mapping_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_catalog_mapping_tenant ON public.delivery_catalog_mapping USING btree (tenant_id);


--
-- Name: ix_delivery_catalog_mapping_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_catalog_mapping_tenant_id ON public.delivery_catalog_mapping USING btree (tenant_id);


--
-- Name: ix_delivery_event_log_tenant_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_event_log_tenant_created ON public.delivery_integration_event_log USING btree (tenant_id, created_at DESC);


--
-- Name: ix_delivery_integration_event_log_integration_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_integration_event_log_integration_id ON public.delivery_integration_event_log USING btree (integration_id);


--
-- Name: ix_delivery_integration_event_log_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_integration_event_log_tenant_id ON public.delivery_integration_event_log USING btree (tenant_id);


--
-- Name: ix_delivery_integration_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_integration_tenant ON public.delivery_marketplace_integration USING btree (tenant_id);


--
-- Name: ix_delivery_marketplace_integration_provider_key; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_marketplace_integration_provider_key ON public.delivery_marketplace_integration USING btree (provider_key);


--
-- Name: ix_delivery_marketplace_integration_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_delivery_marketplace_integration_tenant_id ON public.delivery_marketplace_integration USING btree (tenant_id);


--
-- Name: ix_delivery_marketplace_integration_webhook_ingest_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_delivery_marketplace_integration_webhook_ingest_token ON public.delivery_marketplace_integration USING btree (webhook_ingest_token);


--
-- Name: ix_fiscal_invoice_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_fiscal_invoice_order_id ON public.fiscal_invoice USING btree (order_id);


--
-- Name: ix_fiscal_invoice_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_fiscal_invoice_tenant_id ON public.fiscal_invoice USING btree (tenant_id);


--
-- Name: ix_fiscal_invoice_tenant_issued_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_fiscal_invoice_tenant_issued_at ON public.fiscal_invoice USING btree (tenant_id, issued_at);


--
-- Name: ix_floor_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_floor_is_active ON public.floor USING btree (is_active);


--
-- Name: ix_guest_feedback_tenant_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_guest_feedback_tenant_created ON public.guest_feedback USING btree (tenant_id, created_at DESC);


--
-- Name: ix_i18ntext_entity_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_i18ntext_entity_id ON public.i18ntext USING btree (entity_id);


--
-- Name: ix_i18ntext_entity_type; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_i18ntext_entity_type ON public.i18ntext USING btree (entity_type);


--
-- Name: ix_i18ntext_field; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_i18ntext_field ON public.i18ntext USING btree (field);


--
-- Name: ix_i18ntext_lang; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_i18ntext_lang ON public.i18ntext USING btree (lang);


--
-- Name: ix_i18ntext_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_i18ntext_tenant_id ON public.i18ntext USING btree (tenant_id);


--
-- Name: ix_inventory_batch_inventory_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_batch_inventory_item_id ON public.inventory_batch USING btree (inventory_item_id);


--
-- Name: ix_inventory_batch_purchase_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_batch_purchase_order_id ON public.inventory_batch USING btree (purchase_order_id);


--
-- Name: ix_inventory_batch_warehouse_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_batch_warehouse_id ON public.inventory_batch USING btree (warehouse_id);


--
-- Name: ix_inventory_item_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_category ON public.inventory_item USING btree (category);


--
-- Name: ix_inventory_item_default_supplier_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_default_supplier_id ON public.inventory_item USING btree (default_supplier_id);


--
-- Name: ix_inventory_item_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_is_active ON public.inventory_item USING btree (is_active);


--
-- Name: ix_inventory_item_is_deleted; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_is_deleted ON public.inventory_item USING btree (is_deleted);


--
-- Name: ix_inventory_item_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_name ON public.inventory_item USING btree (name);


--
-- Name: ix_inventory_item_sku; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_item_sku ON public.inventory_item USING btree (sku);


--
-- Name: ix_inventory_transaction_batch_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_batch_id ON public.inventory_transaction USING btree (batch_id);


--
-- Name: ix_inventory_transaction_inventory_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_inventory_item_id ON public.inventory_transaction USING btree (inventory_item_id);


--
-- Name: ix_inventory_transaction_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_order_id ON public.inventory_transaction USING btree (order_id);


--
-- Name: ix_inventory_transaction_purchase_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_purchase_order_id ON public.inventory_transaction USING btree (purchase_order_id);


--
-- Name: ix_inventory_transaction_transaction_type; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_transaction_type ON public.inventory_transaction USING btree (transaction_type);


--
-- Name: ix_inventory_transaction_warehouse_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_inventory_transaction_warehouse_id ON public.inventory_transaction USING btree (warehouse_id);


--
-- Name: ix_kitchen_station_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_kitchen_station_tenant_id ON public.kitchen_station USING btree (tenant_id);


--
-- Name: ix_kitchen_station_tenant_route; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_kitchen_station_tenant_route ON public.kitchen_station USING btree (tenant_id, display_route);


--
-- Name: ix_login_event_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_login_event_tenant_id ON public.login_event USING btree (tenant_id);


--
-- Name: ix_login_event_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_login_event_user_id ON public.login_event USING btree (user_id);


--
-- Name: ix_loyalty_apple_device_device_library_identifier; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_apple_device_device_library_identifier ON public.loyalty_apple_device USING btree (device_library_identifier);


--
-- Name: ix_loyalty_apple_device_library; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_apple_device_library ON public.loyalty_apple_device USING btree (device_library_identifier);


--
-- Name: ix_loyalty_apple_device_membership; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_apple_device_membership ON public.loyalty_apple_device USING btree (membership_id);


--
-- Name: ix_loyalty_apple_device_membership_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_apple_device_membership_id ON public.loyalty_apple_device USING btree (membership_id);


--
-- Name: ix_loyalty_ledger_entry_membership_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_ledger_entry_membership_id ON public.loyalty_ledger_entry USING btree (membership_id);


--
-- Name: ix_loyalty_ledger_entry_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_ledger_entry_order_id ON public.loyalty_ledger_entry USING btree (order_id);


--
-- Name: ix_loyalty_ledger_membership_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_ledger_membership_created ON public.loyalty_ledger_entry USING btree (membership_id, created_at DESC);


--
-- Name: ix_loyalty_ledger_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_ledger_order ON public.loyalty_ledger_entry USING btree (order_id);


--
-- Name: ix_loyalty_ledger_tenant_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_ledger_tenant_created ON public.loyalty_ledger_entry USING btree (tenant_id, created_at DESC);


--
-- Name: ix_loyalty_membership_apple_pass_serial; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_apple_pass_serial ON public.loyalty_membership USING btree (apple_pass_serial);


--
-- Name: ix_loyalty_membership_billing; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_billing ON public.loyalty_membership USING btree (billing_customer_id);


--
-- Name: ix_loyalty_membership_billing_customer_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_billing_customer_id ON public.loyalty_membership USING btree (billing_customer_id);


--
-- Name: ix_loyalty_membership_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_email ON public.loyalty_membership USING btree (email);


--
-- Name: ix_loyalty_membership_member_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_loyalty_membership_member_token ON public.loyalty_membership USING btree (member_token);


--
-- Name: ix_loyalty_membership_phone; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_phone ON public.loyalty_membership USING btree (phone);


--
-- Name: ix_loyalty_membership_program; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_program ON public.loyalty_membership USING btree (program_id);


--
-- Name: ix_loyalty_membership_program_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_program_id ON public.loyalty_membership USING btree (program_id);


--
-- Name: ix_loyalty_membership_referral_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_loyalty_membership_referral_code ON public.loyalty_membership USING btree (referral_code);


--
-- Name: ix_loyalty_membership_referred_by; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_referred_by ON public.loyalty_membership USING btree (referred_by_membership_id);


--
-- Name: ix_loyalty_membership_referred_by_membership_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_referred_by_membership_id ON public.loyalty_membership USING btree (referred_by_membership_id);


--
-- Name: ix_loyalty_membership_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_membership_tenant ON public.loyalty_membership USING btree (tenant_id);


--
-- Name: ix_loyalty_program_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_loyalty_program_tenant ON public.loyalty_program USING btree (tenant_id);


--
-- Name: ix_offline_order_idempotency_idempotency_key; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_offline_order_idempotency_idempotency_key ON public.offline_order_idempotency USING btree (idempotency_key);


--
-- Name: ix_offline_order_idempotency_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_offline_order_idempotency_order_id ON public.offline_order_idempotency USING btree (order_id);


--
-- Name: ix_offline_order_idempotency_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_offline_order_idempotency_tenant_id ON public.offline_order_idempotency USING btree (tenant_id);


--
-- Name: ix_ohbs_tenant_eff; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_ohbs_tenant_eff ON public.opening_hours_baseline_schedule USING btree (tenant_id, effective_from DESC);


--
-- Name: ix_ohdo_tenant_range; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_ohdo_tenant_range ON public.opening_hours_date_override USING btree (tenant_id, date_from, date_to);


--
-- Name: ix_opening_hours_baseline_schedule_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_opening_hours_baseline_schedule_tenant_id ON public.opening_hours_baseline_schedule USING btree (tenant_id);


--
-- Name: ix_opening_hours_date_override_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_opening_hours_date_override_tenant_id ON public.opening_hours_date_override USING btree (tenant_id);


--
-- Name: ix_order_billing_customer_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_billing_customer_id ON public."order" USING btree (billing_customer_id);


--
-- Name: ix_order_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_channel ON public."order" USING btree (tenant_id, order_channel) WHERE (deleted_at IS NULL);


--
-- Name: ix_order_courier_user; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_courier_user ON public."order" USING btree (courier_user_id) WHERE (courier_user_id IS NOT NULL);


--
-- Name: ix_order_courier_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_courier_user_id ON public."order" USING btree (courier_user_id);


--
-- Name: ix_order_customer_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_customer_id ON public."order" USING btree (customer_id);


--
-- Name: ix_order_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_customer_name ON public."order" USING btree (customer_name);


--
-- Name: ix_order_deleted_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_deleted_at ON public."order" USING btree (deleted_at);


--
-- Name: ix_order_delivery_integration; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_delivery_integration ON public."order" USING btree (delivery_integration_id) WHERE (delivery_integration_id IS NOT NULL);


--
-- Name: ix_order_delivery_integration_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_delivery_integration_id ON public."order" USING btree (delivery_integration_id);


--
-- Name: ix_order_external_order_ref; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_external_order_ref ON public."order" USING btree (external_order_ref);


--
-- Name: ix_order_loyalty_membership; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_loyalty_membership ON public."order" USING btree (loyalty_membership_id);


--
-- Name: ix_order_loyalty_membership_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_loyalty_membership_id ON public."order" USING btree (loyalty_membership_id);


--
-- Name: ix_order_order_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_order_channel ON public."order" USING btree (order_channel);


--
-- Name: ix_order_payment_item_order_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_item_order_item ON public.order_payment_item USING btree (order_item_id);


--
-- Name: ix_order_payment_item_order_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_item_order_item_id ON public.order_payment_item USING btree (order_item_id);


--
-- Name: ix_order_payment_item_order_payment_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_item_order_payment_id ON public.order_payment_item USING btree (order_payment_id);


--
-- Name: ix_order_payment_item_payment; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_item_payment ON public.order_payment_item USING btree (order_payment_id);


--
-- Name: ix_order_payment_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_order ON public.order_payment USING btree (order_id);


--
-- Name: ix_order_payment_order_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_order_active ON public.order_payment USING btree (order_id) WHERE (voided_at IS NULL);


--
-- Name: ix_order_payment_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_order_id ON public.order_payment USING btree (order_id);


--
-- Name: ix_order_payment_tenant_paid; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_payment_tenant_paid ON public.order_payment USING btree (tenant_id, paid_at DESC);


--
-- Name: ix_order_session_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_session_id ON public."order" USING btree (session_id);


--
-- Name: ix_order_staff_urgent; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_staff_urgent ON public."order" USING btree (staff_urgent);


--
-- Name: ix_order_tip_attributed_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_tip_attributed_user_id ON public."order" USING btree (tip_attributed_user_id);


--
-- Name: ix_orderitem_promo; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_orderitem_promo ON public.orderitem USING btree (promo_id);


--
-- Name: ix_orderitem_promo_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_orderitem_promo_id ON public.orderitem USING btree (promo_id);


--
-- Name: ix_orderitem_removed_by_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_orderitem_removed_by_customer ON public.orderitem USING btree (removed_by_customer);


--
-- Name: ix_orderitem_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_orderitem_status ON public.orderitem USING btree (status);


--
-- Name: ix_orderitem_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_orderitem_tax_id ON public.orderitem USING btree (tax_id);


--
-- Name: ix_password_reset_token_token_hash; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_password_reset_token_token_hash ON public.password_reset_token USING btree (token_hash);


--
-- Name: ix_password_reset_token_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_password_reset_token_user_id ON public.password_reset_token USING btree (user_id);


--
-- Name: ix_price_promotion_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_price_promotion_tenant ON public.price_promotion USING btree (tenant_id);


--
-- Name: ix_price_promotion_tenant_enabled; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_price_promotion_tenant_enabled ON public.price_promotion USING btree (tenant_id, enabled);


--
-- Name: ix_print_agent_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_agent_tenant ON public.print_agent USING btree (tenant_id);


--
-- Name: ix_print_agent_tenant_last_seen; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_agent_tenant_last_seen ON public.print_agent USING btree (tenant_id, last_seen_at DESC);


--
-- Name: ix_print_agent_token_hash; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_agent_token_hash ON public.print_agent USING btree (token_hash);


--
-- Name: ix_print_job_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_job_order_id ON public.print_job USING btree (order_id);


--
-- Name: ix_print_job_pending; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_job_pending ON public.print_job USING btree (tenant_id, status, created_at) WHERE ((status)::text = 'pending'::text);


--
-- Name: ix_print_job_tenant_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_job_tenant_created ON public.print_job USING btree (tenant_id, created_at DESC);


--
-- Name: ix_print_job_tenant_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_print_job_tenant_status ON public.print_job USING btree (tenant_id, status);


--
-- Name: ix_product_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_category ON public.product USING btree (category);


--
-- Name: ix_product_kitchen_station_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_kitchen_station_id ON public.product USING btree (kitchen_station_id);


--
-- Name: ix_product_question_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_question_product_id ON public.product_question USING btree (product_id);


--
-- Name: ix_product_question_type; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_question_type ON public.product_question USING btree (type);


--
-- Name: ix_product_recipe_inventory_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_recipe_inventory_item_id ON public.product_recipe USING btree (inventory_item_id);


--
-- Name: ix_product_recipe_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_recipe_product_id ON public.product_recipe USING btree (product_id);


--
-- Name: ix_product_subcategory; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_subcategory ON public.product USING btree (subcategory);


--
-- Name: ix_product_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_tax_id ON public.product USING btree (tax_id);


--
-- Name: ix_productcatalog_barcode; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_productcatalog_barcode ON public.productcatalog USING btree (barcode);


--
-- Name: ix_productcatalog_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_productcatalog_category ON public.productcatalog USING btree (category);


--
-- Name: ix_productcatalog_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_productcatalog_name ON public.productcatalog USING btree (name);


--
-- Name: ix_productcatalog_normalized_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_productcatalog_normalized_name ON public.productcatalog USING btree (normalized_name);


--
-- Name: ix_productcatalog_subcategory; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_productcatalog_subcategory ON public.productcatalog USING btree (subcategory);


--
-- Name: ix_provider_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_provider_is_active ON public.provider USING btree (is_active);


--
-- Name: ix_provider_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_provider_name ON public.provider USING btree (name);


--
-- Name: ix_provider_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_provider_tenant_id ON public.provider USING btree (tenant_id);


--
-- Name: ix_provider_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_provider_token ON public.provider USING btree (token);


--
-- Name: ix_providerproduct_availability; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_providerproduct_availability ON public.providerproduct USING btree (availability);


--
-- Name: ix_providerproduct_catalog_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_providerproduct_catalog_id ON public.providerproduct USING btree (catalog_id);


--
-- Name: ix_providerproduct_external_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_providerproduct_external_id ON public.providerproduct USING btree (external_id);


--
-- Name: ix_providerproduct_provider_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_providerproduct_provider_id ON public.providerproduct USING btree (provider_id);


--
-- Name: ix_purchase_order_item_inventory_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_purchase_order_item_inventory_item_id ON public.purchase_order_item USING btree (inventory_item_id);


--
-- Name: ix_purchase_order_item_purchase_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_purchase_order_item_purchase_order_id ON public.purchase_order_item USING btree (purchase_order_id);


--
-- Name: ix_purchase_order_order_number; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_purchase_order_order_number ON public.purchase_order USING btree (order_number);


--
-- Name: ix_purchase_order_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_purchase_order_status ON public.purchase_order USING btree (status);


--
-- Name: ix_purchase_order_supplier_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_purchase_order_supplier_id ON public.purchase_order USING btree (supplier_id);


--
-- Name: ix_reservation_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_reservation_customer_email ON public.reservation USING btree (customer_email);


--
-- Name: ix_reservation_preferred_floor_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_reservation_preferred_floor_id ON public.reservation USING btree (preferred_floor_id);


--
-- Name: ix_reservation_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_reservation_status ON public.reservation USING btree (status);


--
-- Name: ix_reservation_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_reservation_token ON public.reservation USING btree (token);


--
-- Name: ix_restaurant_group_hub_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_restaurant_group_hub_tenant_id ON public.restaurant_group USING btree (hub_tenant_id);


--
-- Name: ix_restaurant_group_join_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_restaurant_group_join_code ON public.restaurant_group USING btree (join_code);


--
-- Name: ix_restaurant_group_member_group_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_restaurant_group_member_group_id ON public.restaurant_group_member USING btree (group_id);


--
-- Name: ix_restaurant_group_member_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_restaurant_group_member_tenant_id ON public.restaurant_group_member USING btree (tenant_id);


--
-- Name: ix_social_connection_provider_key; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_connection_provider_key ON public.social_connection USING btree (provider_key);


--
-- Name: ix_social_connection_tenant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_connection_tenant ON public.social_connection USING btree (tenant_id);


--
-- Name: ix_social_connection_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_connection_tenant_id ON public.social_connection USING btree (tenant_id);


--
-- Name: ix_social_oauth_state_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_oauth_state_created ON public.social_oauth_state USING btree (created_at);


--
-- Name: ix_social_oauth_state_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_oauth_state_tenant_id ON public.social_oauth_state USING btree (tenant_id);


--
-- Name: ix_social_oauth_state_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_oauth_state_user_id ON public.social_oauth_state USING btree (user_id);


--
-- Name: ix_social_post_status_schedule; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_post_status_schedule ON public.social_post USING btree (status, schedule_at);


--
-- Name: ix_social_post_target_post; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_post_target_post ON public.social_post_target USING btree (social_post_id);


--
-- Name: ix_social_post_target_social_post_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_post_target_social_post_id ON public.social_post_target USING btree (social_post_id);


--
-- Name: ix_social_post_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_post_tenant_id ON public.social_post USING btree (tenant_id);


--
-- Name: ix_social_post_tenant_schedule; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_social_post_tenant_schedule ON public.social_post USING btree (tenant_id, schedule_at);


--
-- Name: ix_staff_contract_contract_group_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_contract_group_id ON public.staff_contract USING btree (contract_group_id);


--
-- Name: ix_staff_contract_subject_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_subject_user_id ON public.staff_contract USING btree (subject_user_id);


--
-- Name: ix_staff_contract_template_preset_locale; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_template_preset_locale ON public.staff_contract_template_preset USING btree (locale);


--
-- Name: ix_staff_contract_template_preset_region; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_template_preset_region ON public.staff_contract_template_preset USING btree (region_code);


--
-- Name: ix_staff_contract_template_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_template_tenant_id ON public.staff_contract_template USING btree (tenant_id);


--
-- Name: ix_staff_contract_tenant_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_tenant_group ON public.staff_contract USING btree (tenant_id, contract_group_id);


--
-- Name: ix_staff_contract_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_staff_contract_tenant_id ON public.staff_contract USING btree (tenant_id);


--
-- Name: ix_supplier_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_supplier_code ON public.supplier USING btree (code);


--
-- Name: ix_supplier_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_supplier_is_active ON public.supplier USING btree (is_active);


--
-- Name: ix_supplier_is_deleted; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_supplier_is_deleted ON public.supplier USING btree (is_deleted);


--
-- Name: ix_supplier_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_supplier_name ON public.supplier USING btree (name);


--
-- Name: ix_table_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_is_active ON public."table" USING btree (is_active);


--
-- Name: ix_table_table_group_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_table_group_id ON public."table" USING btree (table_group_id);


--
-- Name: ix_table_token; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_table_token ON public."table" USING btree (token);


--
-- Name: ix_tax_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tax_tenant_id ON public.tax USING btree (tenant_id);


--
-- Name: ix_tenant_default_bar_station_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenant_default_bar_station_id ON public.tenant USING btree (default_bar_station_id);


--
-- Name: ix_tenant_default_kitchen_station_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenant_default_kitchen_station_id ON public.tenant USING btree (default_kitchen_station_id);


--
-- Name: ix_tenant_default_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenant_default_tax_id ON public.tenant USING btree (default_tax_id);


--
-- Name: ix_tenant_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenant_name ON public.tenant USING btree (name);


--
-- Name: ix_tenantproduct_catalog_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_catalog_id ON public.tenantproduct USING btree (catalog_id);


--
-- Name: ix_tenantproduct_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_is_active ON public.tenantproduct USING btree (is_active);


--
-- Name: ix_tenantproduct_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_product_id ON public.tenantproduct USING btree (product_id);


--
-- Name: ix_tenantproduct_provider_product_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_provider_product_id ON public.tenantproduct USING btree (provider_product_id);


--
-- Name: ix_tenantproduct_tax_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_tax_id ON public.tenantproduct USING btree (tax_id);


--
-- Name: ix_tenantproduct_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tenantproduct_tenant_id ON public.tenantproduct USING btree (tenant_id);


--
-- Name: ix_tse_transaction_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tse_transaction_order_id ON public.tse_transaction USING btree (order_id);


--
-- Name: ix_tse_transaction_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tse_transaction_tenant_id ON public.tse_transaction USING btree (tenant_id);


--
-- Name: ix_tse_transaction_tenant_time; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tse_transaction_tenant_time ON public.tse_transaction USING btree (tenant_id, time_start);


--
-- Name: ix_user_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ix_user_email ON public."user" USING btree (email);


--
-- Name: ix_user_provider_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_user_provider_id ON public."user" USING btree (provider_id);


--
-- Name: ix_waiting_list_entry_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_waiting_list_entry_status ON public.waiting_list_entry USING btree (status);


--
-- Name: ix_waiting_list_entry_tenant_status_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_waiting_list_entry_tenant_status_created ON public.waiting_list_entry USING btree (tenant_id, status, created_at);


--
-- Name: ix_warehouse_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_code ON public.warehouse USING btree (code);


--
-- Name: ix_warehouse_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_is_active ON public.warehouse USING btree (is_active);


--
-- Name: ix_warehouse_is_default; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_is_default ON public.warehouse USING btree (is_default);


--
-- Name: ix_warehouse_is_deleted; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_is_deleted ON public.warehouse USING btree (is_deleted);


--
-- Name: ix_warehouse_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_name ON public.warehouse USING btree (name);


--
-- Name: ix_warehouse_stock_inventory_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_stock_inventory_item_id ON public.warehouse_stock USING btree (inventory_item_id);


--
-- Name: ix_warehouse_stock_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_stock_item ON public.warehouse_stock USING btree (inventory_item_id);


--
-- Name: ix_warehouse_stock_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_stock_tenant_id ON public.warehouse_stock USING btree (tenant_id);


--
-- Name: ix_warehouse_stock_warehouse; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_stock_warehouse ON public.warehouse_stock USING btree (warehouse_id);


--
-- Name: ix_warehouse_stock_warehouse_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_stock_warehouse_id ON public.warehouse_stock USING btree (warehouse_id);


--
-- Name: ix_warehouse_tenant_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_tenant_active ON public.warehouse USING btree (tenant_id, is_active) WHERE (is_deleted = false);


--
-- Name: ix_warehouse_tenant_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_warehouse_tenant_id ON public.warehouse USING btree (tenant_id);


--
-- Name: ix_work_session_adjustment_actor_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_work_session_adjustment_actor_user_id ON public.work_session_adjustment USING btree (actor_user_id);


--
-- Name: ix_work_session_adjustment_work_session_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_work_session_adjustment_work_session_id ON public.work_session_adjustment USING btree (work_session_id);


--
-- Name: ix_work_session_break_work_session_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_work_session_break_work_session_id ON public.work_session_break USING btree (work_session_id);


--
-- Name: ix_work_session_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_work_session_user_id ON public.work_session USING btree (user_id);


--
-- Name: uq_customer_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_customer_email ON public.customer USING btree (email);


--
-- Name: uq_fiscal_invoice_tenant_order_alta; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_fiscal_invoice_tenant_order_alta ON public.fiscal_invoice USING btree (tenant_id, order_id) WHERE ((record_type)::text = 'alta'::text);


--
-- Name: uq_loyalty_ledger_earn_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_loyalty_ledger_earn_order ON public.loyalty_ledger_entry USING btree (order_id, entry_type) WHERE ((order_id IS NOT NULL) AND ((entry_type)::text = 'earn'::text));


--
-- Name: uq_loyalty_ledger_referral_reward_note; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_loyalty_ledger_referral_reward_note ON public.loyalty_ledger_entry USING btree (tenant_id, note) WHERE (((entry_type)::text = 'earn'::text) AND ((note)::text ~~ 'Referral reward for membership %'::text));


--
-- Name: uq_loyalty_membership_apple_pass_serial; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_loyalty_membership_apple_pass_serial ON public.loyalty_membership USING btree (apple_pass_serial) WHERE (apple_pass_serial IS NOT NULL);


--
-- Name: uq_loyalty_membership_referral_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_loyalty_membership_referral_code ON public.loyalty_membership USING btree (referral_code);


--
-- Name: uq_order_delivery_external; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_order_delivery_external ON public."order" USING btree (delivery_integration_id, external_order_ref) WHERE ((delivery_integration_id IS NOT NULL) AND (external_order_ref IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: uq_order_payment_item_active_line; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_order_payment_item_active_line ON public.order_payment_item USING btree (order_item_id);


--
-- Name: uq_staff_contract_group_version; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_staff_contract_group_version ON public.staff_contract USING btree (contract_group_id, version);


--
-- Name: uq_tse_transaction_tenant_order_sale; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_tse_transaction_tenant_order_sale ON public.tse_transaction USING btree (tenant_id, order_id) WHERE ((process_type)::text = 'sale'::text);


--
-- Name: uq_work_session_user_open; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_work_session_user_open ON public.work_session USING btree (user_id) WHERE (ended_at IS NULL);


--
-- Name: billing_customer billing_customer_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.billing_customer
    ADD CONSTRAINT billing_customer_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_branch_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_branch_tenant_id_fkey FOREIGN KEY (branch_tenant_id) REFERENCES public.tenant(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public."user"(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.restaurant_group(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_hub_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_hub_tenant_id_fkey FOREIGN KEY (hub_tenant_id) REFERENCES public.tenant(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: branch_hub_fulfillment branch_hub_fulfillment_prepared_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.branch_hub_fulfillment
    ADD CONSTRAINT branch_hub_fulfillment_prepared_by_user_id_fkey FOREIGN KEY (prepared_by_user_id) REFERENCES public."user"(id);


--
-- Name: delivery_catalog_mapping delivery_catalog_mapping_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_catalog_mapping
    ADD CONSTRAINT delivery_catalog_mapping_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.delivery_marketplace_integration(id);


--
-- Name: delivery_catalog_mapping delivery_catalog_mapping_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_catalog_mapping
    ADD CONSTRAINT delivery_catalog_mapping_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: delivery_catalog_mapping delivery_catalog_mapping_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_catalog_mapping
    ADD CONSTRAINT delivery_catalog_mapping_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: delivery_integration_event_log delivery_integration_event_log_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_integration_event_log
    ADD CONSTRAINT delivery_integration_event_log_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.delivery_marketplace_integration(id);


--
-- Name: delivery_integration_event_log delivery_integration_event_log_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_integration_event_log
    ADD CONSTRAINT delivery_integration_event_log_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: delivery_marketplace_integration delivery_marketplace_integration_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.delivery_marketplace_integration
    ADD CONSTRAINT delivery_marketplace_integration_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: fiscal_invoice fiscal_invoice_cancels_fiscal_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.fiscal_invoice
    ADD CONSTRAINT fiscal_invoice_cancels_fiscal_invoice_id_fkey FOREIGN KEY (cancels_fiscal_invoice_id) REFERENCES public.fiscal_invoice(id);


--
-- Name: fiscal_invoice fiscal_invoice_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.fiscal_invoice
    ADD CONSTRAINT fiscal_invoice_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: fiscal_invoice fiscal_invoice_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.fiscal_invoice
    ADD CONSTRAINT fiscal_invoice_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: table fk_table_active_order; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT fk_table_active_order FOREIGN KEY (active_order_id) REFERENCES public."order"(id) ON DELETE SET NULL;


--
-- Name: floor floor_default_waiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.floor
    ADD CONSTRAINT floor_default_waiter_id_fkey FOREIGN KEY (default_waiter_id) REFERENCES public."user"(id);


--
-- Name: floor floor_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.floor
    ADD CONSTRAINT floor_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: guest_feedback guest_feedback_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.guest_feedback
    ADD CONSTRAINT guest_feedback_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.reservation(id);


--
-- Name: guest_feedback guest_feedback_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.guest_feedback
    ADD CONSTRAINT guest_feedback_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: i18n_text i18n_text_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18n_text
    ADD CONSTRAINT i18n_text_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE CASCADE;


--
-- Name: i18ntext i18ntext_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.i18ntext
    ADD CONSTRAINT i18ntext_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: inventory_batch inventory_batch_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch
    ADD CONSTRAINT inventory_batch_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id);


--
-- Name: inventory_batch inventory_batch_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch
    ADD CONSTRAINT inventory_batch_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_order(id);


--
-- Name: inventory_batch inventory_batch_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch
    ADD CONSTRAINT inventory_batch_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: inventory_batch inventory_batch_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_batch
    ADD CONSTRAINT inventory_batch_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouse(id);


--
-- Name: inventory_item inventory_item_default_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_default_supplier_id_fkey FOREIGN KEY (default_supplier_id) REFERENCES public.supplier(id);


--
-- Name: inventory_item inventory_item_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: inventory_transaction inventory_transaction_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.inventory_batch(id);


--
-- Name: inventory_transaction inventory_transaction_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public."user"(id);


--
-- Name: inventory_transaction inventory_transaction_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id);


--
-- Name: inventory_transaction inventory_transaction_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: inventory_transaction inventory_transaction_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_order(id);


--
-- Name: inventory_transaction inventory_transaction_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: inventory_transaction inventory_transaction_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_transaction
    ADD CONSTRAINT inventory_transaction_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouse(id);


--
-- Name: kitchen_station kitchen_station_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kitchen_station
    ADD CONSTRAINT kitchen_station_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: login_event login_event_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.login_event
    ADD CONSTRAINT login_event_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.provider(id);


--
-- Name: login_event login_event_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.login_event
    ADD CONSTRAINT login_event_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: login_event login_event_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.login_event
    ADD CONSTRAINT login_event_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: loyalty_apple_device loyalty_apple_device_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_apple_device
    ADD CONSTRAINT loyalty_apple_device_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.loyalty_membership(id);


--
-- Name: loyalty_ledger_entry loyalty_ledger_entry_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry
    ADD CONSTRAINT loyalty_ledger_entry_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public."user"(id);


--
-- Name: loyalty_ledger_entry loyalty_ledger_entry_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry
    ADD CONSTRAINT loyalty_ledger_entry_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.loyalty_membership(id);


--
-- Name: loyalty_ledger_entry loyalty_ledger_entry_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry
    ADD CONSTRAINT loyalty_ledger_entry_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: loyalty_ledger_entry loyalty_ledger_entry_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_ledger_entry
    ADD CONSTRAINT loyalty_ledger_entry_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: loyalty_membership loyalty_membership_billing_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership
    ADD CONSTRAINT loyalty_membership_billing_customer_id_fkey FOREIGN KEY (billing_customer_id) REFERENCES public.billing_customer(id);


--
-- Name: loyalty_membership loyalty_membership_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership
    ADD CONSTRAINT loyalty_membership_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.loyalty_program(id);


--
-- Name: loyalty_membership loyalty_membership_referred_by_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership
    ADD CONSTRAINT loyalty_membership_referred_by_membership_id_fkey FOREIGN KEY (referred_by_membership_id) REFERENCES public.loyalty_membership(id);


--
-- Name: loyalty_membership loyalty_membership_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_membership
    ADD CONSTRAINT loyalty_membership_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: loyalty_program loyalty_program_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT loyalty_program_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: offline_order_idempotency offline_order_idempotency_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.offline_order_idempotency
    ADD CONSTRAINT offline_order_idempotency_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: offline_order_idempotency offline_order_idempotency_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.offline_order_idempotency
    ADD CONSTRAINT offline_order_idempotency_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: opening_hours_baseline_schedule opening_hours_baseline_schedule_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_baseline_schedule
    ADD CONSTRAINT opening_hours_baseline_schedule_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: opening_hours_date_override opening_hours_date_override_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.opening_hours_date_override
    ADD CONSTRAINT opening_hours_date_override_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: order order_billing_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_customer_id_fkey FOREIGN KEY (billing_customer_id) REFERENCES public.billing_customer(id);


--
-- Name: order order_courier_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_courier_user_id_fkey FOREIGN KEY (courier_user_id) REFERENCES public."user"(id);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: order order_deleted_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_deleted_by_user_id_fkey FOREIGN KEY (deleted_by_user_id) REFERENCES public."user"(id);


--
-- Name: order order_delivery_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_delivery_integration_id_fkey FOREIGN KEY (delivery_integration_id) REFERENCES public.delivery_marketplace_integration(id);


--
-- Name: order order_loyalty_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_loyalty_membership_id_fkey FOREIGN KEY (loyalty_membership_id) REFERENCES public.loyalty_membership(id);


--
-- Name: order_payment_item order_payment_item_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment_item
    ADD CONSTRAINT order_payment_item_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.orderitem(id);


--
-- Name: order_payment_item order_payment_item_order_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment_item
    ADD CONSTRAINT order_payment_item_order_payment_id_fkey FOREIGN KEY (order_payment_id) REFERENCES public.order_payment(id);


--
-- Name: order_payment_item order_payment_item_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment_item
    ADD CONSTRAINT order_payment_item_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: order_payment order_payment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order_payment order_payment_paid_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_paid_by_user_id_fkey FOREIGN KEY (paid_by_user_id) REFERENCES public."user"(id);


--
-- Name: order_payment order_payment_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: order order_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_table_id_fkey FOREIGN KEY (table_id) REFERENCES public."table"(id);


--
-- Name: order order_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: order order_tip_attributed_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_tip_attributed_user_id_fkey FOREIGN KEY (tip_attributed_user_id) REFERENCES public."user"(id);


--
-- Name: orderitem orderitem_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: orderitem orderitem_promo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_promo_id_fkey FOREIGN KEY (promo_id) REFERENCES public.price_promotion(id);


--
-- Name: orderitem orderitem_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.tax(id);


--
-- Name: password_reset_token password_reset_token_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.password_reset_token
    ADD CONSTRAINT password_reset_token_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: price_promotion price_promotion_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.price_promotion
    ADD CONSTRAINT price_promotion_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: print_agent print_agent_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_agent
    ADD CONSTRAINT print_agent_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: print_job print_job_claimed_by_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job
    ADD CONSTRAINT print_job_claimed_by_agent_id_fkey FOREIGN KEY (claimed_by_agent_id) REFERENCES public.print_agent(id);


--
-- Name: print_job print_job_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job
    ADD CONSTRAINT print_job_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public."user"(id);


--
-- Name: print_job print_job_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job
    ADD CONSTRAINT print_job_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: print_job print_job_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.print_job
    ADD CONSTRAINT print_job_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: product product_kitchen_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_kitchen_station_id_fkey FOREIGN KEY (kitchen_station_id) REFERENCES public.kitchen_station(id);


--
-- Name: product_question product_question_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_question
    ADD CONSTRAINT product_question_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: product_question product_question_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_question
    ADD CONSTRAINT product_question_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: product_recipe product_recipe_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_recipe
    ADD CONSTRAINT product_recipe_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id);


--
-- Name: product_recipe product_recipe_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_recipe
    ADD CONSTRAINT product_recipe_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: product_recipe product_recipe_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_recipe
    ADD CONSTRAINT product_recipe_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: product product_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.tax(id);


--
-- Name: product product_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: provider provider_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.provider
    ADD CONSTRAINT provider_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: providerproduct providerproduct_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.providerproduct
    ADD CONSTRAINT providerproduct_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.productcatalog(id);


--
-- Name: providerproduct providerproduct_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.providerproduct
    ADD CONSTRAINT providerproduct_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.provider(id);


--
-- Name: purchase_order purchase_order_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public."user"(id);


--
-- Name: purchase_order_item purchase_order_item_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_item
    ADD CONSTRAINT purchase_order_item_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id);


--
-- Name: purchase_order_item purchase_order_item_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_item
    ADD CONSTRAINT purchase_order_item_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_order(id);


--
-- Name: purchase_order purchase_order_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: purchase_order purchase_order_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: reservation reservation_preferred_floor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_preferred_floor_id_fkey FOREIGN KEY (preferred_floor_id) REFERENCES public.floor(id);


--
-- Name: reservation reservation_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_table_id_fkey FOREIGN KEY (table_id) REFERENCES public."table"(id);


--
-- Name: reservation reservation_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: restaurant_group restaurant_group_hub_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group
    ADD CONSTRAINT restaurant_group_hub_tenant_id_fkey FOREIGN KEY (hub_tenant_id) REFERENCES public.tenant(id);


--
-- Name: restaurant_group_member restaurant_group_member_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group_member
    ADD CONSTRAINT restaurant_group_member_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.restaurant_group(id);


--
-- Name: restaurant_group_member restaurant_group_member_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_group_member
    ADD CONSTRAINT restaurant_group_member_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: shift shift_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: shift shift_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: social_connection social_connection_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_connection
    ADD CONSTRAINT social_connection_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: social_oauth_state social_oauth_state_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_oauth_state
    ADD CONSTRAINT social_oauth_state_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: social_oauth_state social_oauth_state_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_oauth_state
    ADD CONSTRAINT social_oauth_state_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: social_post social_post_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post
    ADD CONSTRAINT social_post_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public."user"(id);


--
-- Name: social_post_target social_post_target_social_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post_target
    ADD CONSTRAINT social_post_target_social_post_id_fkey FOREIGN KEY (social_post_id) REFERENCES public.social_post(id);


--
-- Name: social_post social_post_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.social_post
    ADD CONSTRAINT social_post_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: staff_contract staff_contract_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract
    ADD CONSTRAINT staff_contract_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public."user"(id);


--
-- Name: staff_contract staff_contract_subject_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract
    ADD CONSTRAINT staff_contract_subject_user_id_fkey FOREIGN KEY (subject_user_id) REFERENCES public."user"(id);


--
-- Name: staff_contract_template staff_contract_template_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract_template
    ADD CONSTRAINT staff_contract_template_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: staff_contract staff_contract_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.staff_contract
    ADD CONSTRAINT staff_contract_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: supplier supplier_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: table table_assigned_waiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_assigned_waiter_id_fkey FOREIGN KEY (assigned_waiter_id) REFERENCES public."user"(id);


--
-- Name: table table_floor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_floor_id_fkey FOREIGN KEY (floor_id) REFERENCES public.floor(id);


--
-- Name: table_group table_group_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_group
    ADD CONSTRAINT table_group_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: table table_table_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_table_group_id_fkey FOREIGN KEY (table_group_id) REFERENCES public.table_group(id);


--
-- Name: table table_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: tax tax_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax
    ADD CONSTRAINT tax_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: tenant tenant_default_bar_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_default_bar_station_id_fkey FOREIGN KEY (default_bar_station_id) REFERENCES public.kitchen_station(id);


--
-- Name: tenant tenant_default_kitchen_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_default_kitchen_station_id_fkey FOREIGN KEY (default_kitchen_station_id) REFERENCES public.kitchen_station(id);


--
-- Name: tenant tenant_default_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_default_tax_id_fkey FOREIGN KEY (default_tax_id) REFERENCES public.tax(id);


--
-- Name: tenantproduct tenantproduct_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.productcatalog(id);


--
-- Name: tenantproduct tenantproduct_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: tenantproduct tenantproduct_provider_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_provider_product_id_fkey FOREIGN KEY (provider_product_id) REFERENCES public.providerproduct(id);


--
-- Name: tenantproduct tenantproduct_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.tax(id);


--
-- Name: tenantproduct tenantproduct_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tenantproduct
    ADD CONSTRAINT tenantproduct_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: tse_transaction tse_transaction_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tse_transaction
    ADD CONSTRAINT tse_transaction_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: tse_transaction tse_transaction_storno_of_tse_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tse_transaction
    ADD CONSTRAINT tse_transaction_storno_of_tse_transaction_id_fkey FOREIGN KEY (storno_of_tse_transaction_id) REFERENCES public.tse_transaction(id);


--
-- Name: tse_transaction tse_transaction_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tse_transaction
    ADD CONSTRAINT tse_transaction_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: user user_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.provider(id);


--
-- Name: user user_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: waiting_list_entry waiting_list_entry_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.waiting_list_entry
    ADD CONSTRAINT waiting_list_entry_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: warehouse_stock warehouse_stock_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id);


--
-- Name: warehouse_stock warehouse_stock_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: warehouse_stock warehouse_stock_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouse(id);


--
-- Name: warehouse warehouse_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: work_session_adjustment work_session_adjustment_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_adjustment
    ADD CONSTRAINT work_session_adjustment_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES public."user"(id);


--
-- Name: work_session_adjustment work_session_adjustment_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_adjustment
    ADD CONSTRAINT work_session_adjustment_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: work_session_adjustment work_session_adjustment_work_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_adjustment
    ADD CONSTRAINT work_session_adjustment_work_session_id_fkey FOREIGN KEY (work_session_id) REFERENCES public.work_session(id);


--
-- Name: work_session_break work_session_break_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_break
    ADD CONSTRAINT work_session_break_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: work_session_break work_session_break_work_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session_break
    ADD CONSTRAINT work_session_break_work_session_id_fkey FOREIGN KEY (work_session_id) REFERENCES public.work_session(id);


--
-- Name: work_session work_session_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session
    ADD CONSTRAINT work_session_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: work_session work_session_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.work_session
    ADD CONSTRAINT work_session_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vDMXUpsO76VQwGCbM9c3YX9L6ja2ycr4zxIzQBrYspCpnrd9XRHQhiL6AmxMWqc

