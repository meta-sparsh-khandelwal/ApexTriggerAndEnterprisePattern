trigger StudentTrigger on Student__c (before insert, after insert, after update, after delete) {
    fflib_SObjectDomain.triggerHandler(Students.class);
}