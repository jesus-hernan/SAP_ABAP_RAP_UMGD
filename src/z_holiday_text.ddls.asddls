@AbapCatalog.sqlViewName: 'ZVB_HOLITXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text'
@UI: {headerInfo: {typeName: 'Translation',
  typeNamePlural: 'Translations',
           title: { type: #STANDARD,
                   value: 'spras' } } }
define view Z_HOLIDAY_TEXT
  as select from zcal_holitxt_000
  association to parent Z_I_HOLIDAY as _PublicHoliday on $projection.holiday_id = _PublicHoliday.holiday_id
{
      @UI.facet: [
         {
           id: 'HolidayText',
           label: 'Translation',
           targetQualifier: 'Translation',
           type: #FIELDGROUP_REFERENCE,
           position: 1
         }
       ]
      //zcal_holitxt_000
      @UI.fieldGroup: [{ position: 1,
                          qualifier: 'Translation',
                          label: 'Language Key'}]
      @UI.lineItem: [{ position: 1 }]
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Language', element: 'Language' }}]
  key spras,
  key holiday_id,
      @UI.fieldGroup: [{ position: 2,
                          qualifier: 'Translation',
                          label: 'Translated Text' }]
      @UI.lineItem: [{ position: 2, label: 'Translation' }]
      fcal_description,
      _PublicHoliday
}
