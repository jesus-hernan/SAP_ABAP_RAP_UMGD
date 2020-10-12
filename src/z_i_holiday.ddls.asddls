@AbapCatalog.sqlViewName: 'ZV_HOLIDAY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Holiday'
@UI: {
    headerInfo: {
      typeName: 'Holiday',
typeNamePlural: 'Holidays',
         title: {
          type: #STANDARD,
         value: 'holiday_id'} } }
define root view Z_I_HOLIDAY
  as select from zcal_holiday_000
  composition [0..*] of Z_HOLIDAY_TEXT as _HolidayTxt
{

      @UI.facet: [
          {
            id: 'PublicHoliday',
            label: 'Public Holiday',
            type: #COLLECTION,
            position: 1
          },
          {
            id: 'General',
            parentId: 'PublicHoliday',
            label: 'General Data',
            type: #FIELDGROUP_REFERENCE,
            targetQualifier: 'General',
            position: 1
          },
          {
        id: 'Translation',
        label: 'Translation',
        type: #LINEITEM_REFERENCE,
        position: 3,
        targetElement: '_HolidayTxt'
          }]
      @UI.fieldGroup: [ { qualifier: 'General', position: 1 } ]
      @UI.lineItem:   [ { position: 1 } ]
  key holiday_id,
      @UI.fieldGroup: [ { qualifier: 'General', position: 2 } ]
      @UI.lineItem:   [ { position: 2 } ]
      month_of_holiday,
      @UI.fieldGroup: [ { qualifier: 'General', position: 3 } ]
      @UI.lineItem:   [ { position: 3 } ]
      day_of_holiday,
      changedat,
      //      configprecationcode,
      _HolidayTxt
}
