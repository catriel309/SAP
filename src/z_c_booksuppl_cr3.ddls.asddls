@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption - Booking Supplement'
@Metadata.allowExtensions: true

define view entity Z_C_BOOKSUPPL_CR3
  as projection on Z_I_BOOKSUPPL_CR3

{
  key travel_id                   as TravelId,
  key booking_id                  as BookingId,
  key booking_supplement_id       as BookingSupplementId,
      supplement_id               as SupplementId,
      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      price                       as Price,
      @Semantics.currencyCode: true
      currency                    as CurrencyCode,
      last_changed_at             as LastChangedAt,
      /* Associations */
      _Travel  : redirected to Z_C_TRAVEL_CR3,
      _Booking : redirected to parent Z_C_BOOKING_CR3,
      _Product,
      _SupplementText

}
