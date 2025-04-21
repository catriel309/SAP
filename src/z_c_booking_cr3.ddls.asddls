@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption - Booking'
@Metadata.allowExtensions: true

define view entity Z_C_BOOKING_CR3
  as projection on Z_I_BOOKING_CR3
{
  key travel_id      as TravelId,
  key booking_id     as BookingId,

      booking_date   as BookingDate,
      customer_id    as CustomerId,
      @ObjectModel.text.element: ['CarrierName']
      carrier_id     as CarrierId,
      _Carrier.Name  as CarrierName,
      connection_id  as ConnectionId,
      flight_date    as FlightDate,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      flight_price   as FlightPrice,
      @Semantics.currencyCode: true
      currency_code  as CurrencyCode,
      booking_status as BookingStatus,
      last_change_at as LastChangedAt,
      /* Associations */
      _Travel            : redirected to parent Z_C_TRAVEL_CR3,
      _BookingSupplement : redirected to composition child Z_C_BOOKSUPPL_CR3,
      _Carrier,
      _Connection,
      _Customer

}
