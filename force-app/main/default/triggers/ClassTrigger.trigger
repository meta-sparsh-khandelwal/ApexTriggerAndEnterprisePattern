trigger ClassTrigger on Class__c (before delete, after update) {
    fflib_SObjectDomain.triggerHandler(Classes.class);
}