@AbapCatalog.sqlViewName: 'ZVBOOK_CR3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface - Booking'

define view Z_I_BOOKING_CR3 
    as select from ztb_booking_mb3 as Booking

composition [0..*] of Z_I_BOOKSUPPL_CR3 as _BookingSupplement

association to parent Z_I_TRAVEL_CR3 as _Travel 
    on $projection.travel_id = _Travel.travel_id
    
association [1..1] to /DMO/I_Customer as _Customer on $projection.customer_id = _Customer.CustomerID
association [1..1] to /DMO/I_Carrier as _Carrier on $projection.carrier_id = _Carrier.AirlineID
association [1..*] to /DMO/I_Connection as _Connection on $projection.connection_id = _Connection.ConnectionID   
    
    
{
    key travel_id,
    key booking_id,
    booking_date,
    customer_id,
    carrier_id,
    connection_id,
    flight_date,
    flight_price,
    currency_code,
    booking_status,
    last_change_at,
    
    _Travel,
    _BookingSupplement,
    _Customer,
    _Carrier,
    _Connection
    
    
}
