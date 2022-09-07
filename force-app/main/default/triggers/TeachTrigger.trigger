trigger TeachTrigger on Teach__c (before insert, before update) {
    fflib_SObjectDomain.triggerHandler(Teachs.class);
}