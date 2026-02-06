/****************************************************************************************
Author: Olivia Rueschhoff

Project: Mock Insurance/RLI SQL Reporting Query

Description:
This query is a demonstration of SQL reporting workflows inspired by
industry insurance terms and analytics. All table names, column names, and
database references have been changed to remove proprietary or confidential
information.

Purpose:
• Demonstrate multi-table relational querying
• Demonstrate XML data extraction using CROSS APPLY and XPath
• Showcase conditional aggregation logic
• Demonstrate policy version control filtering
• Illustrate reporting-focused SQL design

Disclaimer:
This query does NOT connect to a real production database and is intended solely
for portfolio and demonstration purposes.

This query simulates data preparation logic used to feed PowerBI dashboards.
****************************************************************************************/

Use MockInsuranceDB;
with xmlnamespaces(DEFAULT 'https://tempuri.org/')
cteInsurance as (
  SELECT
    Policy.policy_id as PolicyNumber,
    Policy.version as PolicyVersion,
    Contract.contract_name as AccountName,
    ContractInfo.active_on as EffectiveDate,
    ContractInfo.expires_on as ExpirationDate,
    ActuarialInfo.RLI_Bound_Prem as BoundPremium,
    ActuarialInfo.RLI_Gross_Prem as GrossPremium,
    PolicyCodes.extensionID as ExtensionID,
    ContractCodes.application_extensionID as AppExtensionID,
    State.value as State,
    Extension.extensiontree.value('(xmlStart/PolicyInfo/[./ProductType = ''ABC'']/PolicyValues/Deductible)[1]', 'float') as Deductible,
    AppExtension.extensiontree.value('(ApplicationExtension/Customer/Profile/Risks/[./RisksInfo/Info/RatingRank = ''Top'']/RisksStat/LossProbability/Value)[1]', 'float') as LossProb,
    AppExtension.extensiontree.value('(ApplicationExtension/Customer/Profile/Contract/ContractInfo/Company/CompanyInfo/Product/ProductInsured)[1]', 'nvarchar(50)') as InsuredProduct,
    NumericalData.nd.value('(Values/Type/[./TypeName = ''Code'']/Info/Value)[1]', 'int') as TypeValue,
    NumericalData.nd.value('(Values/Type/[./TypeName = ''Code'']/Update/Version/[./VersionProfile/VersionType = ''Now'']/Changed/Info)', 'nvarchar(100)') as RecentChanges,
    Case
      WHEN Extension.extensiontree.value('(xmlStart/PolicyInfo/Coverage/CoverageType/CoverageTypeAbbrev)') in ('ABC', 'DEF', 'GHI')
        Then SUM(NumericalData.nd.value('(Path/Actuary/ActuaryInfo/Add/Info/Numerical/Premium/PolicyPrem)[1]', 'float'))
      Else AVG(NumericalData.nd.value('(Path/Actuary/ActuaryInfo/Average/Info/Numerical/Premium/PolicyPrem)[1]', 'float'))
    End as AggPremium
    
  
  FROM
    RLI_POL_VAL_INFO Policy
    left join RLI_ACC_CON Contract on (Contract.contract_id = Policy.contract_id)
    left join RLI_ACC_CON_INFO ContractInfo on (ContractInfo.contract_info_id = Contract.contract_info_id)
    left join RLI_TEAM on (RLI_TEAM.team_code = Policy.team_code)
    left join ACTU_TEAM Actuarial on (Actuarial.ActuarialID = Contract.actuarial_id and RLI_TEAM.team_name = 'Actuarial')
    inner join ACTU_TEAM_INFO ActuarialInfo on (ActuarialInfo.ActuarialInfoID = Actuarial.ActuarialInfoID)
    left join RLI_POL_CODE PolicyCodes on (PolicyCode.codeID = Policy.codeID and PolicyCodes.codeID IS NOT NULL)
    left join RLI_ACC_CON_CODE ContractCodes on (ContractCodes.contract_id = Contract.contract_id)
    left join RLI_OTHER_MAPPING State on (ContractInfo.State_Num = State.AttributeValue and State.AttributeName = 'StateName' and State.ObjectCode = 12345)
    left join MOCKDatabase_xml.db.XMLExtensions Extension on (Extension.ID = PolicyCodes.ExtensionID)
    left join MOCKDatabase_xml.db.APPXMLExtensions AppExtension on (AppExtension.ID = ContractCodes.AppExtensionID)
    CrossApply (Extension.extensiontree.nodes('(xmlStart/Values/Important/Info/Rows/Data/DataSheets/Numerical/NumericalData)') as NumericalData(nd)

  Where 
    Policy.policyID <> ' ' 
    AND (Contract.Type like 'AB%' OR Contract.Type like 'CD%')
    AND ContractInfo.active_on <= CAST(GETDATE() AS DATE)
    AND ContractInfo.expires_on >= CAST(GETDATE() AS DATE)
    AND ActuarialInfo.status_code in (1, 3, 4, 5)

  Group By 
    Policy.policy_id,
    Contract.contract_name,
    ContractInfo.active_on,
    ContractInfo.expires_on,
    ActuarialInfo.RLI_Bound_Prem,
    ActuarialInfo.RLI_Gross_Prem,
    PolicyCodes.extensionID,
    ContractCodes.application_extensionID
)
-- Select most recent version of policy
Select 
    PolicyNumber,
    PolicyVersion,
    AccountName,
    EffectiveDate,
    ExperationDate,
    BoundPremium,
    GrossPremium,
    ExtensionID,
    AppExtensionID,
    State,
    Deductible,
    LossProb,
    InsuredProduct,
    TypeValue,
    RecentChanges,
    AggPremium,
    (AggPremium + BoundPremium + GrossPremium) as TotalPremium
  From 
    cteInsurance
  Where PolicyVersion = (select max(policyversion) from cteInsurance i where i.PolicyNumber = cteInsurance.PolicyNumber)
  Group By
    PolicyNumber,
    PolicyVersion,
    EffectiveDate,
    ExperationDate,
    BoundPremium,
    GrossPremium,
    ExtensionID,
    AppExtensionID,
    State,
    Deductible,
    LossProb,
    InsuredProduct,
    TypeValue,
    RecentChanges,
    AggPremium
  -- Only keep policies tied to one account
  Having Count(AccountName) = 1
  
