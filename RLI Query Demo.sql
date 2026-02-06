-- This query is for demonstration purposes only, all table names have been changed and column names are kept vague. 
-- This file does not connect to a real database due to privacy and legal reasons. 
-- Author: Olivia Rueschhoff

Use Database;
with xmlnamespaces(DEFAULT 'https://tempuri.org/')
cteInsurance as (
  SELECT
    Policy.policy_id as PolicyNumber,
    Contract.contract_name as AccountName,
    ContractInfo.active_on as EffectiveDate,
    ContractInfo.expires_on as ExperationDate,
    ActuarialInfo.RLI_Bound_Prem as BoundPremium,
    ActuarialInfo.RLI_Gross
