@EndUserText.label: 'Employees'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity z_c_employees
  as projection on z_i_employees
{
      @ObjectModel.text.element: ['EmployeeName']
  key e_number       as EmployeeNumber,
      e_name         as EmployeeName,
      e_department   as EmployeeDepartment,
      status         as EmployeeStatus,
      job_title      as JobTitle,
      start_date     as StartDate,
      end_date       as EndDate,
      email          as Email,
      @ObjectModel.text.element: ['ManagerName']
      m_number       as ManagerNumber,
      m_name         as ManagerName,
      m_department   as ManagerDepartment,
      crea_date_time as CreatedOn,
      @Semantics.user.createdBy: true
      crea_uname     as CreatedBy,
      lchg_date_time as ChangedOn,
      @Semantics.user.lastChangedBy: true
      lchg_uname     as ChangedBy

}
